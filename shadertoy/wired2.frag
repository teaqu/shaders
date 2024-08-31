vec3 cirCol = vec3(0.0, 0.9176, 1.0);
vec3 ringCol = vec3(1.0, 0.0588, 0.7961);
vec3 bgCol = vec3(0.0078, 0.3412, 0.5922);
vec3 ringBgCol = vec3(0.0078, 0.4078, 0.7176);


vec3 circle(vec2 uv, vec2 pos, float rad) {
    float l = length(uv-pos);
    float c = smoothstep(0.95, 1.0, rad / l); 
    float r = smoothstep(0.95, 1.0, (rad + rad / 4.0) / l); 
    float r2 = step( 1.0, (rad * 1.4) / l); 
    return mix(mix(bgCol, ringCol, r), cirCol, c) * r2;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y; 
    
    vec3 lCircle = circle(uv, vec2(-1.0, 0.2), 0.4);
    vec3 rCircle = circle(uv, vec2(0.9, 0.4), 0.3);
    vec3 bCircle = circle(uv, vec2(0.2, -0.50), 0.25);
    vec3 col = lCircle + rCircle + bCircle; 
    col = col != vec3(0) ? col : bgCol; 

    fragColor = vec4(col, 1.0);
}