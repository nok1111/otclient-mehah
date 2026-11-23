// Elemental herb node: ember (fire). Keeps sprite colors, adds an orange
// ember tint + flicker inside the sprite and a soft pulsing fire glow
// around its edges.
const float offset = 1.0 / 64.0;
uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

const vec3 emberColor = vec3(1.0, 0.38, 0.06);
const vec3 glowColor = vec3(1.0, 0.25, 0.0);

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);
    if (col.a > 0.5) {
        // inner ember tint + animated flicker (hot spots drift upward)
        float flicker = 0.85 + 0.15 * sin(u_Time * 8.0 + v_TexCoord.y * 24.0);
        vec3 tinted = mix(col.rgb, emberColor, 0.35);
        gl_FragColor = vec4(tinted * flicker, col.a);
        return;
    }

    float a = texture2D(u_Tex0, vec2(v_TexCoord.x + offset, v_TexCoord.y)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x - offset, v_TexCoord.y)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y + offset)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y - offset)).a;

    if (a > 0.0) {
        float pulse = 0.55 + 0.45 * sin(u_Time * 7.0);
        gl_FragColor = vec4(glowColor * pulse, 0.85);
    } else {
        gl_FragColor = col;
    }
}
