/// @description obj_game Draw GUI
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

        // Draw menu options
        draw_set_font(menu_font);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        var _center_x = _surf_w / 2;
        var _center_y = _surf_h / 2;
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

    // Draw the surface
    draw_surface(menu_surface, 0, 0);
} else {
    draw_set_font(font_stats);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    
    // Health
    var _x = 16;
    var _y = 16;
    
    if instance_exists(obj_player) {
    
        //draw_sprite_ext(s_hp_bar, 2, _x, _y, obj_player.hp/obj_player.max_hp, 1, 0, c_white, image_alpha);
        //draw_sprite(s_hp_bar, 0, _x, _y);
        //draw_rectangle_hex(_x, _y, _x+64, _y+24, "#5d7680", false);
        
        // Health Bar
        draw_set_color(c_black);
        draw_text(_x, _y-6, $"Health");
        
        var _bar_x = _x;
        var _bar_y = _y;
        var _bar_width = 52;
        var _bar_height = 4;
        
        draw_health_bar(
            _bar_x, _bar_y, _bar_width, _bar_height,
            obj_player.hp, obj_player.max_hp,
            "#FFFFFF", "#8c9438", "#e01f3f"
            // White    Green      Red
        );
        
        draw_set_font(font_stats_small);
        
        // Jetpack Fuel
        _x = 16;
        _y = display_get_gui_height();
        draw_set_color(make_color_rgb(143, 151, 49));
        draw_text(_x, _y-22, $"Jetpack");
        
        _bar_x = _x;
        _bar_y = _y-16;
        _bar_width = 48;
        _bar_height = 4;
        
        draw_health_bar(
            _bar_x, _bar_y, _bar_width, _bar_height,
            obj_player.jetpack_fuel, obj_player.jetpack_max_fuel,
            "#FFFFFF", "#202c18", "#e01f3f"
        );
        
        // Supper Attack Fuel
        _x = 72;
        _y = display_get_gui_height();
        draw_set_color(make_color_rgb(143, 151, 49));
        draw_text(_x, _y-22, $"Super Attack");
        
        _bar_x = _x;
        _bar_y = _y-16;
        _bar_width = 48;
        _bar_height = 4;
        
        draw_health_bar(
            _bar_x, _bar_y, _bar_width, _bar_height,
            obj_player.attack_fuel, obj_player.attack_fuel_max,
            "#FFFFFF", "#202c18", "#e01f3f"
        );
        
    }
}
