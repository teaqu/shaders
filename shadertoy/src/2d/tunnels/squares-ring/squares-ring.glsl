#define gx 15.0
#define gy 10.0

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord / iResolution.xy) * 2.0 - 1.0;
    vec2 uGrid = vec2(abs(uv.x * gx), abs(uv.y * gy));
    vec2 grid = floor(uGrid);
    vec2 gb = step(0.0, fract(uGrid));
    float ring = max(grid.x, grid.y);
    vec3 col = vec3(0.1 * ring / gy, 0.4 - ring / gx, 0.1 + ring / gy) * ring;
    fragColor = vec4(col, 1.0);
}