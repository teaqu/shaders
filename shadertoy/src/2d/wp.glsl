void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 fuv = uv;
    fuv.x *= 40.0;
    vec3 col = vec3(0.2,0.6, 0.3);
    vec3 col2 = vec3(0.1,0.4, 0.9);
    vec3 col3 = vec3(1.0, 0.0, 0.0);
    
    vec3 wp;
    wp = smoothstep(1.4, 0.5, fract(vec3(fuv.x))) * 1.5;
    wp = smoothstep(0.1, 2.4, fract(vec3(fuv.x))) + 1.0;
    wp *= mix(col, mix(col2, col3, uv.y), uv.x);
    //wp = vec3(fract(fuv.x) + 1.0) * vec3(0.0, 0.4, 0.9);
    fragColor = vec4(wp,1.0);
}