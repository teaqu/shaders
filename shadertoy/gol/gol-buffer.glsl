float gridX = 0.0;
float gridY = 0.0;

// 1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
// 2. Any live cell with two or three live neighbours lives on to the next generation.
// 3. Any live cell with more than three live neighbours dies, as if by overpopulation.
// 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

int getGridValue(vec2 grid) {
    vec2 pos = vec2(grid.x / gridX, grid.y / gridY) + vec2(1.0 / gridX * 0.5, 1.0 / gridY * 0.5);
    return texture(iChannel0, pos).xyz == vec3(0.0) ? 0 : 1;
}

int getNeighbours(vec2 grid) {
    return 8 - getGridValue(grid + vec2(1.0, 1.0))
         - getGridValue(grid + vec2(-1.0, -1.0))
        - getGridValue(grid + vec2(1.0, -1.0)) 
        - getGridValue(grid + vec2(-1.0, 1.0))
        - getGridValue(grid + vec2(0.0, -1.0))
        - getGridValue(grid + vec2(-1.0, 0.0))
        - getGridValue(grid + vec2(0.0, 1.0)) 
        - getGridValue(grid + vec2(1.0, 0.0));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    gridX = iResolution.x;
    gridY = iResolution.y;
    vec2 grid = floor(vec2(uv.x * gridX, uv.y * gridY));
    vec2 gridMouse = floor(vec2(iMouse.x * gridX, (iResolution.y - iMouse.y) * gridY)/iResolution.xy);

    vec3 col = vec3(float(getGridValue(grid)));
    int neighbours = getNeighbours(grid); 
    bool alive = getGridValue(grid) == 0;
    
    if (alive && (neighbours < 2 || neighbours > 3)) {
        col = vec3(1.0);
    } else if (!alive && neighbours == 3) {
        col = vec3(0.0);
    }
    
    if (gridMouse.x == grid.x || gridMouse.y == gridY - grid.y) {
        col = vec3(0.0);
    }
    
    fragColor = vec4(vec3(col), 1.0);
}