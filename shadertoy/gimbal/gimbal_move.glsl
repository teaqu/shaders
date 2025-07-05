const float SPEED = 0.05;
const float SPEED_ROT = 0.03;
const int KEY_SHIFT = 16;
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
const int KEY_i = 73;
const int KEY_k = 75;
const int KEY_u = 85;
const int KEY_o = 79;


bool isKeyDown(int key) {
	return texelFetch(iChannel1, ivec2(key, 0), 0).x == 1.0;
}
	    
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{   
	vec3 camera = texelFetch(iChannel0, ivec2(0, 0), 0).xyz;
    vec3 ypr = texelFetch(iChannel0, ivec2(1, 0), 0).xyz; // yaw, pitch, roll
    float yaw = ypr.x;
    float pitch = ypr.y;
    float roll = ypr.z;
	
	vec3 forward = vec3(sin(yaw), 0.0, cos(yaw));
    vec3 right = vec3(-cos(yaw), 0.0, sin(yaw));
    vec3 up = cross(forward, right);

    if (camera == vec3(0.0)) {
        // camera = vec3(0.5, 0.5, -2.5); // default camera position
    }

    float speed = SPEED;
    if (isKeyDown(KEY_SHIFT)) {
        speed += 0.2;
    }

    if (isKeyDown(KEY_a)) {
        camera += right * speed;
    }

    if (isKeyDown(KEY_d)) {
        camera -= right * speed;
    }

    if (isKeyDown(KEY_w)) {
        camera += forward * speed;
    }

    if (isKeyDown(KEY_s)) {
        camera -= forward * speed;
    }

    if (isKeyDown(KEY_e)) {
        camera -= up * speed;
    }
    
    if (isKeyDown(KEY_q)) {
        camera += up * speed;
    }
    
    if (isKeyDown(KEY_j)) {
        yaw -= SPEED_ROT;
    }
    
    if (isKeyDown(KEY_l)) {
        yaw += SPEED_ROT;
    }
    
    if (isKeyDown(KEY_i)) {
        pitch += SPEED_ROT;
    }
    
    if (isKeyDown(KEY_k)) {
        pitch -= SPEED_ROT;
    }

    // limit pitch to avoid gimbal lock

    ypr = vec3(yaw, pitch, roll);
	
    ivec2 c = ivec2(fragCoord );
    if (c == ivec2(0, 0)) {
        fragColor = vec4(camera, 1.0);
    } else if (c == ivec2(1, 0)) {
        fragColor = vec4(ypr, 1.0);
    } else {
        fragColor = texelFetch(iChannel0, c, 0);
    }

}