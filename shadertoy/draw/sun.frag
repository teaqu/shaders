float cRad = 0.4;
vec2 cPos = vec2(0.5, 0.5);

// iTime
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    float aspectRatio = iResolution.x / iResolution.y;
    vec2 auv = vec2(uv.x * aspectRatio, uv.y);

    // (x-h)^2 + (y-k)^2 < r^2
    if(auv.y > cRad && pow(auv.x-cPos.x*aspectRatio, 2.0) + pow(auv.y-cPos.y, 2.0) < pow(cRad, 2.0)) {
        fragColor = vec4(0.91, 0.89, 0.01, 1.0);
    } else if (auv.y > cRad){
        fragColor = vec4(0.02, 0.46, 0.87, 1.0);
    } else {
        fragColor = vec4(0.18, 0.64, 0.02, 1.0);
    }
    
}