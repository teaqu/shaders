#iKeyboard
#iChannel0 "self"

void mainImage( out vec4 fragColor, in vec2 fragCoord )
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