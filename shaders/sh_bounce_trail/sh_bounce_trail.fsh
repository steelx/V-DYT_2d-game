//
// Bounce fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 trail_color;
uniform float trail_intensity;
uniform float time;

void main()
{
    vec4 base_color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Create a vertical gradient
    float gradient = 1.0 - v_vTexcoord.y;
    
    // Add some waviness to the trail
    float wave = sin(v_vTexcoord.y * 10.0 + time * 5.0) * 0.1;
    gradient += wave;
    
    // Mix the base color with the trail color based on the gradient and intensity
    vec4 final_color = mix(base_color, trail_color, gradient * trail_intensity);
    
    gl_FragColor = final_color;
}

