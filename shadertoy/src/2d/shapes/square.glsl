float squareSDF(vec2 uv) {
    return max(abs(uv.x), abs(uv.y));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    float col = squareSDF(uv);
    col = step(0.4, col);
    fragColor = vec4(vec3(col),1.0);
}