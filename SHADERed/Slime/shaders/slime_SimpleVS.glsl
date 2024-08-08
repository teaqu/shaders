#version 330

uniform mat4 matVP;
uniform mat4 matGeo;

uniform float Time;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;

out vec4 color;

void main() {

   vec3 p = pos;

   p.y += (sin(p.x + Time) + 1)/10;
   color = vec4(abs(normal), 1.0);
   gl_Position = matVP * matGeo * vec4(p, 1);
}
