vec2 foldX(vec2 p) {
    p.x = abs(p.x);
    return p;
}

vec2 foldY(vec2 p) {
    p.y = abs(p.y);
    return p;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    uv = foldX(uv);
    uv = foldY(uv);
    float circle = step(0.1, length(uv - vec2(0.3, 0.3)));
    float square = step(0.1, max(abs(uv.x - 0.2), abs(uv.y - 0.23)));
    fragColor = vec4(circle, min(square, circle), min(square, circle), 1.0);
}