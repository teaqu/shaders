void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    float waves = sin(uv.y  * 25. + sin(iTime) + sin(uv.x * (sin(iTime / 5.) + 3.25) * 5. 
      + 15. + iTime + sin(iTime))) * 10.;
    waves = 1. / waves;
    vec3 col = vec3(0.11, 0.06, 0.75);
    fragColor = vec4(col + waves, 1);
}