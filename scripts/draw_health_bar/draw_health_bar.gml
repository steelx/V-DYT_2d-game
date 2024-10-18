/// @function draw_health_bar(x, y, width, height, current_hp, max_hp, border_color, fill_color, background_color)
/// @param {real} x The x coordinate of the left side of the health bar.
/// @param {real} y The y coordinate of the top side of the health bar.
/// @param {real} width The full width of the health bar.
/// @param {real} height The height of the health bar.
/// @param {real} current_hp The current HP of the player.
/// @param {real} max_hp The maximum HP of the player.
/// @param {string} border_color The hex color code for the border.
/// @param {string} fill_color The hex color code for the filled part of the health bar.
/// @param {string} background_color The hex color code for the empty part of the health bar.
function draw_health_bar(x, y, width, height, current_hp, max_hp, border_color, fill_color, background_color) {
    var old_color = draw_get_color();
    
    // Calculate the width of the filled portion
    var fill_width = (current_hp / max_hp) * width;
    
    // Draw the background (empty part of the health bar)
    draw_rectangle_hex(x, y, x + width, y + height, background_color, false);
    
    // Draw the filled part of the health bar
    draw_rectangle_hex(x, y, x + fill_width, y + height, fill_color, false);
    
    // Draw the border
    draw_rectangle_hex(x, y, x + width, y + height, border_color, true);
    
    // Reset the color
    draw_set_color(old_color);
}
