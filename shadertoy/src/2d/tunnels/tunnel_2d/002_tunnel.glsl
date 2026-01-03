vec3 revcol(float r, float g, float b) {
    return vec3(1.0 - r, 1.0 - g, 1.0 - b);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(1.0);
    float sq = max(abs(uv.x), abs(uv.y));
    
    float t = sin(iTime) / 1.;
    
    col =  vec3(1.0) * sq; // Red square ring

    // Depth animation for the tunnel
    float speed = 0.5;
    float depth = fract(1.0 / sq + iTime * speed);

    float speed2 = 0.1;
    float depth2 = fract(0.8 / sq / 44.0 + iTime * speed2);

    if (depth2 > 0.99) {
        col.z += 0.8;
    }
    
    if (depth2 > 0.4 && depth2 < 0.41) {
        col.y += 0.4;
    }

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
            uv.x = (uv.x - 1.0) * 0.5;  // Map x-coordinate to [0, 1]
            uv.y = depth;              // Map depth to y-axis
        } else {
            // Bottom face
            uv.x = (uv.x + 1.0) * 0.5;  // Map x-coordinate to [0, 1]
            uv.y = depth;        // Flip depth for bottom face
        }
    }

    vec4 tex = texture(iChannel0, uv);
    tex = vec4(tex.x) * 0.04;
    
    fragColor = tex + vec4(col,1.0);
}