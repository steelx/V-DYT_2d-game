/// @function draw_ui_bar(title, width, current_value, fg_color, bg_color, subtitle)
/// @param {string} title       The title to display
/// @param {real} width        Width of the bar
/// @param {real} current_value Value between 0 and 1
/// @param {color} fg_color    Foreground color
/// @param {color} bg_color    Background color
/// @param {string} subtitle    Optional subtitle
function draw_ui_bar(_title, _x, _y, _width, _height = 12, _current_value, _fg_color, _bg_color, _subtitle = noone) {
    var _title_spacing = 100; // Spacing between title and bar
    var _start_x = _x;
    var _start_y = _y;
    
    // Clamp the value between 0 and 1
    _current_value = clamp(_current_value, 0, 1);
    
    // Draw title
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
	scribble_font_set_default("font_stats");
    draw_text_scribble(_start_x, _start_y + _height/2, _title);
    
    // Position bar after title
    _start_x += _title_spacing;
    
    // Draw background (darker portion)
    draw_set_color(_bg_color);
    draw_rectangle(_start_x, _start_y, _start_x + _width, _start_y + _height, false);
    
    // Draw foreground (progress)
    draw_set_color(_fg_color);
    draw_rectangle(_start_x, _start_y, 
                  _start_x + (_width * _current_value), 
                  _start_y + _height, false);
    
    // Draw subtitle if provided
    if (_subtitle != noone) {
        draw_set_halign(fa_left);
		scribble_font_set_default("font_stats_small");
        draw_text_scribble(_start_x + _width + 10, _start_y + _height/2, _subtitle);
    }
    
    // Reset draw settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}