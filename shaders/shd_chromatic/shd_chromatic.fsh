varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float aberration_amount;
uniform float time;

vec2 barrelDistortion(vec2 coord, float amt) {
    vec2 cc = coord - 0.5;
    float dist = dot(cc, cc);
    return coord + cc * (dist * amt);
}

void main()
{
    vec2 uv = v_vTexcoord;
    
    // Apply barrel distortion
    uv = barrelDistortion(uv, aberration_amount * 0.2);
    
    // Add time-based wave distortion
    float wave = sin(uv.y * 20.0 + time) * 0.001;
    uv.x += wave;
    
    // Calculate RGB channel offsets
    vec2 r_offset = vec2(aberration_amount * (1.0 + sin(time * 2.0) * 0.1), 0.0);
    vec2 b_offset = vec2(-aberration_amount * (1.0 + cos(time * 2.0) * 0.1), 0.0);
    
    // Sample the texture for each color channel
    vec4 r = texture2D(gm_BaseTexture, uv + r_offset);
    vec4 g = texture2D(gm_BaseTexture, uv);
    vec4 b = texture2D(gm_BaseTexture, uv + b_offset);
    
    // Combine the channels
    vec4 final_color = vec4(r.r, g.g, b.b, g.a);
    
    // Add vignette effect
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
    float vignette = smoothstep(0.8, 0.2, dist * (1.0 + aberration_amount * 2.0));
    final_color.rgb *= vignette;
    
    gl_FragColor = final_color * v_vColour;
}
