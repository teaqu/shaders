// https://gam0022.net/blog/2017/03/02/raymarching-fold/
vec2 foldX(vec2 p) {
    p.x = abs(p.x);
    return p;
}

vec2 foldY(vec2 p) {
    p.y = abs(p.y);
    return p;
}

float circle(vec2 uv, float radius) {
    return length(uv) - radius;
}

mat2 rotate(float a) {
    float s = sin(a),c = cos(a);
    return mat2(c, s, -s, c);
}

float dTree(vec2 p) {
    float scale = 1.1;
    float size = 0.1;
    float d = circle(p, size);
    for (int i = 0; i < 7; i++) {
        vec2 q = foldX(abs(p));
        q.y -= size + 0.3;
        q.xy *= rotate(-0.5);
        d = min(d, circle(p, size));
        p = abs(q);
        size *= scale + 0.0;
    }
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    uv *= 2.0;
    float tree = step(0.0, dTree(uv * 3.0));
    fragColor = vec4(vec3(tree), 1.0);
}