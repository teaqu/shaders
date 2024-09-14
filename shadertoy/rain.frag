vec3 rainCol = vec3(0.5608, 0.4078, 0.9843);
vec3 skyCol = vec3(0.0, 0.3686, 1.0);

float random(vec2 uv) {
  return fract(sin(uv.x * 1920. + uv.y * 3092.) * 4039.);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    uv = fragCoord/iResolution.xy * 2.0 - 1.0;
    uv.y += 0.9;

    uv *= 1.0;
    float wave = sin(uv.x * 90.0) * 0.004 * sin(uv.y + iTime * 30.);
    vec3 col;
    if (uv.y > wave) {
      uv /= 3.0;
      float rain = sin(uv.y * 4. + iTime * 9.0 * random(uv.xx));
      rainCol *= step(uv.y, rain);
      col = mix(rainCol * rain, skyCol, 0.6); 
    } else {
      col = mix(rainCol, skyCol, 0.6);
    }
    fragColor = vec4(col, 1.0);
}