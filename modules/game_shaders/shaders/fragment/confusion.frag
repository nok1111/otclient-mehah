uniform sampler2D u_Tex0; // The screen texture
uniform float u_Time;     // Time for animation
uniform vec2 u_Resolution; // Screen resolution
uniform float u_Intensity; // Control effect strength (0.0 to 1.0)
varying vec2 v_TexCoord;  // Texture coordinates

void main() {
    // Warp the texture coordinates with a sine wave for a disorienting effect
    vec2 uv = v_TexCoord;
    uv.x += sin(u_Time * 2.0 + uv.y * 10.0) * 0.01 * u_Intensity;
    uv.y += cos(u_Time * 1.5 + uv.x * 8.0) * 0.01 * u_Intensity;

    // Shift colors (red and blue channels swap slightly)
    vec3 color = texture2D(u_Tex0, uv).rgb;
    float r = color.r * (0.9 + 0.1 * sin(u_Time * 3.0));
    float g = color.g;
    float b = color.b * (0.9 + 0.1 * cos(u_Time * 2.0));

    // Apply a slight vignette to enhance the effect
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
    float vignette = 1.0 - dist * 0.5 * u_Intensity;

    gl_FragColor = vec4(r * vignette, g * vignette, b * vignette, 1.0);
}