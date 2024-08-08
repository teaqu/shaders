float cRad=.4;
vec2 cPos=vec2(.5,.5);

// iTime
void mainImage(out vec4 fragColor,in vec2 fragCoord)
{
  // Normalized pixel coordinates (from 0 to 1)
  vec2 uv=fragCoord/iResolution.xy;
  float aspectRatio=iResolution.x/iResolution.y;
  vec2 auv=vec2(uv.x*aspectRatio,uv.y);
  
  // (x-h)^2 + (y-k)^2 < r^2
  if(pow(auv.x-cPos.x*aspectRatio,2.)+pow(auv.y-cPos.y,2.)<pow(cRad,2.)){
    fragColor=vec4(2.,.4,1.,1.);
  }else{
    fragColor=vec4(1.,1.4,0.,1.);
  }
  
}