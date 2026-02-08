float rectangleSDF(vec2 uv, vec2 size) {
    vec2 d = abs(uv) - size;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    float col = rectangleSDF(uv, vec2(0.55, 0.35));
    col = step(0.0, col);
    fragColor = vec4(vec3(col),1.0);
}