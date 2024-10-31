/// @function draw_textbox(x, y, max_width, text, sprite, bg_color, border_color)
/// It uses Scribble's get_box method to calculate the text dimensions, which includes padding,
/// The background and border are now drawn based on the dimensions returned by get_box.
/// @param {Real} _x The x coordinate of the bottom-left corner of the textbox
/// @param {Real} _y The y coordinate of the bottom-left corner of the textbox
/// @param {Real} _max_width The maximum width of the textbox
/// @param {String} _text The text to display in the textbox
/// @param {String} _bg_color The background color in hex format
/// @param {String} _border_color The border color in hex format
function draw_textbox(_x, _y, _max_width, _text, _bg_color, _border_color) {
    var _padding = 5;

    // Create Scribble text element
    var _text_el = scribble(_text, id)
		.starting_format("font_tooltip", c_black)
        .wrap(_max_width - _padding * 2);
    
    // Get box dimensions
    var _text_box = _text_el.get_bbox();
    
    // Calculate total dimensions
    var _total_width = _text_box.width + _padding * 2;
    var _total_height = _text_box.height + _padding * 2;
    
    // Adjust y coordinate to expand upwards
    var _box_y = _y - _total_height;
    
    // Draw background
    draw_rectangle_hex(_x, _box_y, _x + _total_width, _y, _bg_color);
    
    // Draw border
    draw_rectangle_hex(_x, _box_y, _x + _total_width, _y, _border_color, true);

    // Draw text using Scribble
    _text_el
        .align(fa_left, fa_top)
        .draw(_x + _padding, _box_y + _padding);
}
