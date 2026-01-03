#define MAX_STEPS 200
#define MAX_DIST 20.
#define SURFACE_DIST .002

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
        return sdBoxFrame(fract(p) - 0.5, vec3(0.5), 0.02); // made e bigger for visibility    return d;
}

vec4 rayMarch(vec3 ro, vec3 rd) {
    float d = 0.0;
    vec3 col = vec3(0.0);
    float alpha = 0.0;
    float boxAlpha = 0.15; // per-hit opacity, tweak for denser/thinner effect

    for (int i = 0; i < MAX_STEPS; ++i) {
        if (d > MAX_DIST || alpha > 0.98) break;
        vec3 p = ro + d * rd;
        float dist = getDist(p);

        if (dist < SURFACE_DIST) {
            // Color by cell position for fun
            vec3 cell = floor(p);
            vec3 boxColor = 0.5 + 0.5 * sin(cell * 2.1 + vec3(0.0, 2.0, 4.0)); // palette
            // Alpha blend
            col = mix(col, boxColor, boxAlpha * (1.0 - alpha));
            alpha += boxAlpha * (1.0 - alpha);
            d += 0.03; // skip ahead a bit so we don't stick in the same box
        } else {
            d += max(dist, 0.01); // always march at least a bit to avoid infinite loop
        }
    }
    // Blend with background (black)
    col = mix(vec3(0.05), col, alpha);
    return vec4(col, 1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;

    vec3 ro = vec3(0.5, 0.5, iTime); // fly through the grid
    vec3 rd = normalize(vec3(uv, 1));

    fragColor = rayMarch(ro, rd);
}