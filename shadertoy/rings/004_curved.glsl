float ring(float inner, float outer, float dist) {
    return step(dist, outer) - step(dist, inner);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec2 size = vec2(0.15, 0.1); // width and height of the rectangle
    vec2 d = abs(uv) - size;
    float dist = length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);

    vec3 col = vec3(0.0);
    col += vec3(1.0, 0.0, 0.0) * ring(0.25, 0.3, dist);
    col += vec3(0.0, 0.0, 5.0) * ring(0.15, 0.2, dist);
    col += vec3(0.0, 7.0, 0.0)  * ring(0.05, 0.1, dist);

    fragColor = vec4(pow(col * dist, vec3(0.4545)), 1.0); // do anki for pow and research how it works
}