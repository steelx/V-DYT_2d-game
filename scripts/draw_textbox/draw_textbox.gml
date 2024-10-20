/// @function draw_textbox(x, y, max_width, text, sprite, bg_color, border_color)
/// @param {Real} _x The x coordinate of the bottom-left corner of the textbox
/// @param {Real} _y The y coordinate of the bottom-left corner of the textbox
/// @param {Real} _max_width The maximum width of the textbox
/// @param {String} _text The text to display in the textbox
/// @param {Asset.GMSprite} _sprite The sprite to display (or -1 for no sprite)
/// @param {String} _bg_color The background color in hex format
/// @param {String} _border_color The border color in hex format
function draw_textbox(_x, _y, _max_width, _text, _sprite, _bg_color, _border_color) {
    var _padding = 4;
    var _line_height = 12; // Adjust this value based on your font size
    var _sprite_width = sprite_exists(_sprite) ? sprite_get_width(_sprite) : 0;
    var _sprite_height = sprite_exists(_sprite) ? sprite_get_height(_sprite) : 0;
    
    draw_set_font(font_tooltip);
    
    // Calculate text dimensions
    var _text_width = string_width_ext(_text, _line_height, _max_width - _sprite_width - _padding * 3);
    var _text_height = string_height_ext(_text, _line_height, _max_width - _sprite_width - _padding * 3);
    
    // Calculate total dimensions
    var _total_width = min(_max_width, _text_width + _sprite_width + _padding * 3);
    var _total_height = max(_text_height + _padding * 2, _sprite_height + _padding * 2);
    
    // Adjust y coordinate to expand upwards
    var _box_y = _y - _total_height;
    
    // Draw background
    draw_rectangle_hex(_x, _box_y, _x + _total_width, _y, _bg_color);
    
    // Draw border
    draw_rectangle_hex(_x, _box_y, _x + _total_width, _y, _border_color, true);
    
    // Draw sprite
    if (sprite_exists(_sprite)) {
        draw_sprite(_sprite, 0, _x + _padding, _box_y + (_total_height - _sprite_height) / 2);
    }
    
    // Draw text
    draw_set_color(hex_to_color(COL_LIGHT_CREAM));
    draw_set_valign(fa_middle);
    draw_set_halign(fa_left);
    draw_text_ext(
        _x + _sprite_width + _padding * 2, 
        _box_y + _total_height / 2, 
        _text, 
        _line_height, 
        _total_width - _sprite_width - _padding * 3
    );
    
    // Reset draw properties
    draw_set_color(c_white);
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
}


