uniform float u_Time;
uniform sampler2D u_Tex0;
uniform vec2 u_Resolution;
varying vec2 v_TexCoord;

// ====== TUNING KNOBS ======
// --- Pixel-art smoothing ---
const float SMOOTH         = 1.0;    // edge-aware smoothing (0=off, 1.0=max)
const float SMOOTH_THRESH  = 0.20;   // higher = smooths more (blurrier)

// --- Bloom (the dungeon-light glow) ---
const float BLOOM_INTENSITY = 0.60;  // 0=off, 1.0=strong, 1.5=overblown
const float BLOOM_THRESHOLD = 0.40;  // luma above this starts to glow
const float BLOOM_RADIUS    = 3.0;   // px spread of the halo
const float BLOOM_WARMTH    = 0.10;  // 0=neutral white glow, 1=pure orange

// --- Tone mapping & contrast ---
const float EXPOSURE   = 0.65;       // pre-tonemap brightness
const float CONTRAST   = 0.55;       // S-curve mix amount

// --- Color grading (orange highlights / teal shadows) ---
const float GRADE_STRENGTH = 0.18;   // 0=off
const vec3  GRADE_HIGHLIGHT = vec3(1.10, 1.02, 0.88); // warm highlights
const vec3  GRADE_SHADOW    = vec3(0.92, 0.97, 1.06); // cool shadows

// --- Color richness ---
const float VIBRANCE   = 0.18;
const float SATURATION = 1.10;
const float WARMTH     = 0.008;

// --- Atmosphere ---
const float VIGNETTE   = 0.0;       // edge darkening (img2 has heavy vignette)
const float GRAIN      = 0.025;      // film grain / stone-noise feel

// ============================================================
// Edge-aware bilateral smoothing (pixel-art -> painted look)
// ============================================================
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

    float wn  = 1.0 - smoothstep(0.0, SMOOTH_THRESH, length(n  - c));
    float ws  = 1.0 - smoothstep(0.0, SMOOTH_THRESH, length(s  - c));
    float we  = 1.0 - smoothstep(0.0, SMOOTH_THRESH, length(e  - c));
    float ww  = 1.0 - smoothstep(0.0, SMOOTH_THRESH, length(w  - c));
    float wne = 0.7 * (1.0 - smoothstep(0.0, SMOOTH_THRESH, length(ne - c)));
    float wnw = 0.7 * (1.0 - smoothstep(0.0, SMOOTH_THRESH, length(nw - c)));
    float wse = 0.7 * (1.0 - smoothstep(0.0, SMOOTH_THRESH, length(se - c)));
    float wsw = 0.7 * (1.0 - smoothstep(0.0, SMOOTH_THRESH, length(sw - c)));

    float totalW = 1.0 + wn + ws + we + ww + wne + wnw + wse + wsw;
    vec3 blended = (c + n*wn + s*ws + e*we + w*ww + ne*wne + nw*wnw + se*wse + sw*wsw) / totalW;

    return mix(c, blended, SMOOTH);
}

// ============================================================
// Single-pass bloom: 13-tap dual gaussian (inner + outer ring).
// Aislamos solo lo brillante (luma > threshold) y sumamos.
// ============================================================
vec3 brightPass(vec3 c)
{
    float l = dot(c, vec3(0.299, 0.587, 0.114));
    float k = max(0.0, l - BLOOM_THRESHOLD) / max(1.0 - BLOOM_THRESHOLD, 0.001);
    return c * (k * k);
}

vec3 sampleBloom(vec2 uv)
{
    vec2 px = (1.0 / u_Resolution) * BLOOM_RADIUS;

    // Inner ring (8 taps, radius = 1*px)
    vec3 sum = vec3(0.0);
    sum += brightPass(texture2D(u_Tex0, uv + vec2( px.x,  0.0)).rgb);
    sum += brightPass(texture2D(u_Tex0, uv + vec2(-px.x,  0.0)).rgb);
    sum += brightPass(texture2D(u_Tex0, uv + vec2( 0.0,  px.y)).rgb);
    sum += brightPass(texture2D(u_Tex0, uv + vec2( 0.0, -px.y)).rgb);
    sum += brightPass(texture2D(u_Tex0, uv + vec2( px.x,  px.y)).rgb) * 0.7071;
    sum += brightPass(texture2D(u_Tex0, uv + vec2(-px.x,  px.y)).rgb) * 0.7071;
    sum += brightPass(texture2D(u_Tex0, uv + vec2( px.x, -px.y)).rgb) * 0.7071;
    sum += brightPass(texture2D(u_Tex0, uv + vec2(-px.x, -px.y)).rgb) * 0.7071;

    // Outer ring (4 taps, radius = 2.5*px) for wider halo
    vec2 px2 = px * 2.5;
    sum += brightPass(texture2D(u_Tex0, uv + vec2( px2.x,  0.0)).rgb) * 0.5;
    sum += brightPass(texture2D(u_Tex0, uv + vec2(-px2.x,  0.0)).rgb) * 0.5;
    sum += brightPass(texture2D(u_Tex0, uv + vec2( 0.0,  px2.y)).rgb) * 0.5;
    sum += brightPass(texture2D(u_Tex0, uv + vec2( 0.0, -px2.y)).rgb) * 0.5;

    sum /= 8.83; // sum of weights

    // Tint bloom warm (orange) optionally
    vec3 warm = sum * vec3(1.20, 0.85, 0.55);
    return mix(sum, warm, BLOOM_WARMTH);
}

// ============================================================
// ACES filmic tone mapping (Narkowicz approximation)
// ============================================================
vec3 acesTonemap(vec3 x)
{
    const float a = 2.51;
    const float b = 0.03;
    const float c = 2.43;
    const float d = 0.59;
    const float e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

// ============================================================
// Cheap hash for grain
// ============================================================
float hash21(vec2 p)
{
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

void main()
{
    vec2 uv = v_TexCoord;

    // 1. Edge-aware smooth (pixel art -> painted)
    vec3 color = smartSmooth(uv);

    // 2. Bloom (the big atmospheric difference)
    vec3 bloom = sampleBloom(uv);
    color += bloom * BLOOM_INTENSITY;

    // 3. Exposure + ACES tone mapping (cinematic curve, no clipping)
    color *= EXPOSURE;
    color = acesTonemap(color);

    // 4. S-curve contrast for extra punch
    vec3 curved = color * color * (3.0 - 2.0 * color);
    color = mix(color, curved, CONTRAST);

    // 5. Color grading: warm highlights, cool shadows
    float luma = dot(color, vec3(0.299, 0.587, 0.114));
    vec3 graded = color * mix(GRADE_SHADOW, GRADE_HIGHLIGHT, luma);
    color = mix(color, graded, GRADE_STRENGTH);

    // 6. Vibrance
    luma = dot(color, vec3(0.299, 0.587, 0.114));
    float mx = max(color.r, max(color.g, color.b));
    float mn = min(color.r, min(color.g, color.b));
    float sat = mx - mn;
    color = mix(vec3(luma), color, 1.0 + VIBRANCE * (1.0 - sat));

    // 7. Saturation
    luma = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(vec3(luma), color, SATURATION);

    // 8. Warm tint
    color.r += WARMTH;
    color.b -= WARMTH * 0.5;

    // 9. Vignette (much stronger to match dungeon look)
    vec2 d = uv - 0.5;
    float vig = 1.0 - dot(d, d) * VIGNETTE * 4.0;
    color *= clamp(vig, 0.0, 1.0);

    // 10. Subtle grain to fake stone texture / break flat areas
    float n = hash21(uv * u_Resolution + fract(u_Time));
    color += (n - 0.5) * GRAIN;

    gl_FragColor = vec4(clamp(color, 0.0, 1.0), texture2D(u_Tex0, uv).a);
}
