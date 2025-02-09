
// Raymarching function (stub for distance field)
float sceneSDF(vec3 p) {
    // Example: A sphere at the origin
    return length(p) - 1.0;
}

// Raymarching function
float raymarch(vec3 ro, vec3 rd) {
    const int MAX_STEPS = 100;
    const float EPSILON = 0.001;
    float distance = 0.0;
    for (int i = 0; i < MAX_STEPS; i++) {
        float d = sceneSDF(ro + rd * distance);
        if (d < EPSILON) break;
        distance += d;
        if (distance > 100.0) break;
    }
    return distance;
}

// 3D rotation matrix for rotating around the Y axis (up axis)
mat3 rot3D_Y(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat3(
        c, 0.0, s,
        0.0, 1.0, 0.0,
        -s, 0.0, c
    );
}

// Main shader function
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized screen coordinates
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Camera parameters
    vec3 cameraPos = vec3(0.0, 0.0, 5.0); // Camera fixed at (0, 0, 5)
    float angle = iTime; // Rotate based on time

    // The direction the camera is looking at (initially along the -Z axis)
    vec3 forward = vec3(0.0, 0.0, -1.0);
    vec3 up = vec3(0.0, 1.0, 0.0); // The up axis for rotation

    // Rotate the forward vector around the Y-axis (up axis)
    mat3 rotation = rot3D_Y(angle);
    vec3 rotatedForward = rotation * forward;

    // Ray direction in world space (this determines where each ray is pointing)
    vec3 rayDir = normalize(rotatedForward + uv.x * cross(up, rotatedForward) + uv.y * up);

    // Raymarch the scene
    float distance = raymarch(cameraPos, rayDir);

    // Simple shading: Color based on distance
    vec3 color = vec3(0.0);
    if (distance < 100.0) {
        color = vec3(0.5 + 0.5 * cos(distance), 0.7, 0.9 - 0.5 * sin(distance));
    }

    fragColor = vec4(color, 1.0);
}