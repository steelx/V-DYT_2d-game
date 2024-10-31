/// @description Draw GUI event for obj_tooltip
if (alpha > 0) {
    if (!surface_exists(tooltip_surface)) {
        tooltip_surface = surface_create(surface_width, surface_height);
        _needs_redraw = true;
    }

    if (_needs_redraw) {
        // Set the surface as the target
        surface_set_target(tooltip_surface);
        
        // Clear the surface
        draw_clear_alpha(c_black, 0);
        
        // Draw tooltip content on the surface
        var _max_width = 74 * _viewport_scale_x; // Scale max width
        
        draw_set_alpha(alpha);
        draw_textbox(x, y, _max_width, message, COL_CREAM_WHITE, COL_CREAM_RED);
        
        // Reset surface target
        surface_reset_target();
        
        _needs_redraw = false;
    }

    // Draw the surface stretched to fit the GUI
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    draw_surface_stretched(tooltip_surface, 0, 0, _gui_width, _gui_height);
}

// Reset draw properties
draw_set_alpha(1);
draw_set_color(c_white);

