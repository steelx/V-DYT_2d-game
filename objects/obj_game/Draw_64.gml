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
}
else {
    // GUI surface for player stats
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _scale = 1.0; // Adjust this value to change the overall UI scale
    
    if (instance_exists(obj_player)) {
        var _x = 16 * _scale;
        var _y = 0;
        var _bar_width = 69 * _scale;
        var _bar_height = 11 * _scale;
        var _icon_w = 54 * _scale;
        var _bar_center = 27 * _scale;
        var _spacing = 72 * _scale;
    
        // Health
        draw_player_health(_gui_w, _gui_h, _x, _y, _scale);
    
        // Jetpack Fuel
        var _screen_bottom = _gui_h - _spacing*2;
        _y += _screen_bottom;
        draw_sprite_ext(spr_ui_jetpack, 0, _x, _y, _scale, _scale, 0, c_white, 1);
        var _jetpack_ratio = obj_player.jetpack_fuel / obj_player.jetpack_max_fuel;
        draw_set_color(c_aqua);
        draw_rectangle(_x+_icon_w, _y+_bar_center, _x+_icon_w+_bar_width * _jetpack_ratio, _y+_bar_center+_bar_height, false);
    
        // Super Attack Charge
        var _jetpack_image_w = sprite_get_width(spr_ui_jetpack);
        _x += _jetpack_image_w;
        draw_sprite_ext(spr_ui_super_attack, 0, _x, _y, _scale, _scale, 0, c_white, 1);
        var _attack_ratio = obj_player.attack_fuel / obj_player.attack_fuel_max;
    
        // Calculate charge time for Super Attack
        var _remaining_fuel = obj_player.attack_fuel_max - obj_player.attack_fuel;
        var _frames_to_full = _remaining_fuel / obj_player.attack_fuel_regeneration_rate;
        var _seconds_to_full = ceil(_frames_to_full / game_get_speed(gamespeed_fps));
        
        // Draw charge time for Super Attack
        draw_set_font(font_stats_small);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text_color(_x+_icon_w+_scale+5, _y+_bar_center-5, string(_seconds_to_full) + " s", c_white, c_white, c_white, c_white, 1);
    }
}
