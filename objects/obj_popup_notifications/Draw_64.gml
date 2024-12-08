/// @description Draw popup notification
if (alpha > 0) {
    if (!surface_exists(_surface)) {
        _surface = surface_create(surface_width, surface_height);
        _needs_redraw = true;
    }
    
    if (_needs_redraw) {
        surface_set_target(_surface);
        draw_clear_alpha(c_black, 0);
        
        draw_set_alpha(alpha);
        
        var _current_message = messages[current_message_index][0];
        var _scrib = scribble(_current_message)
            .starting_format("font_title", c_white)
            .align(fa_center, fa_bottom);
            
        _scrib.draw(surface_width/2, y_position);
        
        surface_reset_target();
        _needs_redraw = false;
    }
    
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    draw_surface_stretched(_surface, 0, 0, _gui_width, _gui_height);
}

// Reset draw properties
draw_set_alpha(1);
draw_set_color(c_white);
