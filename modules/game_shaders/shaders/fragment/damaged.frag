uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

// Flash parameters
float flashIntensity = 0.7; // 0 = no flash, 1 = full white
float flashSpeed = 3.0;     // how fast the flash pulses

// Shake parameters
float shakeAmount = 0.03;   // how much moved distance
float shakeSpeed = 3.0;    // how fast to shake

void main()
{
    // Flash: create a pulse that fades out over time
    float flash = flashIntensity * abs(sin(u_Time * flashSpeed));

    // Shake: offset UVs with a fast sine/cosine
    float shakeX = sin(u_Time * shakeSpeed) * shakeAmount;
    float shakeY = cos(u_Time * shakeSpeed * 0.7) * shakeAmount;
    vec2 shakenCoord = v_TexCoord + vec2(shakeX, shakeY);

    // Sample the texture at the shaken coordinates
    vec4 texColor = texture2D(u_Tex0, shakenCoord);

    // Mix the flash color (white) with the original color
    vec3 flashColor = mix(texColor.rgb, vec3(1.0, 1.0, 1.0), flash);

    // Output with original alpha
    gl_FragColor = vec4(flashColor, texColor.a);
}