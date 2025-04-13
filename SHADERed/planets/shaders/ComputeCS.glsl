#version 430

uniform sampler2D uKeyboard;
uniform vec2 uMousePosition;
uniform vec4 uMouse;

const float SPEED = 0.05; 
const int KEY_w = 87;
const int KEY_s = 83;
const int KEY_a = 65;
const int KEY_d = 68;
const int KEY_q = 81;
const int KEY_e = 69;
const int KEY_LEFT = 37;
const int KEY_UP = 38;
const int KEY_RIGHT = 39;
const int KEY_DOWN = 40;
const int KEY_RETURN = 13;
const int KEY_CTRL = 17;
const int KEY_j = 74; 
const int KEY_l = 76; 

layout(local_size_x = 16, local_size_y = 16) in;

layout(std430, binding = 0) buffer DataBuffer {
    vec3 camera;
    vec3 dir;
};

layout(std430, binding = 1) buffer DataBuffer2 {
    float canInput;
};

mat2 rot2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

bool isKeyDown(int key) {
	return texelFetch(uKeyboard, ivec2(key, 0), 0).x == 1.0;
}

vec3 keyboard() {

	if (camera == vec3(1.0)) {
		 camera = vec3(0, 0, -6);
	}
	
	if (uMousePosition.x > 0 && uMousePosition.y > 0 && uMousePosition.x < 1 && uMousePosition.y < 1) {
		if (isKeyDown(KEY_a)) {
        	camera.x -= SPEED;
	    }

	    if (isKeyDown(KEY_d)) {
	        camera.x += SPEED;
	    }
	
	    if (isKeyDown(KEY_w)) {
	        camera.z += SPEED;
	    }

	    if (isKeyDown(KEY_s)) {
	        camera.z -= SPEED;
	    }
	
	    if (isKeyDown(KEY_e)) {
	       camera.y += SPEED;
	    }
	    
	    if (isKeyDown(KEY_q)) {
	        camera.y -= SPEED;
	    }
	    
	    if (isKeyDown(KEY_LEFT)) {
        	camera.x -= SPEED;
	    }
	    
	    if (isKeyDown(KEY_j)) {
        	camera.x -= SPEED;
	    }
	    
	    if (isKeyDown(KEY_l)) {
        	camera.x -= SPEED;
	    }
	   
	}
	
    return camera;
}

void main() {
	camera = keyboard();
}
