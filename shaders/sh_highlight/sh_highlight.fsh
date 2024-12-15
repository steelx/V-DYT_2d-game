///// sh_highlight.fsh (Fragment Shader)
varying vec2 v_texcoord;
varying vec4 v_color;
uniform vec3 u_highlight_color;
uniform float u_thickness;
uniform vec2 u_texel_size;
uniform float u_time;

void main()
{
    vec4 texture_color = texture2D(gm_BaseTexture, v_texcoord);
    
    // Check surrounding pixels in all 8 directions
    float alpha = 0.0;
    for(float i = -u_thickness; i <= u_thickness; i++) {
        for(float j = -u_thickness; j <= u_thickness; j++) {
            if(i == 0.0 && j == 0.0) continue;
            vec2 offset = vec2(i * u_texel_size.x, j * u_texel_size.y);
            alpha += texture2D(gm_BaseTexture, v_texcoord + offset).a;
        }
    }
    
    // Calculate blink state (0 or 1) using step function for sharp on/off
    float blink = step(0.0, sin(u_time * 10.0));// u_time * speed
    
    // If we're on the border of the sprite AND the highlight is in its "on" state
    if(alpha > 0.0 && alpha < 8.0 * u_thickness * u_thickness && blink > 0.5) {
        gl_FragColor = vec4(u_highlight_color, 1.0);
    } else {
        gl_FragColor = texture_color * v_color;
    }
}
