void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
  vec2 uv = fragCoord.xy / iResolution.xy;
    uv = uv* 2. - 1.;
    uv.x *= iResolution.x / iResolution.y;
    uv *= 3.0;
    
    uv.x += iTime;
    vec2 gridPos = floor(uv);
    
    vec3 col1 = fract(vec3(gridPos.x, gridPos.y - gridPos.x, gridPos.x + gridPos.y) * 0.3);
    
    uv = fract(uv);
    float grid = max(abs(uv.x), abs(uv.y)) - 0.95;
    grid = smoothstep(0.01, 0.015, grid);

    fragColor = vec4(1.0 - col1 - grid, 1.0);
}