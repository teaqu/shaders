#define PI 3.14159265

// http://dev.thi.ng/gradients/
// https://iquilezles.org/articles/palettes/
vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
  return a + b*cos(2.0*PI*(c*t*d));
}

// following tutorial https://youtu.be/f4s1h2YETNY
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  // *2 -1.0 makes center (0,0) and also from -1 to 1
  // Doing vec.xy is known as swizzling
  // vec2 uv = fragCoord/iResolution.xy * 2.0 - 1.0;
  
  // Aspect Ratio
  // uv.x *= iResolution.x / iResolution.y;

  // This can be simplified to
  vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y; 
  vec2 uv0 = uv; // So we can keep track of uv before fract (spaced repitition)
  vec3 finalColor = vec3(0.0);

  for (float i = 0.0; i < 3.0; i++) { 

    // Only returns the fractional uv so 4.1 would be 0.1, -8.1 would be 0.1 etc.
    uv = fract(uv * 1.5) - 0.5;
  
    // With this length function we can get the distance of the uv from the origin (0,0)
    float d = length(uv);
    
    // vec3 col = vec3(0.0, 0.5, 1.0) * d;
    vec3 col = palette(length(uv0) + iTime/4.0, 
      vec3(0.5, 0.5, 0.5),
      vec3(0.5, 0.5, 0.5),
      vec3(1.0, 1.0, 1.0),
      vec3(0.263, 0.416, 0.557) 
    );
  
    // Radius of the circle
    // d -= 0.5;
    
    // Lt's make d repeat
    // d = sin(d*8.0); // This looks really cool and crip!
    // d /= 8.0; // Thicker circles to match repeated sin
  
    // Moving circles!
    d = sin(d*8.0 + iTime)/8.0;
  
    // Show negative values as positive we get white at center of circle too.
    d = abs(d);
  
    // Neon colors good with 1/x
    // This makes a color fall off (glow)
    // This is because 1/x creates a sharp graient that decreases rapidly as x increases.
    // d = 1.0 / d; We can't use 1.0 as then all values outside 1 so we gotta scale
    d = 0.02 / d;
  
    // We can use the step funciton to make all d values < 0.1 as black
    // This creates a distinct ring shape
    // d = step(0.1, d);
  
    // Or we can make it smooth 
    // d = smoothstep(0.0, 0.1, d); 
    
    finalColor += col * d;
  }

  fragColor = vec4(finalColor, 1.0);
}