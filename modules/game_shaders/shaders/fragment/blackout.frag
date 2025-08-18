
uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

// Adjust the outline color and intensity
vec3 outlineColor = vec3(0.0, 0.0, 0.0);
float outlineIntensity = 0.4;

// Adjust the glow color and intensity
vec3 glowColor = vec3(0.0, 0.0, 0.0);
float glowIntensity = 3.2;
float glowRadius = 0.5;

void main()
{
    vec4 texColor = texture2D(u_Tex0, v_TexCoord);
    // Output black with the original alpha from the texture
    gl_FragColor = vec4(0.0, 0.0, 0.0, texColor.a * 0.9);
}

