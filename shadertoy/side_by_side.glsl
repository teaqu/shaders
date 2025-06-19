void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Offset UVs for separate shapes
    vec2 uvSquare = uv + vec2(0.3, 0.0); // move square left
    vec2 uvCircle = uv - vec2(0.3, 0.0); // move circle right

    float sq = smoothstep(0.105, 0.1, max(abs(uvSquare.x), abs(uvSquare.y)));
    float c  = smoothstep(0.105, 0.1, length(uvCircle));

    vec3 col = vec3(1.0); // white background

    // Subtract shapes to make them visible
    col -= vec3(1.0, 0.0, 0.0) * sq; // red square
    col -= vec3(0.0, 0.0, 0.0) * c;  // white circle does nothing, so:
    col -= vec3(0.2) * c;            // dim circle to make it visible

    fragColor = vec4(col, 1.0);
}