// https://www.youtube.com/watch?v=il_Qg9AqQkE
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord -.5*iResolution.xy)/iResolution.y;
    uv *= 3.;
    vec3 col = vec3(0);

    uv.x = abs(uv.x);
    uv.x -= .5;

    float d = length(uv - vec2(clamp(uv.x, -1., 1.), 0));
    col += smoothstep(.03, .0, d);

    col.rg += uv;

    fragColor = vec4(col, 1.0);
}