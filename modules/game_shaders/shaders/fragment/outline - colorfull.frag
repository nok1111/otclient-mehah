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
            float intensity = (cos(u_Time * 9.57) + 1.0)/2.0;
            float transitionColor = 0.5 + 0.5 * sin(u_Time * 3.14); // Creates a dynamic purple blend
            gl_FragColor = vec4(intensity * 0.9, intensity * 0.4, transitionColor, 1.0);
        } else {
            gl_FragColor = col;
        }
    }
}
