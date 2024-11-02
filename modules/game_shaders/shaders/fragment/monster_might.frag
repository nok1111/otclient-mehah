uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

// Adjust the outline color and intensity
vec3 outlineColor = vec3(0.70, 0.0, 0.0);
float outlineIntensity = 0.4;

// Enhanced glow color and intensity
vec3 glowColor = vec3(0.85, 0.0, 0.0);
float glowIntensity = 2.5;       // Stronger glow effect
float glowRadius = 0.8;          // Increased radius for nearly full-sprite glow

void main()
{
  // Retrieve the color from the texture
  vec4 texColor = texture2D(u_Tex0, v_TexCoord);

  // Calculate the outline effect by comparing the texture color with its neighbors
  float outline = 3.0 * texColor.a - texture2D(u_Tex0, v_TexCoord + vec2(0.01, 0.0)).a
                                    - texture2D(u_Tex0, v_TexCoord - vec2(0.01, 0.0)).a
                                    - texture2D(u_Tex0, v_TexCoord + vec2(0.0, 0.01)).a
                                    - texture2D(u_Tex0, v_TexCoord - vec2(0.0, 0.01)).a;

  // Apply the outline color and intensity
  vec3 outlineEffect = outlineIntensity * outline * outlineColor;

  // Calculate the distance from the current texel to the center
  float distance = length(vec2(0.5, 0.5) - v_TexCoord);

  // Calculate the animation factor based on time
  float animationFactor = sin(u_Time * 2.0);

  // Calculate the glow effect over almost the whole sprite
  float glow = smoothstep(1.0 - glowRadius, 1.0, distance + animationFactor * 0.02);

  // Apply the glow color and enhanced intensity
  vec3 glowEffect = glowIntensity * glow * glowColor;

  // Combine the original texture color with the outline and enhanced glow effects
  vec3 finalColor = texColor.rgb + outlineEffect + glowEffect;

  // Output the final color with the original alpha value
  gl_FragColor = vec4(finalColor, texColor.a);
}
