#version 430

uniform sampler2D uKeyboard;
uniform vec2 uMousePosition;
uniform vec4 uMouse;

const float SPEED = 0.05; 
const float SPEED_ROT = 0.01;
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
    float yaw;
    float pitch;
};

bool isKeyDown(int key) {
	return texelFetch(uKeyboard, ivec2(key, 0), 0).x == 1.0;
}

vec3 keyboard() {

	if (camera == vec3(1.0)) {
		 camera = vec3(0, 0, -6);
	}
	
	if (uMousePosition.x > 0 && uMousePosition.y > 0 && uMousePosition.x < 1 && uMousePosition.y < 1) {
		vec3 forward = vec3(sin(yaw), 0.0, cos(yaw));
		vec3 right = vec3(-cos(yaw), 0.0, sin(yaw)); // perpendicular to forward

		if (isKeyDown(KEY_a)) {
        	camera += right * SPEED;
	    }

	    if (isKeyDown(KEY_d)) {
	        camera -= right * SPEED;
	    }
	
	    if (isKeyDown(KEY_w)) {
	        camera += forward * SPEED;
	    }

	    if (isKeyDown(KEY_s)) {
	        camera -= forward * SPEED;
	    }
	
	    if (isKeyDown(KEY_e)) {
	       camera.y += SPEED;
	    }
	    
	    if (isKeyDown(KEY_q)) {
	        camera.y -= SPEED;
	    }
	    
	    if (isKeyDown(KEY_j)) {
	        yaw -= SPEED_ROT;
	    }
	    
	    if (isKeyDown(KEY_l)) {
	        yaw += SPEED_ROT;
	    }
	    
	   
	}
	
    return camera;
}

void main() {
	camera = keyboard();
}
