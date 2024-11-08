/// @function draw_health_bar(x, y, width, height, current_hp, max_hp, border_color, fill_color, background_color)
/// @param {real} _x The x coordinate of the left side of the health bar.
/// @param {real} _y The y coordinate of the top side of the health bar.
/// @param {real} _width The full width of the health bar.
/// @param {real} _height The height of the health bar.
/// @param {real} _current_hp The current HP of the player.
/// @param {real} _max_hp The maximum HP of the player.
/// @param {string} _border_color The hex color code for the border.
/// @param {string} _fill_color The hex color code for the filled part of the health bar.
/// @param {string} _background_color The hex color code for the empty part of the health bar.
function draw_health_bar(_x, _y, _width, _height, _current_hp, _max_hp, _border_color, _fill_color, _background_color) {
    var _old_color = draw_get_color();
    
    // Calculate the width of the filled portion
    var _fill_width = (_current_hp / _max_hp) * _width;
    
    // Draw the background (empty part of the health bar)
    draw_rectangle_hex(_x, _y, _x + _width, _y + _height, _background_color, false);
    
    // Draw the filled part of the health bar
    draw_rectangle_hex(_x, _y, _x + _fill_width, _y + _height, _fill_color, false);
    
    // Draw the border
    draw_rectangle_hex(_x, _y, _x + _width, _y + _height, _border_color, true);
    
    // Reset the color
    draw_set_color(_old_color);
}
