float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(4447.282704363,33362.3737))) * 138.38373737);
}


void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv = uv* 2. - 1.;
    uv.x *= iResolution.x / iResolution.y;
    uv *= 3.0;
    
    vec2 grid = fract(uv);
    vec2 gridPos = floor(uv);
    
    vec3 gridCol = fract(vec3(0.0, 0.0, gridPos.x * gridPos.y + 5.0) * 0.3);
    
    float timeFactor = iTime / 2.0 + random(gridPos);
    float ranTime = floor(timeFactor);
    float fractTime = fract(timeFactor);
    float rand = random(gridPos / ranTime);
        
    if (rand > 0.45) {
        gridCol = vec3(gridCol + sin(fractTime * 3.0));
    }
    
    float gridBorder = max(abs(grid.x), abs(grid.y)) - 0.95;
    gridBorder = smoothstep(0.01, 0.015, gridBorder);

    fragColor = vec4(gridCol + gridBorder, 1.0);
}