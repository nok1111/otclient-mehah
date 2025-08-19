const float offset = 1.0 / 64.0;
uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);
    if (col.a > 0.5)
        gl_FragColor = col;
    else {
        float a = texture2D(u_Tex0, vec2(v_TexCoord.x + offset, v_TexCoord.y)).a +
                  texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y - offset)).a +
                  texture2D(u_Tex0, vec2(v_TexCoord.x - offset, v_TexCoord.y)).a +
                  texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y + offset)).a;
        if (col.a < 1.0 && a > 0.0) {
            float blue = 0.8 + 0.2 * sin(u_Time * 2.0);
            float green = 0.9 + 0.1 * cos(u_Time * 2.0);
            float red = 0.3 + 0.1 * sin(u_Time * 1.5);
            gl_FragColor = vec4(red, green, blue, 0.7);
        } else {
            gl_FragColor = col;
        }
    }
}
