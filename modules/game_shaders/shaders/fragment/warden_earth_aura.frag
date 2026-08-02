uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);
    float pulse = 0.5 + 0.5 * sin(u_Time * 2.0);

    // tint green/leaves while preserving alpha
    col.r *= 0.3 + 0.15 * pulse;
    col.g = min(col.g * (1.1 + 0.25 * pulse) + 0.12 * pulse, 1.0);
    col.b *= 0.35;

    gl_FragColor = col;
    if (gl_FragColor.a < 0.01) discard;
}
