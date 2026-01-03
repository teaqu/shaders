void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y; 
    
    float r = 0.5;
    vec2 pos = vec2(uv.x, uv.y);
    
    float l = max(abs(uv.x), abs(uv.y));
    
    l = 0.05 / l;

    // Repeat
    l = sin(l * 20.0 + iTime * 5.0);

    vec3 col = vec3(1.0) * l;
    
    col = step(0.9, col);

    fragColor = vec4(col, 1.0);
}