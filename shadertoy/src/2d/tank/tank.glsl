void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 videoColor = texture(iChannel0, uv);
    fragColor = videoColor;
}