/// @description Draw GUI event for obj_tooltip

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
    var box_y = gui_height/2 - total_height - 20;

    
    box_x = clamp(box_x, 0, gui_width - total_width);
    box_y = clamp(box_y, 0, gui_height - total_height);
    
    draw_set_color(c_black);
    draw_set_alpha(alpha * 0.7);
    draw_rectangle(box_x, box_y, box_x + total_width, box_y + total_height, false);
    
    draw_set_color(c_white);
    draw_set_alpha(alpha);
    draw_rectangle(box_x, box_y, box_x + total_width, box_y + total_height, true);
    
    if (sprite_exists(icon)) {
        draw_sprite(icon, 0, box_x + padding, box_y + (total_height - icon_height) / 2);
    }
    
    draw_text(box_x + icon_width + padding * 2, box_y + padding, text);
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}


