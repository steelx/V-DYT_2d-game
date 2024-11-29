/// @description obj_game Draw GUI
// Pause menu surface
if (global.game_state == GAME_STATES.PAUSED && global.show_game_menu) {
    var _surf_w = display_get_gui_width();
    var _surf_h = display_get_gui_height();
    if (!surface_exists(menu_surface)) {
        menu_surface = surface_create(_surf_w, _surf_h);
        _needs_redraw = true;
    }
    if (_needs_redraw) {
        surface_set_target(menu_surface);
        draw_clear_alpha(c_black, 0);
        
        // Draw semi-transparent background
        draw_set_alpha(0.7);
        draw_rectangle_color(0, 0, _surf_w, _surf_h, c_black, c_black, c_black, c_black, false);
        draw_set_alpha(1);
        
        // Draw "Paused" title
        draw_set_font(menu_font);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _center_x = _surf_w / 2;
        var _center_y = _surf_h / 2;
        draw_text_color(_center_x, _center_y - 200, "Paused", c_white, c_white, c_white, c_white, 1);
        
        // Draw menu options
        var _total_height = menu_item_height * array_length(menu_options);
        var _start_y = _center_y - (_total_height / 2) + (menu_item_height / 2);
        for (var _i = 0; _i < array_length(menu_options); _i++) {
            var _option_y = _start_y + (_i * menu_item_height);
            var _color = (_i == menu_index) ? c_yellow : c_white;
            draw_text_color(_center_x, _option_y, menu_options[_i], _color, _color, _color, _color, 1);
        }
        
        surface_reset_target();
        _needs_redraw = false;
    }
    // Draw the pause menu surface
    draw_surface(menu_surface, 0, 0);
	
	// Reset draw settings
    clear_text_color();
}


if (slow_mo_active) {
    // Add a slight darkening effect
    draw_set_alpha(0.2);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    
    // Optional: Draw slow-mo timer
    draw_set_color(c_white);
    draw_text(10, 10, "SLOW MOTION: " + string(slow_mo_timer));
}