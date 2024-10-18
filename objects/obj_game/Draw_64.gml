/// @description 720x360

draw_set_font(font_stats);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

/*
// Gems
var _c = make_color_rgb(143, 222, 92);
draw_set_color(_c);

var _x = display_get_gui_width() - 48;
var _y = 32;

draw_sprite(s_gem_gui, 0, _x, _y);

var _text_x = -36;
var _text_y = 0.5;

draw_set_color(_c);
draw_text(_x+_text_x, _y+_text_y, o_player.gems_collected);

*/

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
