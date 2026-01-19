uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;

// Slime parameters
const float slimeStrength = 0.65; // How much slime color to apply
const vec3 slimeColor = vec3(0.2, 0.9, 0.3); // Bright green slime color
const float glossSpeed = 0.15; // Speed of glossy highlight movement
const float glossIntensity = 1.2; // Brightness of the gloss
const float glossWidth = 0.015; // Width of the glossy highlight
const float wobbleSpeed = 3.0; // Speed of gelatinous wobble
const float wobbleAmount = 0.008; // Amount of wobble displacement
const float pulseSpeed = 2.0; // Speed of slime pulsation
const float pulseAmount = 0.15; // Amount of color pulsation

// Simple noise function for variation
float noise(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{
    // Create gelatinous wobble effect
    float wobbleX = sin(v_TexCoord.y * 20.0 + u_Time * wobbleSpeed) * wobbleAmount;
    float wobbleY = sin(v_TexCoord.x * 20.0 + u_Time * wobbleSpeed * 1.3) * wobbleAmount;
    vec2 wobbleOffset = vec2(wobbleX, wobbleY);
    
    // Sample texture with wobble
    vec4 texColor = texture2D(u_Tex0, v_TexCoord + wobbleOffset);
    
    // Calculate pulsating slime intensity
    float pulse = sin(u_Time * pulseSpeed) * pulseAmount + 1.0;
    vec3 adjustedSlimeColor = slimeColor * pulse;
    
    // Mix original color with slime color
    vec3 baseColor = mix(texColor.rgb, adjustedSlimeColor, slimeStrength);
    
    // Add glossy highlight that moves across the slime
    float glossPos = mod(u_Time * glossSpeed, 1.0);
    
    // Create diagonal gloss movement
    float glossCoord = v_TexCoord.y * 0.7 + v_TexCoord.x * 0.3;
    float glossDistance = abs(glossCoord - glossPos);
    
    // Smooth glossy highlight
    float glossEffect = smoothstep(glossWidth, 0.0, glossDistance);
    
    // Add noise to gloss for more natural look
    float glossNoise = 0.7 + 0.3 * noise(vec2(glossPos * 10.0, u_Time));
    glossEffect *= glossNoise;
    
    // Apply gloss as additive light
    vec3 finalColor = baseColor + vec3(glossEffect * glossIntensity);
    
    // Add subtle translucent/gel effect around edges
    vec2 center = vec2(0.5, 0.5);
    float distFromCenter = length(v_TexCoord - center);
    float edgeGlow = smoothstep(0.6, 0.3, distFromCenter) * 0.15;
    finalColor += slimeColor * edgeGlow;
    
    // Output final color with original alpha
    gl_FragColor = vec4(finalColor, texColor.a);
    
    // Discard fully transparent pixels
    if(gl_FragColor.a < 0.01) discard;
}
