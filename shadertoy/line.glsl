float plot(vec2 uv) {
    float y = abs(uv.y - sqrt(uv.x));
    return smoothstep(0.02, 0.00, y);
    // return smoothstep(0.02, 0.00, abs(uv.x - pow(uv.y, 2.0)));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv = uv * 2.0 - 1.0;
    float blend = smoothstep(-1.0, 1.0, uv.x);
    float line = plot(uv);
    vec3 lineCol = vec3(1.0, 0.0, 1.0);
    fragColor = vec4((1.0 - line) * blend + line * lineCol, 1.0);
    // fragColor = vec4(line * lineCol, 1.0);
}