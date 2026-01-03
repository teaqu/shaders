void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col1 = vec3(1.0);
    vec3 col2 = vec3(0.6157, 0.0, 1.0);
    vec3 col = mix(col1, col2, smoothstep(-0.04, 0.05, uv.y));

    float circle = smoothstep(0.11, 0.1, length(uv));
    
    vec3 layer1 = smoothstep(0.9, 0.6, circle * vec3(1.0));
    vec3 layer2 = col * circle;

    fragColor = vec4(layer2 + layer1, 1.0);
}