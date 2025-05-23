
#iChannel0 "file://planets_move.glsl"

#define SPEED 0.05
#define MAX_STEPS 1000
#define MAX_DIST 200.0
#define SURFACE_DIST .001

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
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{   
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 m = (iMouse.xy * 2. - iResolution.xy) / iResolution.y;
    vec3 camera = texture(iChannel0, vec2(vec2(0, 0.1))).xyz;
    vec3 direction = texture(iChannel0, vec2(vec2(0, 0.9))).xyz;
    vec3 ro = camera.xyz; // camera, ray origin
    vec3 rd = normalize(vec3(vec3(uv, 1.0)));

    planets[0] = vec4(0, 0, 0, 0.51); // last no radius
    planets[1] = vec4(sin(iTime), 0, cos(iTime), 0.052);
    planets[2] = vec4(sin(iTime * 2.0 + 20.0), cos(iTime * 2.0 + 20.0), cos(iTime * 2.0 + 20.0), 0.052);
    planets[3] = vec4(sin(iTime + 20.0), 0, sin(iTime), 0.052);
    planets[4] = vec4(sin(iTime * 3.0 + 30.0), sin(iTime * 3.0), 0, 0.052);
    
    float d = rayMarch(ro, rd);
    vec3 col = vec3(0.05);
    if (d < MAX_DIST) {
        vec3 p = (ro + rd * d);
        col = getColour(p);
        if (col == colours[0]) {
            col = p; // while testing
        }
    }
    
    fragColor = vec4(col,1.0);
}