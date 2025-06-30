#define MAX_STEPS 100
#define MAX_DIST 200.0
#define SURFACE_DIST .005

vec4[5] planets;
 const vec3[5] colours = vec3[5](
vec3(0.1, 0.5, 0.8),
    vec3(0.3),
    vec3(0.2, 1.0, 0.5),
    vec3(0.9, 0.3, 0.8),
    vec3(0.6, 0.5, 0.7)
);

float getLen(vec3 p, vec4 s) {
    // Get rotation from gimbal controls
    vec3 ypr = texelFetch(iChannel0, ivec2(1, 0), 0).xyz;
    float yaw = ypr.x;
    float pitch = ypr.y;
    float roll = ypr.z;
    
    // Create rotation matrices
    mat3 yawRot = mat3(
        cos(yaw), 0.0, sin(yaw),
        0.0, 1.0, 0.0,
        -sin(yaw), 0.0, cos(yaw)
    );
    
    mat3 pitchRot = mat3(
        1.0, 0.0, 0.0,
        0.0, cos(pitch), -sin(pitch),
        0.0, sin(pitch), cos(pitch)
    );
    
    mat3 rollRot = mat3(
        cos(roll), -sin(roll), 0.0,
        sin(roll), cos(roll), 0.0,
        0.0, 0.0, 1.0
    );
    
    // Combined rotation matrix
    mat3 rotation = yawRot * pitchRot * rollRot;
    
    // Transform the point to planet's local space
    vec3 planetCenter = s.xyz + vec3(0.5);
    vec3 localP = p - planetCenter;
    
    // Apply inverse rotation to the point (rotates the planet)
    localP = transpose(rotation) * localP;
    
    // Move back to world space
    vec3 rotatedP = localP + planetCenter;
    
    return length(rotatedP - 0.5 - s.xyz) - s.w;
}

float sdBoxFrame( vec3 p, vec3 b, float e )
{
       p = abs(p  )-b;
  vec3 q = abs(p+e)-e;
  return min(min(
      length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
      length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),
      length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0));
}


float frameDistance(vec3 p, float d) {
	return sdBoxFrame(vec3(fract(p.x), p.y + 2.0, fract(p.z)) - 0.5, vec3(0.5, 0.0, 0.5), d * 0.0009);
}

float getDist(vec3 p, float d) {
    // Planets
    float minDist = getLen(p, planets[0]);
    for (int i = 1; i < planets.length(); ++i) {
        float dist = getLen(p, planets[i]);
        if (dist < minDist) {
            minDist = dist;
        }
    }
    
   	// Floor
   	float frame = frameDistance(p, d);			
   	
    return min(frame, minDist);
}

vec3 getColour(vec3 p, float d) {
    float minDist = getLen(p, planets[0]);
    int mini = 0;
    for (int i = 1; i < planets.length(); ++i) {
        float dist = getLen(p, planets[i]);
        if (dist < minDist) {
            minDist = dist;
            mini = i;
        }
    }
    
    // Floor
    float frame = frameDistance(p, d);
   	if (frame < minDist) {
   		return vec3(min(max(5.0 / (d * 3.0), 0.05), 0.4));
   	} else {
   		return colours[mini];
   	}
}

float rayMarch(vec3 ro, vec3 rd) {
    float d = 0.0; // distance traveled
    for (int i = 0; i < MAX_STEPS; ++i) {
        vec3 p = ro + d * rd; // position along the ray
        float cd = getDist(p, d); // current distance
        d += cd; // march the ray
        if (cd < SURFACE_DIST || d > MAX_DIST) break;
    }
    return d;
}

vec3 calcDirection(vec2 uv) {
    vec3 ypr = texelFetch(iChannel0, ivec2(1, 0), 0).xyz; // yaw, pitch, roll
    float yaw = ypr.x;
    float pitch = ypr.y;
    float roll = ypr.z;

    vec3 forward = normalize(vec3(
        cos(pitch) * sin(yaw),
        sin(pitch),
        cos(pitch) * cos(yaw)
    ));

    // Choose a world up that is **not parallel** to forward
    vec3 worldUp = abs(forward.y) > 0.999 ? vec3(0.0, 0.0, 1.0) : vec3(0.0, 1.0, 0.0);

    vec3 right = normalize(cross(worldUp, forward));
    vec3 up = cross(forward, right);

    float cosR = cos(roll);
    float sinR = sin(roll);

    vec3 rolledRight = right * cosR - up * sinR;
    vec3 rolledUp    = right * sinR + up * cosR;

    return normalize(forward + uv.x * rolledRight + uv.y * rolledUp);
}

void genPlanets(float time) {
    vec3 ro = texelFetch(iChannel0, ivec2(0, 0), 0).xyz;
  	planets[0] = vec4(vec3(ro), 1.0); // last no radius
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (gl_FragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;

    vec3 direction = vec3(0);

	vec3 ro = vec3(1.0, 0.5, -5.0); // camera, ray origin
    
    vec3 rd = normalize(vec3(uv, 1));

    genPlanets(iTime);
    
    float d = rayMarch(ro, rd);
    vec3 col = vec3(0.05);
    if (d < MAX_DIST) {
        vec3 p = (ro + rd * d);
        col = getColour(p, d);
        if (col == colours[0]) {
            col = (ro + rd * d);
        }
    }

    fragColor = vec4(col, 1.0);
}