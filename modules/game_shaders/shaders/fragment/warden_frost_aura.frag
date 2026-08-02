uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);
    float pulse = 0.5 + 0.5 * sin(u_Time * 2.5);

    // tint blue/crystal while preserving alpha
    col.r *= 0.35;
    col.g *= 0.65 + 0.15 * pulse;
    col.b = min(col.b * (1.15 + 0.3 * pulse) + 0.15 * pulse, 1.0);

    gl_FragColor = col;
    if (gl_FragColor.a < 0.01) discard;
}
