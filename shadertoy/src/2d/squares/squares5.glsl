void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
  vec2 uv = fragCoord.xy / iResolution.xy;
  uv = uv* 2. - 1.;
  uv.x *= iResolution.x / iResolution.y;
  vec2 ouv = uv;
  uv = fract(uv*3.);
  vec3 col = vec3(0.2,0.6, 0.3);
  vec3 col1 = fract(col*ouv.x*5.);
  // vec3 col2 = fract(col*(ouv.y)*5.);
  
  float l = max(abs(uv.x), abs(uv.y)) - 0.95;
  l = smoothstep(0.01, 0.015, l);

  fragColor = vec4(col1 - l,1.0);
}