#version 330

uniform vec2 uResolution;
uniform float uTime;
uniform vec4 uMouse;
uniform sampler2D uKeyboard;
uniform int uFrame;

uniform sampler2D uMoved; 

out vec4 outColor;

#define MAX_STEPS 1000
#define MAX_DIST 200.0
#define SURFACE_DIST .001

bool isKeyDown(int key) {
	return texelFetch(uKeyboard, ivec2(key, 0), 0).x == 1.0;
}

mat2 rotate2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}


vec4[5] planets;
const vec3[5] colours = vec3[5](
vec3(0.1, 0.5, 0.8),
    vec3(0.3),
    vec3(0.2, 1.0, 0.5),
    vec3(0.9, 0.3, 0.8),
    vec3(0.6, 0.5, 0.7)
);

float getLen(vec3 p, vec4 s) {
    return length(p - 0.5 - s.xyz) - s.w;
}

float getDist(vec3 p) {
    float minDist = getLen(p, planets[0]);
    for (int i = 1; i < planets.length(); ++i) {
        float dist = getLen(p, planets[i]);
        if (dist < minDist) {
            minDist = dist;
        }
    }
    return minDist;
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
    return colours[mini];
}
// com
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
void main()
{   
    vec2 uv = (gl_FragCoord.xy * 2.0 - uResolution.xy) / uResolution.y;
    vec2 m = (uMouse.xy * 2. - uResolution.xy) / uResolution.y;

    vec3 direction = vec3(0);

    vec3 ro = texelFetch(uMoved, ivec2(0, 0), 0).xyz; // camera, ray origin

    vec3 rd = normalize(vec3(vec3(uv, 1.0)));

    planets[0] = vec4(0, 0, 0, 0.51); // last no radius
    planets[1] = vec4(sin(uTime), 0, cos(uTime), 0.052);
    planets[2] = vec4(sin(uTime * 2.0 + 20.0), cos(uTime * 2.0 + 20.0), cos(uTime * 2.0 + 20.0), 0.052);
    planets[3] = vec4(sin(uTime + 20.0), 0, sin(uTime), 0.052);
    planets[4] = vec4(sin(uTime * 3.0 + 30.0), sin(uTime * 3.0), 0, 0.052);
    
    float d = rayMarch(ro, rd);
    vec3 col = vec3(0.05);
    if (d < MAX_DIST) {
        vec3 p = (ro + rd * d);
        col = getColour(p);
        if (col == colours[0]) {
            col = p; // while testing
        }
    }

    outColor = vec4(col,1.0);
}