// following tutorial https://inspirnathan.com/posts/49-shadertoy-tutorial-part-3
// Rotate squre using rotation matrix
// [ cos -sin ]
// [ sin cos  ]
vec2 rotate(vec2 uv, float th) {
    return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;    
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y; 
    
    // Multiple
    // uv = fract(uv * 1.5 + 0.5) - 0.5;
    
    float r = 0.5;
    vec2 pos = vec2(uv.x, uv.y);
    
    // Square length function
    float l = max(abs(uv.x), abs(uv.y));
    
    // glow
    l = 0.05 / l;

    // Repeat
    l = sin(l * 20.0 + iTime * 5.0);

    vec3 col = vec3(1.0) * l;
    
    col = step(0.9, col);

    // Output to screen
    fragColor = vec4(col, 1.0);
}