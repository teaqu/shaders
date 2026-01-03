#define MAX_STEPS 2000
#define MAX_DIST 20.
#define SURFACE_DIST .0002

// Be cool to make some kind of maze here or like fill in some of the squares.

// https://iquilezles.org/articles/distfunctions/
float sdBoxFrame( vec3 p, vec3 b, float e )
{
       p = abs(p  )-b;
  vec3 q = abs(p+e)-e;
  return min(min(
      length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
      length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),
      length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0));
}

float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float getDist(vec3 p) {
    float d = sdBoxFrame(fract(p) - 0.5, vec3(0.5, 0.5, 0.5), 0.002);
    d *= sdBox(fract(p / 8.0) - .5, vec3(0.05));
    return d;
}

float rayMarch(vec3 ro, vec3 rd) {
    float d = 0.; // distance traveled
    for (int i = 0; i < MAX_STEPS; ++i) {
        vec3 p = ro + d * rd; // position along the ray
        float cd = getDist(p); // current distance
        d += cd; // march the ray
        if (cd < SURFACE_DIST || d > MAX_DIST) break;
    }
    return d;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;
    vec2 m = (2.0 - iResolution.xy) / iResolution.y;
    
    vec3 ro = vec3(0.35, 0.25, iTime);
    vec3 rd = normalize(vec3(uv, 1));

    float d = rayMarch(ro, rd) / 15.0;
    
    vec3 col = max(vec3(d), vec3(0.3));

    fragColor = vec4(col, 1);
}