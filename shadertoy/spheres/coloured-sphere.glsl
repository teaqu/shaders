// https://youtu.be/PGtv-dBi2wE
// https://youtu.be/khblXafu7iA

#define MAX_STEPS 100
#define MAX_DIST 50.0
#define SURFACE_DIST .0001

mat2 rot2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

float getDist(vec3 p) {
    vec4 sphere = vec4(0, 0, 0, 0.1); // last no radius
    float ds = length(fract(p) - 0.5 - sphere.xyz) - sphere.w;
    return ds;
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

vec3 palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.283185*(c*t+d) );
}

vec3 GetNormal(vec3 p) {
    vec2 e = vec2(.001, 0);
    vec3 n = getDist(p) - 
        vec3(getDist(p-e.xyy), getDist(p-e.yxy),getDist(p-e.yyx));
    
    return normalize(n);
}

//vec3 GetRayDir(vec2 uv, vec3 p, vec3 l, float z) {
//    vec3 
//        f = normalize(l-p),
//        r = normalize(cross(vec3(0,1,0), f)),
//        u = cross(f,r),
//        c = f*z,
//        i = c + uv.x*r + uv.y*u;
//    return normalize(i);
//}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;
    vec2 m = (iMouse.xy * 2.0 - iResolution.xy) / iResolution.y;
    
    vec3 ro = vec3(0, 0, -5); // camera, ray origin
    vec3 rd = normalize(vec3(uv, 1));
    
    // Mouse
    ro.yz *= rot2D(-m.y);
    rd.yz *= rot2D(-m.y);
    
    ro.xy *= rot2D(-m.x);
    rd.xy *= rot2D(-m.x);

    float d = rayMarch(ro, rd);
    
    vec3 p = fract(ro + rd * d) - 0.5;
    uv = fract(p.xy) - 0.5;
    vec3 col = vec3(uv.x*uv.y);  
    
    fragColor = vec4(col,1.0);
}