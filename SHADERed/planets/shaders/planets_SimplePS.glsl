#version 440

#define MAX_STEPS 1000
#define MAX_DIST 200.0
#define SURFACE_DIST .001

layout(std430, binding = 0) buffer DataBuffer {
    vec3 camera;
    float yaw;
    float pitch;
    float roll;
};

uniform vec2 uResolution;
uniform float uTime;
uniform vec4 uMouse;
uniform sampler2D uKeyboard;
uniform int uFrame;

out vec4 outColor;

vec4[5] planets;
const vec3[5] colours = vec3[5](
	vec3(0.1, 0.5, 0.8),
    vec3(0.3),
    vec3(0.2, 1.0, 0.5),
    vec3(0.9, 0.3, 0.8),
    vec3(0.6, 0.5, 0.7)
);

bool isKeyDown(int key) {
	return texelFetch(uKeyboard, ivec2(key, 0), 0).x == 1.0;
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

float frameDistance(vec3 p) {

	return sdBoxFrame(vec3(fract(p.x), p.y + 2.0, fract(p.z)) - 0.5, vec3(0.5, 0.0, 0.5), 0.004);
}

float getDist(vec3 p) {
    // Planets
    float minDist = getLen(p, planets[0]);
    for (int i = 1; i < planets.length(); ++i) {
        float dist = getLen(p, planets[i]);
        if (dist < minDist) {
            minDist = dist;
        }
    }
    
   	// Floor
   	float d = frameDistance(p);
   	
    return min(d, minDist);
}

vec3 getColour(vec3 p) {
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
    float d = frameDistance(p);
   	if (d < minDist) {
   		return vec3(0.6);
   	} else {
   		return colours[mini];
   	}
}

float rayMarch(vec3 ro, vec3 rd) {
    float d = 0.0; // distance traveled
    for (int i = 0; i < MAX_STEPS; ++i) {
        vec3 p = ro + d * rd; // position along the ray
        float cd = getDist(p); // current distance
        d += cd; // march the ray
        if (cd < SURFACE_DIST || d > MAX_DIST) break;
    }
    return d;
}

vec3 calcDirection(vec2 uv) {
	vec3 forward = normalize(vec3(
		// sideways includes pitch as if ur looking up less to move sideways (x)
	    cos(pitch) * sin(yaw),
	    // up down (y)
	    sin(pitch),
	    // forward backwards (z)
	    cos(pitch) * cos(yaw)
	));
	
	vec3 right = normalize(cross(vec3(0.0, 1.0, 0.0), forward));
	vec3 up = cross(forward, right);
 
    float cosR = cos(roll);
    float sinR = sin(roll);

    vec3 rolledRight = right * cosR - up * sinR;
    vec3 rolledUp    = right * sinR + up * cosR;

    return normalize(forward + uv.x * rolledRight + uv.y * rolledUp);
}

void genPlanets(float time) {
  	planets[0] = vec4(0, 0, 0, 0.51); // last no radius
  	planets[1] = vec4(sin(time), 0, cos(time), 0.052);
    planets[2] = vec4(sin(time * 2.0 + 20.0), cos(time * 2.0 + 20.0), cos(time * 2.0 + 20.0), 0.052);
    planets[3] = vec4(sin(time + 20.0), 0, sin(time), 0.052);
    planets[4] = vec4(sin(time * 3.0 + 30.0), sin(time * 3.0), 0, 0.052);	
}

void main()
{
	genPlanets(uTime);
    vec2 uv = (gl_FragCoord.xy * 2.0 - uResolution.xy) / uResolution.y;

    vec3 ro = camera;
	vec3 rd = calcDirection(uv);

    float d = rayMarch(ro, rd);
    vec3 col = vec3(0.05);
    if (d < MAX_DIST) {
        vec3 p = (ro + rd * d);
        col = getColour(p);
        if (col == colours[0]) {
            col = (ro + rd * d);
        }
    }

    outColor = vec4(col,1.0);
}
