/**
* Resets the drawing settings to default values.
* Sets the alpha to 1 (fully opaque) and color to white.
*/
function draw_reset() {
    draw_set_alpha(1);
    draw_set_color(c_white);
}

/**
* @function draw_set Sets the drawing color and alpha in a single function call.
* @param {color} _colour - The color to set for drawing.
* @param {real} _alpha - The alpha value to set (0 to 1, where 0 is fully transparent and 1 is fully opaque).
*/
function draw_set(_colour, _alpha) {
    draw_set_color(_colour);
    draw_set_alpha(_alpha);
}

/**
* Sets the horizontal and vertical alignment for text drawing.
* @param {Constant.HAlign} _h_align - The horizontal alignment (e.g., fa_left, fa_center, fa_right).
* @param {Constant.VAlign} _v_align - The vertical alignment (e.g., fa_top, fa_middle, fa_bottom).
*/
function draw_set_align(_h_align, _v_align) {
    draw_set_halign(_h_align);
    draw_set_valign(_v_align);
}

/**
* Draws a dialog box with picture and text, similar to Deltarune.
* @param {real} _x - The x-coordinate of the bottom-left corner of the dialog box.
* @param {real} _y - The y-coordinate of the bottom-left corner of the dialog box.
* @param {real} _width - The width of the dialog box.
* @param {real} _height - The height of the dialog box.
* @param {sprite} _picture - The sprite to display as the character picture.
* @param {string} _text - The text to display in the dialog box.
*/
function draw_dialog_box(_x, _y, _width, _height, _picture, _text) {
    // Save current draw settings
    var _old_color = draw_get_color();
    var _old_font = draw_get_font();
    var _old_halign = draw_get_halign();
    var _old_valign = draw_get_valign();
    
    // Draw the dialog box background
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_x, _y - _height, _x + _width, _y, false);
    
    // Draw the border
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_rectangle(_x, _y - _height, _x + _width, _y, true);
    
    // Draw the character picture
    var _picture_scale = 2; // Adjust this value to change the size of the picture
    var _picture_x = _x + 20;
    var _picture_y = _y - _height + 20;
    draw_sprite_ext(_picture, 0, _picture_x, _picture_y, _picture_scale, _picture_scale, 0, c_white, 1);
    
    // Draw the text
    draw_set_font(font_dialog); // Make sure you have a dialog font created
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _text_x = _picture_x + sprite_get_width(_picture) * _picture_scale + 20;
    var _text_y = _y - _height + 20;
    var _text_width = _width - (_text_x - _x) - 20;
    draw_text_ext(_text_x, _text_y, _text, 20, _text_width);
    
    // Restore previous draw settings
    draw_set_color(_old_color);
    draw_set_font(_old_font);
    draw_set_halign(_old_halign);
    draw_set_valign(_old_valign);
    draw_set_alpha(1);
}

