vec2 rotate(vec2 uv, float th) {
    return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;    
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y; 
    
    vec3 finalColor = vec3(0.0);
    
    // Multiple
    uv = fract(uv * 3.0);

    vec2 pos = vec2(uv.x, uv.y);
        
    // Square length function
    float l = step(0.95, max(abs(uv.x), abs(uv.y)));
    
    finalColor += vec3(1.0) * l;
    
    // Output to screen
    fragColor = vec4(finalColor, 1.0);
}