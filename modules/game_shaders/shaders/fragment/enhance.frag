uniform float u_Time;
uniform sampler2D u_Tex0;
uniform vec2 u_Resolution;
varying vec2 v_TexCoord;

// ====== TUNING KNOBS ======
const float SMOOTH     = 1.0;   // edge-aware smoothing (0=off, 0.5=subtle, 1.0=max)
const float VIBRANCE   = 0.15;   // boost muted colors without oversaturating
const float SATURATION = 1.08;   // slightly richer overall
const float CONTRAST   = 0.5;   // S-curve mix amount
const float WARMTH     = 0.005;  // very subtle warm tint
const float VIGNETTE   = 0.20;   // light edge darkening for focus

// Edge-aware smoothing: blends similar neighbors, keeps hard edges sharp
// Makes pixel art look higher resolution without losing detail
vec3 smartSmooth(vec2 uv)
{
    vec2 px = 1.0 / u_Resolution;

    vec3 c  = texture2D(u_Tex0, uv).rgb;
    vec3 n  = texture2D(u_Tex0, uv + vec2( 0.0, -px.y)).rgb;
    vec3 s  = texture2D(u_Tex0, uv + vec2( 0.0,  px.y)).rgb;
    vec3 e  = texture2D(u_Tex0, uv + vec2( px.x,  0.0)).rgb;
    vec3 w  = texture2D(u_Tex0, uv + vec2(-px.x,  0.0)).rgb;
    vec3 ne = texture2D(u_Tex0, uv + vec2( px.x, -px.y)).rgb;
    vec3 nw = texture2D(u_Tex0, uv + vec2(-px.x, -px.y)).rgb;
    vec3 se = texture2D(u_Tex0, uv + vec2( px.x,  px.y)).rgb;
    vec3 sw = texture2D(u_Tex0, uv + vec2(-px.x,  px.y)).rgb;

    // Weight neighbors by color similarity to center (bilateral filter)
    float threshold = 0.12;
    float wn  = 1.0 - smoothstep(0.0, threshold, length(n  - c));
    float ws  = 1.0 - smoothstep(0.0, threshold, length(s  - c));
    float we  = 1.0 - smoothstep(0.0, threshold, length(e  - c));
    float ww  = 1.0 - smoothstep(0.0, threshold, length(w  - c));
    float wne = 0.7 * (1.0 - smoothstep(0.0, threshold, length(ne - c)));
    float wnw = 0.7 * (1.0 - smoothstep(0.0, threshold, length(nw - c)));
    float wse = 0.7 * (1.0 - smoothstep(0.0, threshold, length(se - c)));
    float wsw = 0.7 * (1.0 - smoothstep(0.0, threshold, length(sw - c)));

    float totalW = 1.0 + wn + ws + we + ww + wne + wnw + wse + wsw;
    vec3 blended = (c + n*wn + s*ws + e*we + w*ww + ne*wne + nw*wnw + se*wse + sw*wsw) / totalW;

    return mix(c, blended, SMOOTH);
}

void main()
{
    // 1. Edge-aware smooth (makes pixel art look HD)
    vec3 color = smartSmooth(v_TexCoord);

    // 2. S-curve contrast (subtle cinematic feel)
    vec3 curved = color * color * (3.0 - 2.0 * color);
    color = mix(color, curved, CONTRAST);

    // 3. Vibrance (boosts dull colors, leaves vivid ones alone)
    float luma = dot(color, vec3(0.299, 0.587, 0.114));
    float mx = max(color.r, max(color.g, color.b));
    float mn = min(color.r, min(color.g, color.b));
    float sat = mx - mn;
    color = mix(vec3(luma), color, 1.0 + VIBRANCE * (1.0 - sat));

    // 4. Saturation boost
    luma = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(vec3(luma), color, SATURATION);

    // 5. Warm tint
    color.r += WARMTH;
    color.b -= WARMTH * 0.5;

    // 6. Vignette
    vec2 d = v_TexCoord - 0.5;
    color *= 1.0 - dot(d, d) * VIGNETTE * 4.0;

    gl_FragColor = vec4(clamp(color, 0.0, 1.0), texture2D(u_Tex0, v_TexCoord).a);
}
