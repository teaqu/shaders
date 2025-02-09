#version 430
layout(local_size_x = 16, local_size_y = 16) in;

layout(std430, binding = 0) buffer DataBuffer {
    vec3 data;
};

layout(std430, binding = 1) buffer DataBuffer2 {
    float canInput;
};

uniform sampler2D uKeyboard;

bool isKeyDown(int key) {
	return texelFetch(uKeyboard, ivec2(key, 0), 0).x == 1.0;
}

const float SPEED = 0.05; 
const int KEY_W = 87;
const int KEY_S = 83;
const int KEY_A = 65;
const int KEY_D = 68;
const int KEY_Q = 81;
const int KEY_E = 69;
const int KEY_LEFT = 37;
const int KEY_UP = 38;
const int KEY_RIGHT = 39;
const int KEY_DOWN = 40;
const int KEY_RETURN = 13;
const int KEY_CTRL = 17;

vec3 keyboard() {
	vec3 camera = vec3(data.xyz);
	if (camera == vec3(1.0)) {
		 camera = vec3(0, 0, -6);
	}

    if (isKeyDown(KEY_A)) {
        camera.x -= SPEED;
    } 
    if (isKeyDown(KEY_D)) {
        camera.x += SPEED;
    }

    if (isKeyDown(KEY_W)) {
        camera.z += SPEED;
    }
    if (isKeyDown(KEY_S)) {
        camera.z -= SPEED;
    }

    if (isKeyDown(KEY_E)) {
       camera.y += SPEED;
    }
    
    if (isKeyDown(KEY_Q)) {
        camera.y -= SPEED;
    }
    
    if (isKeyDown(KEY_CTRL) && isKeyDown(KEY_RETURN)) {
    	// Need to find a way to only check once...
    	canInput++;
    }

    return camera;
}

void main() {
	data = keyboard();
}


