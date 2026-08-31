uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

// Iaijutsu flash shader — a quick, intense white-gold pulse that fades rapidly.
// Simulates the flash of the sword being drawn and sheathed in one motion.

void main()
{
    vec4 texColor = texture2D(u_Tex0, v_TexCoord);

    // Rapid pulse: starts intense, fades out over ~0.4s
    // u_Time is in seconds; we use a fast sine + decay
    float pulse = 0.5 + 0.5 * sin(u_Time * 8.0);
    float decay = clamp(1.0 - u_Time * 2.5, 0.0, 1.0);

    // White-gold flash color
    vec3 flashColor = vec3(1.0, 0.95, 0.7);
    float flashIntensity = (0.6 + pulse * 0.8) * decay;

    // Radial glow from center of the outfit
    float dist = length(vec2(0.5, 0.4) - v_TexCoord);
    float glow = smoothstep(0.55, 0.0, dist) * flashIntensity;

    // Edge brightening — simulates light catching the blade edge
    float edge = 3.0 * texColor.a
        - texture2D(u_Tex0, v_TexCoord + vec2(0.01, 0.0)).a
        - texture2D(u_Tex0, v_TexCoord - vec2(0.01, 0.0)).a
        - texture2D(u_Tex0, v_TexCoord + vec2(0.0, 0.01)).a
        - texture2D(u_Tex0, v_TexCoord - vec2(0.0, 0.01)).a;
    vec3 edgeGlow = flashColor * edge * 0.3 * decay;

    vec3 finalColor = texColor.rgb + flashColor * glow + edgeGlow;

    gl_FragColor = vec4(finalColor, texColor.a);
    if(gl_FragColor.a < 0.01) discard;
}
