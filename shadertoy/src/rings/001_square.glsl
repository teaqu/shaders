void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(1.0);
    float sq = max(abs(uv.x), abs(uv.y));
    
    // Define square bounds
    float outer = 0.3;
    float inner = 0.25;

    // Is it within the outer square?
    float inOuter = step(max(abs(uv.x), abs(uv.y)), outer);

    // Is it within the inner square?
    float inInner = step(max(abs(uv.x), abs(uv.y)), inner);

    // Square ring = in outer but not in inner
    float ring = inOuter - inInner;

    col = vec3(1.0, 0.0, 0.0) * ring; // Red square ring
    col += vec3(1.0, 0.0, 0.0) * ring;
    
    fragColor = vec4(col * sq,1.0); 
}