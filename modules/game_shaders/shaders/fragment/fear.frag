uniform sampler2D u_Tex0;      // Screen texture
uniform float u_Time;          // For animation
uniform vec2 u_Resolution;     // Screen resolution
varying vec2 v_TexCoord;       // Texture coordinates

// ===== USER-ADJUSTABLE VARIABLES ===== //
float Effintensity = 0.5;      // Tunnel vision size (0.3 to 1.0)
float shakePower = 0.1;       // Screen shake intensity (0.0 to 0.1)
float vignetteDarkness = 0.3;  // Edge darkness (0.0 to 1.0)
float colorDrain = 0.8;        // Color desaturation (0.0 = normal, 1.0 = grayscale)
float noiseAmount = 0.1;       // Grainy noise (0.0 to 0.3)
float vignetteSize = 0.2;      // Tunnel vision size (0.3 to 1.0)
// ===================================== //

// Random noise function (FIXED: Added missing parenthesis)
float rand(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // --- Base color ---
    vec3 color = texture2D(u_Tex0, v_TexCoord).rgb;

    // --- EFFECT 1: Dynamic Screen Shake ---
    vec2 uv = v_TexCoord;
    uv.x += (rand(vec2(u_Time, 1.0)) - 0.5) * shakePower * Effintensity;
    uv.y += (rand(vec2(u_Time, 2.0)) - 0.5) * shakePower * Effintensity;
    color = texture2D(u_Tex0, uv).rgb;

    // --- EFFECT 2: Tunnel Vision ---
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(v_TexCoord, center);
    float vignette = 1.0 - smoothstep(vignetteSize * 0.5, vignetteSize, dist) * vignetteDarkness * 1;
    color *= vignette;

    // --- EFFECT 3: Color Drain ---
    float grayscale = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(color, vec3(grayscale), colorDrain * 0.6);

    // --- EFFECT 4: Panic Grain ---
    float noise = rand(v_TexCoord * u_Time) * noiseAmount * 0.8;
    color += vec3(noise);

    gl_FragColor = vec4(color, 1.0);
}