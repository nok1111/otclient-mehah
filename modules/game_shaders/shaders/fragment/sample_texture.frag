uniform float u_Time;
uniform sampler2D u_Tex0;
uniform sampler2D u_Tex1;
varying vec2 v_TexCoord;
uniform vec2 u_WalkOffset;

void main(void)
{
  vec2 animatedUv = v_TexCoord + (u_WalkOffset * 0.35) + vec2(u_Time * 0.04, -u_Time * 0.02);

  vec3 baseColor = texture2D(u_Tex0, v_TexCoord).rgb;
  vec3 overlay = texture2D(u_Tex1, animatedUv).rgb;

  float intensity = 0.35;
  vec3 finalColor = mix(baseColor, baseColor + overlay * 0.8, intensity);
  gl_FragColor = vec4(finalColor, 1.0);
}
