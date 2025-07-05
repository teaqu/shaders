#define MAX_STEPS 100
#define MAX_DIST 200.0
#define SURFACE_DIST .005

vec4 ball;

float sdBoxFrame( vec3 p, vec3 b, float e )
{
    p = abs(p  )-b;
    vec3 q = abs(p+e)-e;
    return min(min(
        length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
        length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),
        length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0));
}


float frameDistance(vec3 p, float d) {
	return sdBoxFrame(vec3(fract(p.x), p.y + 2.0, fract(p.z)) - 0.5, vec3(0.5, 0.0, 0.5), d * 0.0009);
}

float getLen(vec3 p, vec4 s) {
    return length(p - 0.5 - s.xyz) - s.w;
}

float getDist(vec3 p, float d) {
    // ball
    float minDist = getLen(p, ball);
    
   	// Floor
   	float frame = frameDistance(p, d);			
   	
    return min(frame, minDist);
}

float rayMarch(vec3 ro, vec3 rd) {
    float d = 0.0; // distance traveled
    for (int i = 0; i < MAX_STEPS; ++i) {
        vec3 p = ro + d * rd; // position along the ray
        float cd = getDist(p, d); // current distance
        d += cd; // march the ray
        if (cd < SURFACE_DIST || d > MAX_DIST) break;
    }
    return d;
}

vec3 getColour(vec3 p, float d) {
    float minDist = getLen(p, ball);
    
    // Floor
    float frame = frameDistance(p, d);
   	if (frame < minDist) {
   		return vec3(min(max(5.0 / (d * 3.0), 0.05), 0.4));
   	} else {
       if(p.y > ball.y + 0.5) {
        return vec3(1.0);
       } else {
        return vec3(1.0, 0.0, 0.0);
       }
   	}
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (gl_FragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;

    vec3 direction = vec3(0);

	vec3 ro = vec3(1.0, 0.5, -5.0); // camera, ray origin
    
    vec3 rd = normalize(vec3(uv, 1));

    vec3 buff = texelFetch(iChannel0, ivec2(0, 0), 0).xyz;
  	ball = vec4(vec3(buff), 1.0);
    
    float d = rayMarch(ro, rd);
    vec3 col = vec3(0.05);
    if (d < MAX_DIST) {
        vec3 p = (ro + rd * d);
        col = getColour(p, d);
    }

    fragColor = vec4(col, 1.0);
}