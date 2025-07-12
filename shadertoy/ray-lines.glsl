// https://youtu.be/PGtv-dBi2wE
// https://youtu.be/khblXafu7iA

#define MAX_STEPS 200
#define MAX_DIST 20.
#define SURFACE_DIST .002

mat2 rot2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float sdBoxFrame( vec3 p, vec3 b, float e )
{
       p = abs(p  )-b;
  vec3 q = abs(p+e)-e;
  return min(min(
      length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
      length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),
      length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0));
}

float getDist(vec3 p) {
    float d = sdBoxFrame(fract(p) - 0.5, vec3(0.5, 0.5, 0.5), 0.002);
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

vec3 palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.283185*(c*t+d) );
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;
    vec2 m = (iMouse.xy * 2.0 - iResolution.xy) / iResolution.y;
    
    vec3 ro = vec3(0, 0, -5); // camera, ray origin
    vec3 rd = normalize(vec3(uv, 1));
    
    // Mouse
    ro.yz *= rot2D(-m.y);
    rd.yz *= rot2D(-m.y);
    
    ro.xy *= rot2D(-m.x);
    rd.xy *= rot2D(-m.x);

    ro.y -= iTime;
  
    float d = rayMarch(ro, rd) / 15.0;
    
    vec3 col = max(vec3(d), vec3(0.3));

    fragColor = vec4(col, 1);
}