uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

// Iaijutsu cut shader — converts the red slash sprite to silver/platinum
// with a moving shine that simulates light catching a polished blade.

void main()
{
    vec4 texColor = texture2D(u_Tex0, v_TexCoord);

    // Use the red channel as intensity (original sprite is red)
    float intensity = texColor.r;

    // Silver/platinum base color
    vec3 silver = vec3(0.92, 0.92, 0.95);
    // Brighter platinum for highlights
    vec3 platinum = vec3(1.0, 0.98, 0.95);

    // Map intensity to silver gradient (dark silver → bright platinum)
    vec3 finalColor = mix(silver * 0.3, platinum, intensity);

    // Moving shine — a band of light that sweeps across the slash
    float shineSpeed = 3.0;
    float shineWidth = 0.15;
    float shinePos = fract(u_Time * shineSpeed);
    float shineDist = abs(v_TexCoord.x - shinePos);
    float shine = smoothstep(shineWidth, 0.0, shineDist);

    // Only apply shine where the slash exists (use alpha as mask)
    float shineMask = texColor.a * shine;
    finalColor += vec3(1.0, 0.97, 0.85) * shineMask * 0.8;

    // Edge glow — brighten the edges of the slash for that "keen edge" look
    float edge = 3.0 * texColor.a
        - texture2D(u_Tex0, v_TexCoord + vec2(0.01, 0.0)).a
        - texture2D(u_Tex0, v_TexCoord - vec2(0.01, 0.0)).a
        - texture2D(u_Tex0, v_TexCoord + vec2(0.0, 0.01)).a
        - texture2D(u_Tex0, v_TexCoord - vec2(0.0, 0.01)).a;
    finalColor += platinum * edge * 0.4;

    gl_FragColor = vec4(finalColor, texColor.a);
    if(gl_FragColor.a < 0.01) discard;
}
