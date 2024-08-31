// https://www.youtube.com/watch?v=zXsWftRdsvU 
float random(vec2 uv) {
  return fract(sin(uv.x * 1920. + uv.y * 3092.) * 4039.);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    vec3 col = vec3(random(uv));
    fragColor = vec4(col,1.);
}