/// @description obj_game Draw GUI

// Pause menu surface
if (global.game_state == GAME_STATES.PAUSED && global.show_game_menu) {
    var _surf_w = window_get_width()/2;
    var _surf_h = window_get_height()/2;
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
        draw_text_color(_center_x, _center_y - 50, "Paused", c_white, c_white, c_white, c_white, 1);
        
        // Draw menu options
        // ... existing code ...
        
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
    var _scale = 0.75; // Adjust this value to change the overall UI scale
    if (!surface_exists(gui_surface)) {
        gui_surface = surface_create(_gui_w, _gui_h);
        _gui_needs_redraw = true;
    }
    
    surface_set_target(gui_surface);
    draw_clear_alpha(c_white, 0);
    
    if (instance_exists(obj_player)) {
        var _x = 16 * _scale;
        var _y = 0;
        var _bar_width = 69 * _scale;
        var _bar_height = 11 * _scale;
        var _icon_w = 54 * _scale;
        var _bar_center = 27 * _scale;
        var _spacing = 72 * _scale;
    
        // Health
        draw_sprite_ext(spr_ui_health, 0, _x, _y, _scale, _scale, 0, c_white, 1);
        var _health_ratio = obj_player.hp / obj_player.max_hp;
        draw_set_color(c_green);
        draw_rectangle(_x+_icon_w, _y+_bar_center, _x+_icon_w+_bar_width * _health_ratio, _y+_bar_center+_bar_height, false);
    
        // Jetpack Fuel
        var _screen_bottom = _gui_h - _spacing;
        
        _y += _screen_bottom;
        show_debug_message($"_screen_bottom {_screen_bottom} {_y}");
        draw_sprite_ext(spr_ui_jetpack, 0, _x, _y, _scale, _scale, 0, c_white, 1);
        var _jetpack_ratio = obj_player.jetpack_fuel / obj_player.jetpack_max_fuel;
        draw_set_color(c_aqua);
        draw_rectangle(_x+_icon_w, _y+_bar_center, _x+_icon_w+_bar_width * _jetpack_ratio, _y+_bar_center+_bar_height, false);
    
        // Super Attack Charge
        _y += _spacing;
        draw_sprite_ext(spr_ui_super_attack, 0, _x, _y, _scale, _scale, 0, c_white, 1);
        var _attack_ratio = obj_player.attack_fuel / obj_player.attack_fuel_max;
        
        // Draw charge time for Super Attack
        var _charge_time = ceil(_attack_ratio * 100);
        draw_set_font(font_stats_small);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        //draw_text_transformed_color(_x+_icon_w+5*_scale, _y+_bar_center, string(_charge_time) + " s", _scale, _scale, 0, c_white, c_white, c_white, c_white, 1);
        draw_text_color(_x+_icon_w+_scale, _y+_bar_center-2, string(_charge_time) + " s", c_white, c_white, c_white, c_white, 1);
    }
    
    surface_reset_target();
    
    // Draw the GUI surface
    draw_surface(gui_surface, 0, 0);
}
