uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

const float metallicStrength = 0.17; // Adjust the strength of the metallic effect
const vec3 metallicColor = vec3(0.0078, 0.886, 0.988); // #02e2fc
const float lightIntensity = 0.6; // Adjust the intensity of the light effect

const float lightWidth = 0.2; // Adjust the width of the light effect
const float lightSpeed = 0.12; // Adjust the speed of the light effect





void main()
{
  // Retrieve the color from the texture
  vec4 texColor = texture2D(u_Tex0, v_TexCoord);

  // Calculate the metallic color by interpolating between the original color and the metallic color
  vec3 finalColor = mix(texColor.rgb, metallicColor, metallicStrength);

  // Calculate the light position based on time and texture coordinates
  //float lightPos = fract(u_Time * lightSpeed); BEFORE

  float phase = fract(u_Time * lightSpeed);
float lightPos = phase < 0.5 ? phase * 2.0 : (1.0 - phase) * 2.0;

  // Calculate the distance from the light position to the current texture coordinate
  float lightDistance = abs(v_TexCoord.y - lightPos);

  // Check if the current texture coordinate is within the outfit boundaries
  if (lightDistance <= lightWidth) {
    // Calculate the blend factor based on the distance
    float blendFactor = 1.0 - lightDistance / lightWidth;

    // Calculate the light color using noise
    float lightColor = 0.5 + 0.5;

    // Blend the light color into the final color
    finalColor = mix(finalColor, finalColor + lightColor, blendFactor);
  }

  // Output the final color with the original alpha value
  gl_FragColor = vec4(finalColor, texColor.a);
  if(gl_FragColor.a < 0.01) discard;
}
