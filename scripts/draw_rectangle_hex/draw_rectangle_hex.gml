/// @function draw_rectangle_hex(x1, y1, x2, y2, color, outline)
/// @param {real} _x1 The x coordinate of the left side of the rectangle.
/// @param {real} _y1 The y coordinate of the top side of the rectangle.
/// @param {real} _x2 The x coordinate of the right side of the rectangle.
/// @param {real} _y2 The y coordinate of the bottom side of the rectangle.
/// @param {string} _color The hex color code (e.g., "#FF0000" for red).
/// @param {bool} _outline Whether to draw only the outline (true) or fill the rectangle (false).
function draw_rectangle_hex(_x1, _y1, _x2, _y2, _color, _outline = false) {
    var _old_color = draw_get_color();
    
    // Convert hex to color
    var _col = hex_to_color(_color);
    
    // Set the color
    draw_set_color(_col);
    
    // Draw the rectangle
    draw_rectangle(_x1, _y1, _x2, _y2, _outline);
    
    // Reset the color
    draw_set_color(_old_color);
}

/// @function hex_to_color(hex)
/// @param {string} _hex The hex color code (e.g., "#FF0000" for red).
/// @returns {Constant.Color} The color value as a real number.
function hex_to_color(_hex) {
    // Remove the '#' if it's present
    if (string_char_at(_hex, 1) == "#") {
        _hex = string_delete(_hex, 1, 1);
    }
    
    // Extract RGB values
    var _r = hex_to_dec(string_copy(_hex, 1, 2));
    var _g = hex_to_dec(string_copy(_hex, 3, 2));
    var _b = hex_to_dec(string_copy(_hex, 5, 2));
    
    return make_color_rgb(_r, _g, _b);
}

/// @function hex_to_dec(hex)
/// @param {string} _hex A two-character hex string.
/// @returns {real} The decimal value of the hex string.
function hex_to_dec(_hex) {
    var _digits = "0123456789ABCDEF";
    var _dec = 0;
    
    for (var _i = 1; _i <= 2; _i++) {
        var _char = string_upper(string_char_at(_hex, _i));
        _dec = _dec * 16 + string_pos(_char, _digits) - 1;
    }
    
    return _dec;
}

