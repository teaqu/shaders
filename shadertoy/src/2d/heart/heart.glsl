float dot2( in vec2 v ) { return dot(v,v); }

float sdHeart( vec2 p )
{
    p.x = abs(p.x);

    if( p.y+p.x>1.0 )
        return sqrt(dot2(p-vec2(0.25,0.75))) - sqrt(2.0)/4.0;
    return sqrt(min(dot2(p-vec2(0.00,1.00)),
                    dot2(p-0.5*max(p.x+p.y,0.0)))) * sign(p.x-p.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy)/iResolution.y;

    float pulse = sin(iTime * 3.0) / 40.0;
    uv.y += 0.50 - pulse;
    
    float heart = sdHeart(uv * (1.0 + pulse));
    float maskHeart = smoothstep(0.02, 0.01, heart);
    vec3 tex = texture(iChannel0, vec2(uv.x + iTime / 3.0, uv.y)).xyz;
    vec3 heartVec = vec3(0.0) + maskHeart * tex;

    vec3 pink = vec3(1.0, 0.4, 0.7);
    vec3 white = vec3(1.0);
    vec3 background = mix(white, pink, smoothstep(-0.5, 1.0, heart));

    fragColor = vec4(heartVec - maskHeart + background,1.0);
}