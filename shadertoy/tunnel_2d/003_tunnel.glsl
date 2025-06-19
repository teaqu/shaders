vec3 revcol(float r, float g, float b) {
    return vec3(1.0 - r, 1.0 - g, 1.0 - b);
}

float ring(float outer, float inner, vec2 uv) {
    float inOuter = step(max(abs(uv.x), abs(uv.y)), outer);
    float inInner = step(max(abs(uv.x), abs(uv.y)), inner);
    return inOuter - inInner;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(1.0);
    float sq = max(abs(uv.x), abs(uv.y));
    
    float t = sin(iTime) / 1.;
    
    float sq1 = smoothstep(0.1, 0.01, max(abs(uv.x), abs(uv.y)));
    
    float sqt = t / 2.0;
    float sq2 = smoothstep(0.2, 0.21, max(abs(uv.x), abs(uv.y)));
    float sq22 = smoothstep(0.18, 0.185, max(abs(uv.x), abs(uv.y)));
 
    float sq3 = smoothstep(0.3, 0.31, max(abs(uv.x), abs(uv.y)));
    float sq4 = smoothstep(0.1, 0.01, max(abs(uv.x), abs(uv.y)));
    col += sq1;
    
    float ring1 = ring(0.3 + t, 0.25 + t, uv);
    float ring2 = ring(0.4 + t, 0.45 + t, uv);

    col =  vec3(1.0) * sq; // Red square ring

    // Depth animation for the tunnel
    float speed = 0.5;
    float depth = mod(1.0 / sq + iTime * speed, 1.0);

    // Determine the active face of the square tunnel
    // https://www.shadertoy.com/view/MXGcDK
    if (abs(uv.x) > abs(uv.y)) {
        // Left or right faces
        if (uv.x > 0.0) {
            // Right face
            uv.x = (uv.y + 1.0) * 0.5;  // Map y-coordinate to [0, 1]
            uv.y = depth;             // Map depth to y-axis
        } else {
            // Left face
            uv.x = (1.0 - uv.y) * 0.5; // Flip y-coordinate for left face
            uv.y = depth;             // Map depth to y-axis
        }
    } else {
        // Top or bottom faces
        if (uv.y > 0.0) {
            // Top face
            uv.x = (uv.x + 1.0) * 0.5;  // Map x-coordinate to [0, 1]
            uv.y = 1.- depth;              // Map depth to y-axis
        } else {
            // Bottom face
            uv.x = (uv.x + 1.0) * 0.5;  // Map x-coordinate to [0, 1]
            uv.y = depth;        // Flip depth for bottom face
        }
    }
    
    vec2 uvc = uv;
    
     if (uvc.y > 0.7) {
        col.z += 0.1;
     }

    vec4 tex = texture(iChannel0, uv);
    tex = vec4(tex.x) * 0.04;
    
    fragColor = tex + vec4(col,1.0);
}