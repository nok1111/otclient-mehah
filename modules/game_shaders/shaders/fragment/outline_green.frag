// Quest-item style outline shader (pulsing glow, green)
const float offset = 1.0 / 64.0;
uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

const vec3 outlineColor = vec3(0.25, 1.0, 0.35);

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);
    if (col.a > 0.5) {
        gl_FragColor = col;
        return;
    }

    float a = texture2D(u_Tex0, vec2(v_TexCoord.x + offset, v_TexCoord.y)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x - offset, v_TexCoord.y)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y + offset)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y - offset)).a;

    if (a > 0.0) {
        float pulse = 0.65 + 0.35 * sin(u_Time * 6.0);
        gl_FragColor = vec4(outlineColor * pulse, 0.95);
    } else {
        gl_FragColor = col;
    }
}
