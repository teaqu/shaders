#iKeyboard
#iChannel0 "self"

const float SPEED = 0.05;

vec3 forward = vec3(0.0, 0.0, -1.0);
vec3 up = vec3(0.0, 1.0, 0.0);

mat2 rot2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

vec3 camera() {
    vec3 camera = vec3(0, 0, -6);
    if (iFrame > 10) {
       camera = texture(iChannel0, vec2(0, 0.1)).xyz;
    }

    if (isKeyDown(Key_A)) {
        camera.x -= SPEED;
    } 
    if (isKeyDown(Key_D)) {
        camera.x += SPEED;
    }

    if (isKeyDown(Key_W)) {
        camera.z += SPEED;
    }
    if (isKeyDown(Key_S)) {
        camera.z -= SPEED;
    }

    if (isKeyDown(Key_E)) {
       camera.y += SPEED;
    }
    if (isKeyDown(Key_Q)) {
        camera.y -= SPEED;
    }

    return camera;
}

vec3 direction() {
    vec3  direction = vec3(1);
    if (iFrame > 10) {
       direction = texture(iChannel0, vec2(0, 0.9)).xyz;
    }

    if (isKeyDown(Key_LeftArrow)) {
        forward.yz *= rot2D(SPEED);
    }
    if (isKeyDown(Key_RightArrow)) {
        forward.yz *= rot2D(SPEED);
    }

    return direction * forward;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    if (fragCoord.y < iResolution.y/2.0) {
        fragColor = vec4(camera(), 1.0);
    } else {
        fragColor = vec4(direction(), 1.0);
    }
}