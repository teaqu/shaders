#define gx 15.0
#define gy 10.0

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
  vec2 uv = fragCoord / iResolution.xy;
  vec2 uGrid = vec2(uv.x * gx, uv.y * gy);
  vec2 grid = floor(uGrid);
  vec2 gb = smoothstep(0.01, 0.03, fract(uGrid));
  vec3 col = vec3(grid.x / gx, grid.y / gy, 1.0);
  fragColor = vec4(col * gb.x * gb.y, 1.0);
}