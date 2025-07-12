float spiralSDF(vec2 st, float turns) {
    float r = length(st);
    float a = atan(st.x, st.y);
    return step(0.1, sin(r * turns + a));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = -1. + 2. * fragCoord / iResolution.xy;
    uv.x *= iResolution.x / iResolution.y;
 
    float l = spiralSDF(uv, 50.0);
    
    fragColor = vec4(vec3(0) + l, 1.0);
}