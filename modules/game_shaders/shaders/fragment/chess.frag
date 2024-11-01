uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
uniform float u_Time;  // Elapsed time for animation

// Chessboard colors
vec3 color1 = vec3(1.0, 1.0, 1.0); // White
vec3 color2 = vec3(0.0, 0.0, 0.0); // Black

void main()
{
    // Size of each square in the chessboard pattern
    float squareSize = 150.0 + sin(u_Time) * 15.0; // Dynamic size with animation

    // Calculate the grid coordinates
    vec2 gridPos = floor(v_TexCoord * squareSize);

    // Determine the color of the current square
    vec3 chessColor = mod(gridPos.x + gridPos.y, 2.0) < 1.0 ? color1 : color2;

    // Mix the chess color with the texture color
    vec4 texColor = texture2D(u_Tex0, v_TexCoord);
    vec4 finalColor = vec4(mix(texColor.rgb, chessColor, 0.85), texColor.a);

    gl_FragColor = finalColor;
}