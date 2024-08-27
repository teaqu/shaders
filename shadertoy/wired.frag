void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y; 

    float l = length(uv); 
    l = 1.0/l;
    
    float l2 = step(1.6, l);
    float l3 = step(1.3, l);
    
    vec3 col2 = vec3(0.851, 0.0471, 0.6235) * l;
    vec3 col = vec3(0.0, 0.9333, 1.0);
    vec3 col3 = vec3(0.0078, 0.3412, 0.5922) * l;
    
    fragColor = vec4(abs(uv.x) > l2 && abs(uv.x) < l3 ? col2 : abs(uv.x) < l2  ? col : col3,1.0);
}