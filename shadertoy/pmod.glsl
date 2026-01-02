// 3D ray-march demo: keep it 3D and use pmod on the XZ plane

const float PI = 3.141592653589793;
#define MAX_STEPS 120
#define MAX_DIST 50.0
#define SURF_DIST 0.001

// Angular modulo: fold the angle of `p` into a single sector (r repeats)
vec2 pmod(vec2 p, float r){
    float sector = 2.0 * PI / r;
    float a = mod(atan(p.y, p.x), sector) - 0.5 * sector;
    return length(p) * vec2(-sin(a), cos(a));
}

// simple sphere SDF
float sdSphere(vec3 p, float s){ return length(p) - s; }

// scene: apply pmod to xz to create wedge repeats around Y
float mapWithR(vec3 p, float r){
    // fold xz around Y axis
    vec2 f = pmod(p.xz, r);
    vec3 pp = p; pp.x = f.x; pp.z = f.y;

    // place a sphere offset in folded space so repeats are visible around origin
    return sdSphere(pp - vec3(0.9, 0.0, 0.0), 0.25);
}

// raymarch that uses r
float rayMarchR(vec3 ro, vec3 rd, float r, out vec3 pOut){
    float t = 0.0;
    for(int i=0;i<MAX_STEPS;i++){
        vec3 p = ro + rd * t;
        float d = mapWithR(p, r);
        if(d < SURF_DIST) { pOut = p; return t; }
        if(t > MAX_DIST) break;
        t += max(0.001, d);
    }
    pOut = ro + rd * t;
    return 1e5;
}

vec3 getNormalR(vec3 p, float r){
    float eps = 0.0008;
    float dx = mapWithR(p + vec3(eps,0,0), r) - mapWithR(p - vec3(eps,0,0), r);
    float dy = mapWithR(p + vec3(0,eps,0), r) - mapWithR(p - vec3(0,eps,0), r);
    float dz = mapWithR(p + vec3(0,0,eps), r) - mapWithR(p - vec3(0,0,eps), r);
    return normalize(vec3(dx, dy, dz));
}

vec3 shadeR(vec3 p, vec3 rd, float r){
    vec3 n = getNormalR(p, r);
    vec3 light = normalize(vec3(3.0, 5.0, 4.0));
    float diff = max(dot(n, light), 0.0);
    vec3 refl = reflect(-light, n);
    float spec = pow(max(dot(refl, -rd), 0.0), 64.0);
    vec3 base = vec3(0.12, 0.25, 0.65);
    vec3 col = base * diff + vec3(1.0)*spec*0.6 + vec3(0.04);
    return col;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // camera
    vec3 ro = vec3(0.0, 0.2, 4.0);
    vec3 ta = vec3(0.0, 0.0, 0.0);
    vec3 forward = normalize(ta - ro);
    vec3 right = normalize(cross(vec3(0.0,1.0,0.0), forward));
    vec3 up = cross(forward, right);
    float fov = 1.0;
    vec3 rd = normalize(forward + uv.x * right * fov + uv.y * up * fov);

    // sectors (r) controlled by mouse X while pressed; otherwise default
    float r = 12.0;
    if(iMouse.z > 0.0) r = mix(3.0, 48.0, clamp(iMouse.x / iResolution.x, 0.0, 1.0));

    // raymarch and shading using functions that accept `r`
    vec3 pHit;
    float t = rayMarchR(ro, rd, r, pHit);
    vec3 col = vec3(1.0); // white background
    if(t < 1e4){
        vec3 color = shadeR(pHit, rd, r);
        // fog (distance-based) blending into white
        float fog = 1.0 - exp(-t * 0.25);
        col = mix(color, vec3(1.0), fog);
    }

    fragColor = vec4(col,1.0);
}
