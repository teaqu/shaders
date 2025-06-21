float ring(float inner, float outer, float dist) {
    return step(dist, outer) - step(dist, inner);
}

float sdHexagon(vec2 p, float r) {
    p = abs(p);
    return max(dot(p, normalize(vec2(1.0, sqrt(3.0)))), p.x) - r;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    float dist = sdHexagon(fract(uv * 3.0) - 0.5, 0.0) / 1.9;
    vec3 col = vec3(0.0);
    col += vec3(0.0, 0.8078, 0.4588) * ring(0.25, 0.3, dist);
    col += vec3(0.0, 0.0, 5.0) * ring(0.15, 0.2, dist);
    col += vec3(0.0, 7.0, 0.0) * ring(0.05, 0.1, dist);
    
    col = col * dist;
    col = pow(col, vec3(0.4549, 0.4549, 0.4549));
    col = fract(col * 20.0);

    fragColor = vec4(col, 1.0);
}