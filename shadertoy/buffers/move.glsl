#define Key_A 0
#define Key_D 1
#define Key_W 2
#define Key_S 3
#define Key_UpArrow 4
#define Key_DownArrow 5
#define Key_LeftArrow 6
#define Key_RightArrow 7

bool isKeyDown(int keyCode) {
    return texelFetch(iChannel0, ivec2(keyCode, 0), 0).r > 0.0;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec4 camera;
    if (iFrame == 1) {
       camera = vec4(-6, -6, -6, -6);
    } else {
        camera = texture(iChannel0, vec2(vec2(0, 0)));
    }

    if (isKeyDown(Key_A)) {
        camera.x -= 1.0;
    } 
    
    if (isKeyDown(Key_D)) {
        camera.x += 1.0;
    }

    if (isKeyDown(Key_W)) {
        camera.y += 1.0;
    }

    if (isKeyDown(Key_S)) {
        camera.y -= 1.0;
    }

    if (isKeyDown(Key_UpArrow)) {
       camera.w += 1.0;
    }

    if (isKeyDown(Key_DownArrow)) {
       camera.w -= 1.0;
    }

    if (isKeyDown(Key_LeftArrow)) {
       camera.z -= 1.0;
    }

    if (isKeyDown(Key_RightArrow)) {
       camera.z += 1.0;
    }

    fragColor = camera;
}