/// @description Insert description here
if (alpha > 0) {
    draw_set_alpha(alpha);
    
    var text_width = string_width(text);
    var text_height = string_height(text);
    var icon_width = sprite_exists(icon) ? sprite_get_width(icon) : 0;
    var icon_height = sprite_exists(icon) ? sprite_get_height(icon) : 0;
    
    var total_width = text_width + icon_width + padding * 3;
    var total_height = max(text_height, icon_height) + padding * 2;
    
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    
    var box_x = (gui_width - total_width) / 2;
    var box_y = gui_height - total_height - padding - 100;
    
    // Draw background
    draw_set_color(c_black);
    draw_set_alpha(alpha * 0.7);
    draw_rectangle(box_x, box_y, box_x + total_width, box_y + total_height, false);
    
    // Draw border
    draw_set_color(c_lime);
    draw_set_alpha(alpha);
    draw_rectangle(box_x, box_y, box_x + total_width, box_y + total_height, true);
    
    // Draw icon
    if (sprite_exists(icon)) {
        draw_sprite(icon, 0, box_x + padding, box_y + (total_height - icon_height) / 2);
    }
    
    // Draw text
    draw_set_color(c_white);
    draw_set_alpha(alpha);
    draw_text(box_x + icon_width + padding * 2, box_y + padding, text);
    
    // Reset drawing properties
    draw_set_alpha(1);
    draw_set_color(c_white);
}

