vec2 rotate(vec2 uv, float th) {
    return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;    
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y; 
    
    vec3 finalColor = vec3(0.0);
    for (float i = 0.0; i < 3.0; i++) { 
        // Multiple
        uv = fract(uv * 1.5 + 0.5) - 0.5;
        // uv = rotate(uv, iTime);
        
        float r = 0.5;
        vec2 pos = vec2(uv.x, uv.y);
        
        // Square length function
        float l = max(abs(uv.x), abs(uv.y));
        
        // Repeat
        l = sin(l * 20.0 + iTime * 5.0);
    
        // glow and same brightness
        l = abs(l);
        l = 0.05 / l;
    
        finalColor += vec3(1.0) * l;
    }    
    // Output to screen
    fragColor = vec4(finalColor, 1.0);
}