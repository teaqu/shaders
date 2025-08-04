#define MAX_STEPS 300
#define MAX_DIST 100.0
#define SURFACE_DIST .005

vec4 jelly1 = vec4(6, 0, 0, 0.51);
vec4 jelly2 = vec4(6, 0, 0, 0.51);

// r = sphere's radius
// h = cutting's plane's position
// t = thickness
float sdCutHollowSphere( vec3 p, float r, float h, float t )
{
    vec2 q = vec2( length(p.xz), p.y );
    
    float w = sqrt(r*r-h*h);
    
    return ((h*q.x<w*q.y) ? length(q-vec2(w,h)) : 
                            abs(length(q)-r) ) - t;
}

float getLen(vec3 p, vec4 s) {
    return length(p - 0.5 - s.xyz) - s.w;
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
	return sdBoxFrame(vec3(fract(p.x / 2.0), p.y + 2.0, fract(p.z / 2.0)) - 0.5, vec3(0.5, 0.0, 0.5), d * 0.0009);
}

float jellyDist(vec3 p) {
    jelly1 += (sin(p.y + iTime) + 1.0)/10.0;
    return getLen(p, jelly1);
}

float jellyDist2(vec3 p) {
    float jt = sin(iTime);
    return sdCutHollowSphere(-p, 0.7, 0.0 + jt * 0.05, 0.01);
}

float getDist(vec3 p, float d) {
   	float f = frameDistance(p, d);	
    float j = jellyDist(p);
    float j2 = jellyDist2(p);		
    return min(f, min(j, j2));
}

vec3 getColour(vec3 p, float d) {
   	float f =frameDistance(p, d);	
    float j = jellyDist(p);
    float j2 = jellyDist2(p);
    
   	if (f < j && f < j2) {
   		return vec3(0.2, 0.6, 1.0);
   	} else {
   		return vec3(0.2, 0.6, 1.0) + p.y;
   	}
}

float rayMarch(vec3 ro, vec3 rd) {
    float d = 0.0;
    for (int i = 0; i < MAX_STEPS; ++i) {
        vec3 p = ro + d * rd;
        float cd = getDist(p, d);
        d += cd;
        if (cd < SURFACE_DIST || d > MAX_DIST) break;
    }
    return d;
}

vec3 calcDirection(vec2 uv) {
    vec3 ypr = texelFetch(iChannel0, ivec2(1, 0), 0).xyz;
    float yaw = ypr.x;
    float pitch = ypr.y;
    float roll = ypr.z;

    vec3 forward = normalize(vec3(
        cos(pitch) * sin(yaw),
        sin(pitch),
        cos(pitch) * cos(yaw)
    ));

    vec3 worldUp = abs(forward.y) > 0.999 ? vec3(0.0, 0.0, 1.0) : vec3(0.0, 1.0, 0.0);
    vec3 right = normalize(cross(worldUp, forward));
    vec3 up = cross(forward, right);
    float cosR = cos(roll);
    float sinR = sin(roll);
    vec3 rolledRight = right * cosR - up * sinR;
    vec3 rolledUp    = right * sinR + up * cosR;

    return normalize(forward + uv.x * rolledRight + uv.y * rolledUp);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (gl_FragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;
    vec3 direction = vec3(0);
    vec3 ro = texelFetch(iChannel0, ivec2(0, 0), 0).xyz;
	vec3 rd = calcDirection(uv);
    
    float d = rayMarch(ro, rd);
    vec3 col = vec3(0.0, 0.2, 0.5);
    if (d < MAX_DIST) {
        vec3 p = (ro + rd * d);
        col = getColour(p, d);
        if (col == jelly1.xyz) {
            col = (ro + rd * d);
        }
    }

    fragColor = vec4(col, 1.0);
}