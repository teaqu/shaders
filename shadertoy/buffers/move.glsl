#iKeyboard
#iChannel0 "self"

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec3 camera;
    if (iFrame == 1) {
       camera = vec3(0);
    } else {
        camera = texture(iChannel0, vec2(vec2(0, 0))).rgb;
    }

    if (isKeyDown(Key_A)) {
        camera.x -= 1.0;
    } 
    if (isKeyDown(Key_D)) {
        camera.x += 1.0;
    }

    if (isKeyDown(Key_S)) {
        camera.y -= 1.0;
    }
    if (isKeyDown(Key_W)) {
        camera.y += 1.0;
    }
    
    fragColor = vec4(camera, 1.0);
}