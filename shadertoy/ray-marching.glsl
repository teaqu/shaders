// https://youtu.be/PGtv-dBi2wE
// https://youtu.be/khblXafu7iA

#define MAX_STEPS 50
#define MAX_DIST 100.
#define SURFACE_DIST .01

float smin(float a, float b, float k) {
    float h = max(k-abs(a-b), 0.0)/k;
    return min(a,b) - h*h*h*k*(1.0/6.0);
}

float sdBox(vec3 p, vec3 b) {
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

vec3 rot3D(vec3 p, vec3 axis, float angle) {
    // Rdrigues' rotation formula
    return mix(dot(axis, p) * axis, p, cos(angle))
        + cross(axis, p) * sin(angle);
}

mat2 rot2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

float getDist(vec3 p) {
    vec4 sphere = vec4(0, 1, 5, 1); // last no radius
    // Translation negative as we move the ray not the sphere.
    float ds = length(p - sphere.xyz) - sphere.w; // sphere sdf
    float dp = p.y; // distance to plane
    
    vec3 q = p - vec3(sin(iTime) * 2.5, 1.0, 4.0);
    q.xy *= rot2D(iTime);
    float db = sdBox(q, vec3(0.35));
    
    float d = min(smin(ds, db, 2.0), dp);
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

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord.xy - .5 * iResolution.xy) / iResolution.y;
    vec2 m = (iMouse.xy - .5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(0);
    
    // Initialization
    vec3 ro = vec3(0, 1, 0); // camera, ray origin
    
    // ray direction for each pixel
    // We normalize so all have length of 1 which crutial for distance calculations
    vec3 rd = normalize(vec3(uv, 1));
    
    // Raymarching
    // d = distance traveled
    float d = rayMarch(ro, rd);
    
    // Scale to < 1 so we can see
    d /= 6.0;
    
    // Set to color based on distance
    col = vec3(d);
    
    fragColor = vec4(col,1.0);
}