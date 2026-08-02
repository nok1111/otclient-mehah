uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

void main()
{
    vec4 texColor = texture2D(u_Tex0, v_TexCoord);

    // Pulsing glow factor (0.5 to 1.0)
    float pulse = 0.5 + 0.5 * sin(u_Time * 3.0);

    // White glow color with pulsing intensity
    vec3 glowColor = vec3(1.0, 1.0, 1.0);
    float glowIntensity = 0.8 + pulse * 0.6;

    // Distance from center for radial glow
    float dist = length(vec2(0.5, 0.5) - v_TexCoord);
    float glow = smoothstep(0.5, 0.0, dist) * glowIntensity;

    vec3 finalColor = texColor.rgb + glowColor * glow * pulse;

    gl_FragColor = vec4(finalColor, texColor.a);
}
