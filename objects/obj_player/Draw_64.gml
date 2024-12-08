/*
/// @description obj_player DRAW GUI
// GUI items for player stats
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _scale = 1; // Adjust this value to change the overall UI scale

var _x = 16 * _scale;
var _y = 0;
var _bar_width = 69 * _scale;
var _bar_height = 11 * _scale;
var _icon_w = 54 * _scale;
var _bar_center = 27 * _scale;
var _spacing = 72 * _scale;
    
// Health
draw_player_health(_gui_w, _gui_h, _x, _y, _scale);
    
#region stats
// Set the font for Scribble
scribble_font_set_default("font_stats");

// Jetpack Fuel
var _screen_bottom = _gui_h - _spacing*2;
_y += _screen_bottom;

var _jetpack_ratio = obj_player.jetpack_fuel / obj_player.jetpack_max_fuel;
if _jetpack_ratio == 1 {
	draw_text_scribble(_x, _y, "[scale,"+string(_scale)+"][c_yellow]Jetpack Fuel");
} else {
	draw_text_scribble(_x, _y, "[scale,"+string(_scale)+"][c_green]Jetpack Fuel");
}

draw_set_color(c_aqua);
draw_rectangle(_x, _y+_bar_center, _x+_bar_width * _jetpack_ratio, _y+_bar_center+_bar_height, false);

// Super Attack Charge
_y += _spacing;
var _attack_ratio = obj_player.attack_fuel / obj_player.attack_fuel_max;
if _attack_ratio == 1 {
	draw_text_scribble(_x, _y, "[scale,"+string(_scale)+"][rainbow]Super Attack (Ready)");
} else {
	draw_text_scribble(_x, _y, "[scale,"+string(_scale)+"][c_red]Super Attack");
	
	// Draw Super Attack charge with pixel animation
	var _pixel_size = 1 * _scale;
	var _bar_pixels_w = 60;
	var _bar_pixels_h = 10;
	var _total_pixels = _bar_pixels_w * _bar_pixels_h;
	var _filled_pixels = round(_attack_ratio * _total_pixels);

	for (var _i = 0; _i < _bar_pixels_w; _i++) {
	    for (var _j = 0; _j < _bar_pixels_h; _j++) {
	        var _pixel_index = _i + _j * _bar_pixels_w;
	        var _pixel_x = _x + _i * _pixel_size;
	        var _pixel_y = _y + _bar_center + _j * _pixel_size;
        
	        if (_pixel_index < _filled_pixels) {
	            draw_set_color(c_yellow);
	            draw_rectangle(_pixel_x, _pixel_y, _pixel_x + _pixel_size, _pixel_y + _pixel_size, false);
	        }
	    }
	}
}

#endregion

clear_text_color();
*/