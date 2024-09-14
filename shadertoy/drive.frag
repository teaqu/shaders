struct ray {
  vec3 oi, d;
};

ray GetRay(vec2 uv, vec3 camPos, vec3 lookat, float zoom) {
  
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    uv -= .5;
    uv.x *= iResolution.x/iResolution.y;

    vec3 camPos = vec3(0, .2, 0);
    vec3 lookat = vec3(0, .2, 1.);

    vec3 col = 0.5 + 0.5 * cos(iTime + uv.xyx + vec3(0, 2, 4));
    fragColor = vec4(col, 1.0);
}