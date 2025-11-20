void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
  float a = iTime * 1.0; 

  // rotation matrix
  mat2 rot = mat2(
      cos(a), -sin(a),
      sin(a),  cos(a)
  );

  vec2 uv = (fragCoord - iResolution.xy * 0.5) / iResolution.y;
  uv *= rot;
  float square = step(0.2, max(abs(uv.x), abs(uv.y )));
  fragColor = vec4(vec3(1.0) * square, 1.0);
}