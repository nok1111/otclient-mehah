// Elemental herb node: crystal. Keeps sprite colors, adds an icy blue tint
// + a traveling sparkle band across the sprite and a soft cold glow
// around its edges.
const float offset = 1.0 / 64.0;
uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

const vec3 iceColor = vec3(0.4, 0.78, 1.0);
const vec3 glowColor = vec3(0.55, 0.85, 1.0);

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);
    if (col.a > 0.5) {
        vec3 tinted = mix(col.rgb, iceColor, 0.35);
        // diagonal sparkle band sweeping the sprite
        float band = fract((v_TexCoord.x + v_TexCoord.y) * 0.5 - u_Time * 0.6);
        float sparkle = smoothstep(0.9, 1.0, band) * 0.9;
        gl_FragColor = vec4(tinted + iceColor * sparkle, col.a);
        return;
    }

    float a = texture2D(u_Tex0, vec2(v_TexCoord.x + offset, v_TexCoord.y)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x - offset, v_TexCoord.y)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y + offset)).a +
              texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y - offset)).a;

    if (a > 0.0) {
        float pulse = 0.6 + 0.4 * sin(u_Time * 5.0);
        gl_FragColor = vec4(glowColor * pulse, 0.8);
    } else {
        gl_FragColor = col;
    }
}
