/// @description obj_player DRAW event, draw with shader

if (red_border_active) {
    shader_set(shd_red_border);
    var _u_intensity = shader_get_uniform(shd_red_border, "u_intensity");
    shader_set_uniform_f(_u_intensity, red_border_intensity);
	
	show_debug_message($"shd_red_border testing {_u_intensity}");
    
    // Draw a full-screen rectangle
    draw_rectangle_color(x, y, 50, 100, c_red, c_red, c_red, c_red, false);
    
    shader_reset();
}

if (use_trail_shader && trail_intensity > 0) {
    shader_set(sh_bounce_trail);
    shader_set_uniform_f(shader_get_uniform(sh_bounce_trail, "trail_intensity"), trail_intensity);
    shader_set_uniform_f_array(shader_get_uniform(sh_bounce_trail, "trail_color"), [
        color_get_red(trail_color)/255, color_get_green(trail_color)/255, color_get_blue(trail_color)/255, 1.0
    ]);
    shader_set_uniform_i(shader_get_uniform(sh_bounce_trail, "trail_count"), trail_count);

    // Draw trail
    for (var _i = 0; _i < ds_list_size(trail_positions); _i++) {
        var _pos = trail_positions[|_i];
        var _alpha = 1 - (_i / trail_count);
        draw_sprite_ext(sprite_index, image_index, _pos[0], _pos[1], image_xscale, image_yscale, image_angle, trail_color, _alpha * trail_intensity);
    }

    shader_reset();
}


// Draw the player
draw_self();
//debug_render_mask();
