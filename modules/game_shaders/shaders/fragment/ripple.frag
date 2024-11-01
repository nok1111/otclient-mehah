uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
uniform float u_Time;  // Elapsed time for animation

void main()
{
    // Retrieve the color from the texture
    vec4 texColor = texture2D(u_Tex0, v_TexCoord);

    // Calculate the displacement amount using sine functions for ripples
    float rippleX = sin(v_TexCoord.y * 15.0 + u_Time * 2.0) * 0.005;
    float rippleY = sin(v_TexCoord.x * 15.0 + u_Time * 2.0) * 0.005;

    // Apply the displacement to the texture coordinates
    vec2 offset = vec2(rippleX, rippleY);
    vec4 displacedColor = texture2D(u_Tex0, v_TexCoord + offset);

    // Mix the displaced color with the original texture color
    vec3 finalColor = mix(texColor.rgb, displacedColor.rgb, 0.85);

    // Output the final color with the original alpha value
    gl_FragColor = vec4(finalColor, texColor.a);
}
