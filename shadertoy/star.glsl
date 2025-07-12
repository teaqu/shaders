void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord / iResolution.xy) * 2.0 - 1.0;
    uv *= 2.0 + 1.0;
    vec3 col = vec3(1);
    float s = smoothstep(0.0, 0.01, cos(uv.x * uv.y + iTime));
    fragColor = vec4(col - s, 1.0);
}