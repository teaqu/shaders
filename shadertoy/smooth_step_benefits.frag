// Noticed I got a lot of aliasing artifacts / moire patterns with this shader when using step.
// Smooth step appears to fix this very well. Good to know...
// Apparently according to chatgpt the issue is one the scren resolution and two,
// A circular pattern with a regular pixel grid leading to discrepencies. 
void mainImage( out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
  float d = length(uv);
  d = sin(d * 50.0 - iTime);
  d = sin(iTime) > 0.0 ? step(0.5, d) : smoothstep(0.2, 0.5, d);
  vec3 col = mix(vec3(0.0, 0.3, 0.9), vec3(1.0), d);
  fragColor = vec4(col, 1.0);
}