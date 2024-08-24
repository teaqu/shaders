// following tutorial https://inspirnathan.com/posts/49-shadertoy-tutorial-part-3
// Rotate squre using rotation matrix
// [ cos -sin ]
// [ sin cos  ]
vec2 rotate(vec2 uv, float th) {
    return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;    
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv = uv * 2.0 - 1.0;
    vec2 fuv = fract(uv * 2.0);
    fuv.x *= iResolution.x/iResolution.y;
    
    float r = 0.5;
    vec2 offset = vec2(1.0, 0.5);
    vec2 pos = rotate(vec2(fuv.x - offset.x, fuv.y - offset.y), iTime);

    // Time varying pixel color
    vec3 bgCol = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    vec3 sqCol = max(abs(pos.x), abs(pos.y)) < r ?
         bgCol : vec3(0.0);

    // Output to screen
    fragColor = vec4(sqCol, 1.0);
}