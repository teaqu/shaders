// 3D fractal with ray marching — extends the 2D fractal into 3D space
// Uses the original fold-based fractal logic with camera movement

#define MAX_STEPS 80
#define MAX_DIST 50.0
#define SURF_DIST 0.01

// 3D distance field: sample the 2D fractal along the ray
// "Solid" approach: use distance to the fractal pattern as a height field
float distanceField(vec3 p, float t) {
    // Extract XY from 3D space (Z becomes "height" probe)
    vec2 uv = p.xy;
    
    // Apply original 2D fractal logic
    float factor1 = 1.0;
    uv = abs(5.0 - mod(uv * factor1, 10.0)) - 5.0;
    
    float ot = 1000.0;
    for (int i = 0; i < 4; i++) {
        uv = abs(uv) / clamp(uv.x * uv.y, 0.25, 2.0) - 1.0;
        if (i > 0) {
            float d = abs(uv.x) + 0.7 * fract(abs(uv.y) * 0.05 + t * 0.05 + float(i) * 0.3);
            ot = min(ot, d);
        }
    }
    
    float fractalGlow = exp(-8.0 * ot);
    
    // Create a 3D structure: use fractal glow as a shell thickness
    // Distance is: how far from the fractal surface (in 3D)
    float shellDist = abs(p.z - fractalGlow * 2.0) - 0.3;
    
    // Also add some volumetric effect near the fractal
    float volumeEffect = max(0.0, fractalGlow - 0.1) * 2.0;
    
    return max(shellDist, -volumeEffect);
}

vec3 getNormal(vec3 p, float t) {
    float eps = 0.002;
    return normalize(vec3(
        distanceField(p + vec3(eps, 0, 0), t) - distanceField(p - vec3(eps, 0, 0), t),
        distanceField(p + vec3(0, eps, 0), t) - distanceField(p - vec3(0, eps, 0), t),
        distanceField(p + vec3(0, 0, eps), t) - distanceField(p - vec3(0, 0, eps), t)
    ));
}

float rayMarch(vec3 ro, vec3 rd, float t) {
    float dist = 0.0;
    for (int i = 0; i < MAX_STEPS; i++) {
        vec3 p = ro + rd * dist;
        float d = distanceField(p, t);
        if (d < SURF_DIST || dist > MAX_DIST) break;
        dist += d * 0.7;
    }
    return dist;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    
    float t = iTime * 0.5;
    
    // Animated camera orbiting the fractal
    vec3 ro = vec3(
        3.0 * sin(t * 0.5),
        2.0 + 1.0 * sin(t * 0.3),
        3.0 * cos(t * 0.5)
    );
    vec3 ta = vec3(0.0, 0.0, 0.0);
    
    // Build ray direction
    vec3 forward = normalize(ta - ro);
    vec3 right = normalize(cross(vec3(0, 1, 0), forward));
    vec3 up = cross(forward, right);
    vec3 rd = normalize(forward + uv.x * right * 1.0 + uv.y * up * 1.0);
    
    // Ray march
    float dist = rayMarch(ro, rd, t);
    
    // Shading
    vec3 col = vec3(0.01); // dark background
    if (dist < MAX_DIST) {
        vec3 p = ro + rd * dist;
        vec3 n = getNormal(p, t);
        vec3 lightDir = normalize(vec3(2.0, 3.0, 2.0));
        
        float diff = max(dot(n, lightDir), 0.0);
        float spec = pow(max(dot(reflect(-lightDir, n), -rd), 0.0), 32.0);
        
        // Animated base color
        vec3 baseColor = vec3(
            1.1, 
            0.4 + 0.2 * sin(t * 0.2), 
            0.25 + 0.15 * cos(t * 0.15)
        );
        
        col = baseColor * (diff * 1.2 + spec * 0.6);
    }
    
    // Fog
    float fog = 1.0 - exp(-dist * 0.08);
    col = mix(col, vec3(0.01), fog);
    
    col = pow(col, vec3(0.85)); // soft gamma
    fragColor = vec4(col, 1.0);
}
