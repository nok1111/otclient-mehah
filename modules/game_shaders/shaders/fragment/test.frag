uniform sampler2D u_Texture;
varying vec2 v_TexCoord;
uniform float u_Time;

void main() {
    vec4 texColor = texture2D(u_Texture, v_TexCoord);

    // Define the center point of the energy field
    vec2 center = vec2(0.5, 0.5);

    // Calculate the distance from the current texture coordinate to the center
    float distance = length(v_TexCoord - center);

    // Calculate the pulsating effect using sine function
    float pulsate = sin(u_Time * 5.0 + distance * 10.0) * 0.5 + 0.5;

    // Define the color of the energy field (cyan for Super Saiyan aura)
    vec3 energyColor = vec3(0.0, 1.0, 1.0); // Cyan

    // Apply the pulsating effect to the energy field color
    vec3 finalColor = mix(texColor.rgb, energyColor, pulsate);

    // Define the outline color (bright yellow for Super Saiyan effect)
    vec3 outlineColor = vec3(1.0, 1.0, 0.0); // Bright yellow

    // Define the outline thickness and smoothness
    float outlineThickness = 0.03; // Adjust outline thickness as desired
    float outlineSmoothness = 0.02; // Adjust smoothness for transition

    // Calculate the distance from the current texture coordinate to the outline
    float outlineDistance = distance - outlineThickness;

    // Apply smoothstep to create a smooth transition for the outline
    float outlineFactor = smoothstep(0.0, outlineSmoothness, outlineDistance);

    // Mix the outline color with the final color based on the outline factor
    finalColor = mix(finalColor, outlineColor, outlineFactor);

    // Apply transparency
    finalColor *= 0.8; // Set transparency to 0.8

    gl_FragColor = vec4(finalColor, texColor.a);
}
