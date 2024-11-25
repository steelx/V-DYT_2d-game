/// @description obj_player DRAW event, draw with shader

if (red_border_active) {
    shader_set(shd_red_border);
    var _u_intensity = shader_get_uniform(shd_red_border, "u_intensity");
    shader_set_uniform_f(_u_intensity, red_border_intensity);
    
    // Draw a full-screen rectangle
    draw_rectangle_color(x, y, 50, 100, c_red, c_red, c_red, c_red, false);
    
    shader_reset();
}

// Draw the player
draw_self();
//debug_render_mask();
