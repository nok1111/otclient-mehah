uniform float u_Time;
uniform sampler2D u_Tex0;
uniform sampler2D u_Tex1;
uniform mat3 u_TextureMatrix;
varying vec2 v_TexCoord;

void main(void)
{
  // Build frame-local UV from atlas UV to avoid reset/flicker when outfit
  // animation switches atlas frame while walking.
  float frameSizePx = 64.0;
  float rockScale = 1.0;
  vec2 atlasSize = vec2(
    1.0 / max(abs(u_TextureMatrix[0][0]), 0.00001),
    1.0 / max(abs(u_TextureMatrix[1][1]), 0.00001)
  );
  vec2 atlasPixelUv = v_TexCoord * atlasSize;
  vec2 localFrameUv = mod(atlasPixelUv, vec2(frameSizePx)) / frameSizePx;
  vec2 rockUv = fract(localFrameUv * rockScale);

  vec4 base = texture2D(u_Tex0, v_TexCoord);
  vec3 rock = texture2D(u_Tex1, rockUv).rgb;

  // Desaturate the outfit to keep its silhouette/shading under the rock.
  float luma = dot(base.rgb, vec3(0.299, 0.587, 0.114));

  // Rock texture modulated by the outfit shading, tinted toward cold stone.
  vec3 stone = rock * (0.45 + 0.55 * luma) * vec3(1.0, 0.98, 0.92);

  // Faint slow pulse so the buff reads as active without looking liquid.
  stone *= 1.0 + 0.05 * sin(u_Time * 1.5);

  float mask = smoothstep(0.05, 0.9, base.a);
  vec3 colorized = mix(base.rgb, stone, 0.85);

  gl_FragColor = vec4(mix(base.rgb, colorized, mask), base.a);
}
