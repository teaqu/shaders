vec3 ealCol = vec3(0.5647, 0.4078, 0.9843);
vec3 seaCol = vec3(0.0, 0.3686, 1.0);
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    float wave = sin(uv.y * 6. -1.3 + sin(uv.x * 18. + iTime )) / 1.5;
    ealCol *= step(uv.x, wave);
    vec3 col = mix(ealCol * wave, seaCol, 0.4);
    float light = uv.y / 9.;
    if (uv.x < .65 && uv.x > 0.645 && wave > 0.666) {
        col = vec3(0.0);
    }
    fragColor = vec4(col + light , 0.2);
}
