#iChannel0 "file://buffers/move.glsl"
#define SPEED 0.01;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec3 camera = texture(iChannel0, vec2(vec2(0, 0))).xyz;
    
    uv -= camera.xy * SPEED;

    float cicle = step(length(uv) * 12.0, 1.0);
    fragColor = vec4(vec3(1) * cicle, 1.0);
}