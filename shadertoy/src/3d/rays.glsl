#define MAX_STEPS 4400
#define MAX_DIST 200.
#define SURFACE_DIST .01

vec3 rotate(vec3 p,vec3 axis,float theta){
vec3 v = cross(axis,p), u = cross(v, axis);
return u * cos(theta) + v * sin(theta) + axis * dot(p, axis);
}

vec2 pmod(vec2 p, float r){
    float a = mod(atan(p.y, p.x), (3.14*2.0) / r) - 0.5 * (3.14*2.0) / r;
    return length(p) * vec2(-sin(a), cos(a));
}


// https://jbaker.graphics/writings/DEC.html
float de(vec3 p){
for(int i=0;i<5;i++){
    p.xy = pmod(p.xy,12.0); p.y-=4.0;
    p.yz = pmod(p.yz,16.0); p.z-=6.8;
}

return dot(abs(p),rotate(normalize(vec3(2.0,1.,3.)),
    normalize(vec3(7,1,2)),1.8))-0.3;
}

float getDist(vec3 p) {
    float d = de(p);
    return d;
}

float rayMarch(vec3 ro, vec3 rd) {
    float d = 0.; // distance traveled
    for (int i = 0; i < MAX_STEPS; ++i) {
        vec3 p = ro + d * rd; // position along the ray
        float cd = getDist(p); // current distance
        d += cd; // march the ray
        if (cd < SURFACE_DIST || d > MAX_DIST) break;
    }
    return d;
}

vec3 getNormal(vec3 p) {
    float d = getDist(p);
    vec2 e = vec2(.001, 0);
    vec3 n = d - vec3(
        getDist(p - e.xyy),
        getDist(p - e.yxy),
        getDist(p - e.yyx)
    );
    return normalize(n);
}

vec3 lighting(vec3 p, vec3 rd, vec3 lightPos, vec3 lightCol) {
    vec3 n = getNormal(p);
    vec3 l = normalize(lightPos - p);
    vec3 v = -rd;
    vec3 h = normalize(l + v);
    
    float diff = max(dot(n, l), 0.0);
    float spec = pow(max(dot(n, h), 0.0), 32.0);
    
    vec3 col = lightCol * (diff + spec * 0.5);
    return col;
}

// Exponential fog — returns blend factor [0..1] (0 = no fog, 1 = full fog)
float calcFog(float dist, float density) {
    return clamp(1.0 - exp(-dist * density), 0.0, 1.0);
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

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
     vec2 uv = (gl_FragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;
    vec3 ro = texelFetch(iChannel0, ivec2(0, 0), 0).xyz;
	vec3 rd = calcDirection(uv);
    
    float d = rayMarch(ro, rd);
    vec3 bg = vec3(1.0); // white background
    vec3 col = bg;

    if (d < MAX_DIST) {
        vec3 p = ro + d * rd;
        
        // object base (dark) plus lighting
        vec3 base = vec3(0.02);
        vec3 lit = base;
        lit += lighting(p, rd, vec3(-5, -3, -3), vec3(0.1843, 0.3176, 0.5765)) * 0.5;
        lit += lighting(p, rd, vec3(5, 5, -5), vec3(0.1765, 0.0039, 0.549));
        col = clamp(lit, 0.0, 1.0);
    }

    // Apply fog blending to integrate objects into the white background.
    // Increase or decrease `fogDensity` to taste (smaller = less fog).
    if (d < MAX_DIST) {
        float fogDensity = 0.003; // tunable
        float f = calcFog(d, fogDensity);
        col = mix(col, bg, f);
    }

    fragColor = vec4(col, 1);
}