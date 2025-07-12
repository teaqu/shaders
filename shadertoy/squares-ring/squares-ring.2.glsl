#define gx 25.0
#define gy 25.0

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 uv = fract((fragCoord / iResolution.xy) * 1.0) - 0.5;
  uv = 0.02 / uv;
  vec2 uGrid = vec2(abs(uv.x * gx), abs(uv.y * gy));
  vec2 grid = floor(uGrid + iTime * 3.0);
  float ring = min(abs(grid.x), abs(grid.y));
  vec3 col = vec3(0.0001 * ring, 0.04 * ring, 0.02 * ring) * ring;
  fragColor = vec4(fract(col), 1.0);
}