#iChannel0 "./bond.png"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;
    float aspectRatio = iResolution.x / iResolution.y;
    vec2 auv = vec2(uv.x * aspectRatio, uv.y);
    vec4 bond = texture(iChannel0, uv);

    const float cRad = 0.4;
    const vec2 cPos = vec2(0.5, 0.5);

    // (x-h)^2 + (y-k)^2 < r^2
    if (pow(cos(iTime) + auv.x - cPos.x * aspectRatio, 2.0) + pow(auv.y - cPos.y, 2.0) < pow(cRad, 2.0)) {
        if (bond.a > 0.0) {
            fragColor = bond;
        } else {
            fragColor = vec4(1.0, 1.0, 1.0, 1.0);
        }
    } else {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
