void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    float ring1 = smoothstep(0.3, 0.295, max(abs(uv.x), abs(uv.y))) -
                  smoothstep(0.25, 0.255, max(abs(uv.x), abs(uv.y)));

    float ring2 = smoothstep(0.2, 0.195, max(abs(uv.x), abs(uv.y))) -
                  smoothstep(0.15, 0.155, max(abs(uv.x), abs(uv.y)));

    float ring3 = smoothstep(0.1, 0.095, max(abs(uv.x), abs(uv.y))) -
                  smoothstep(0.05, 0.055, max(abs(uv.x), abs(uv.y)));

    vec3 col = vec3(0.0);
    col += vec3(1.0, 0.0, 0.0) * ring1; // Red
    col += vec3(0.0, 1.0, 0.0) * ring2; // Green
    col += vec3(0.0, 0.5, 1.0) * ring3; // Blue-ish

    fragColor = vec4(col, 1.0);
}
