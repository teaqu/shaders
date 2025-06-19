// Another way to do circles
void mainImage( out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
  float d = length(uv);
  d = step(0.8, d);
  vec3 col = mix(vec3(0.0, 0.3, 0.9), vec3(1.0), d);
  fragColor = vec4(col, 1.0);
}