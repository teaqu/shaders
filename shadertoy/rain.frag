vec3 rainCol = vec3(0.5647, 0.4078, 0.9843);
vec3 skyCol = vec3(0.0, 0.3686, 1.0);

float random(vec2 uv) {
  return fract(sin(uv.x * 1920. + uv.y * 3092.) * 4039.);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    float wave = sin(uv.y * 18. + iTime * 9.0 * random(uv.xx));
    rainCol *= step(uv.y, wave);
    vec3 col = mix(rainCol* wave, skyCol, 0.4);
    float light = uv.y / 9.;
    fragColor = vec4(col + light , 0.2);
}