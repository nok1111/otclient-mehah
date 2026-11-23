// Elemental herb node: soul. Keeps sprite colors, adds a pale cyan spectral
// tint + slow breathing pulse inside the sprite and a soft spirit glow
// around its edges.
const float offset = 1.0 / 64.0;
uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

const vec3 soulColor = vec3(0.65, 0.85, 1.0);
const vec3 glowColor = vec3(0.45, 0.7, 1.0);

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);
    if (col.a > 0.5) {
        // spectral breathe: brightness slowly rises and falls
        float breathe = 0.85 + 0.15 * sin(u_Time * 3.0 + v_TexCoord.x * 18.0);
        vec3 tinted = mix(col.rgb, soulColor, 0.4);
        gl_FragColor = vec4(tinted * breathe, col.a);
        return;
    }

    float a = texture2D(u_Tex0, vec2(v_TexCoord.x + offset, v_TexCoord.y)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x - offset, v_TexCoord.y)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y + offset)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y - offset)).a;

    if (a > 0.0) {
        float pulse = 0.5 + 0.5 * sin(u_Time * 4.0);
        gl_FragColor = vec4(glowColor * pulse, 0.7 * pulse);
    } else {
        gl_FragColor = col;
    }
}
