// shd_red_border.fsh
varying vec2 v_texcoord;

uniform float u_intensity;

void main()
{
    vec4 base_color = texture2D(gm_BaseTexture, v_texcoord);
    
    // Calculate distance from edge, make the border wider
    vec2 dist = abs(v_texcoord - 0.5) * 2.0;
    float edge_distance = max(dist.x, dist.y);
    
    // Increase the effect by squaring the edge_distance
    edge_distance = edge_distance * edge_distance;
    
    // Apply red tint based on edge distance and intensity
    vec3 red_tint = mix(base_color.rgb, vec3(1.0, 0.0, 0.0), clamp(edge_distance * u_intensity * 2.0, 0.0, 1.0));
    
    gl_FragColor = vec4(red_tint, base_color.a);
}
