vec2 foldX(vec2 p) {
    p.x = abs(p.x);
    return p;
}

mat2 rotate(float a) {
    float s = sin(a),c = cos(a);
    return mat2(c, s, -s, c);
}

float sdBox( vec2 p, vec2 b ) {
  vec2 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);
}

float dTree(vec2 p) {
    vec2 size = vec2(0.1, 0.5);
    float d = sdBox(p, size);
    p = foldX(p);
    p.y -= 0.1;
    p.xy *= rotate(-1.2);
    d = min(d, sdBox(p, size));
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    uv -= 0.5;
    float tree = step(0.01, dTree(uv));
    fragColor = vec4(vec3(tree), 1.0);
}