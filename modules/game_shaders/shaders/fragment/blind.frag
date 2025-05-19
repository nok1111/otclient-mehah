uniform sampler2D u_Tex0;    // Screen texture
uniform float u_Intensity;   // Blindness strength (0.0 to 1.0)
uniform vec2 u_Resolution;   // Screen resolution (pixel size)
varying vec2 v_TexCoord;     // Texture coordinates

void main() {
    // Get screen-space coordinates (0 to 1, but stable)
    vec2 uv = gl_FragCoord.xy / u_Resolution;
    vec3 color = texture2D(u_Tex0, v_TexCoord).rgb; // Still sample original UVs
    
    // Fixed screen center (always middle of the window)
    vec2 center = vec2(0.5, 0.57);
    float dist = distance(uv, center);
    
    // Static spotlight size (adjust these values)
    float spotlightSize = 0.1; // 10% of screen radius
    float visibility = smoothstep(spotlightSize, spotlightSize - 0.09, dist);
    
    // Darkness outside spotlight
    float darkness = 0.015; // 90% darkness outside
    color = color * visibility + (color * darkness * (1.0 - visibility));
    
    gl_FragColor = vec4(color, 1.0);
}