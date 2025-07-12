void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv = uv* 2. - 1.;
    uv.x *= iResolution.x / iResolution.y;
    vec2 gPos = floor(uv * 3.0);
    vec3 col = fract(vec3(gPos.x, gPos.y, 0) * 0.3);

    fragColor = vec4(col,1.0);
}