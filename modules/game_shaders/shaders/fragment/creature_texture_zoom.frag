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
  float imagesize = 0.5;
  vec2 atlasSize = vec2(
    1.0 / max(abs(u_TextureMatrix[0][0]), 0.00001),
    1.0 / max(abs(u_TextureMatrix[1][1]), 0.00001)
  );
  vec2 atlasPixelUv = v_TexCoord * atlasSize;
  vec2 localFrameUv = mod(atlasPixelUv, vec2(frameSizePx)) / frameSizePx;
  vec2 movementSpeed = vec2(0.10, -0.06);
  vec2 flowUv = fract(localFrameUv * imagesize + u_Time * movementSpeed);
  float textureOpacity = 0.73;

  vec4 base = texture2D(u_Tex0, v_TexCoord);
  vec3 fx = texture2D(u_Tex1, flowUv).rgb;

  float mask = smoothstep(0.05, 0.9, base.a);
  float textureContrast = 1.0;
  vec3 fxBoosted = clamp((fx - 0.5) * textureContrast + 0.5, 0.0, 1.0);
  vec3 colorized = mix(base.rgb, fxBoosted, textureOpacity);

  gl_FragColor = vec4(mix(base.rgb, colorized, mask), base.a);
}
