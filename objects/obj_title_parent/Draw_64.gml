/// @description obj_title Draw event
/// @description Draw GUI event for obj_tooltip
if alpha > 0 {
	if (!surface_exists(_surface)) {
	    _surface = surface_create(surface_width, surface_height);
	    _needs_redraw = true;
	}

	if (_needs_redraw) {
	    // Set the surface as the target
	    surface_set_target(_surface);
        
	    // Clear the surface
	    draw_clear_alpha(c_black, 0);
        
	    // Draw content on the surface
		draw_set_alpha(alpha);
	    draw_title(
            messages[current_message_index][0],
            0, "font_title"
        );
        
	    // Reset surface target
	    surface_reset_target();
        
	    _needs_redraw = false;
	}
}

// Draw the surface stretched to fit the GUI
var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();
draw_surface_stretched(_surface, 0, 0, _gui_width, _gui_height);

// Reset draw properties
draw_set_alpha(1);
draw_set_color(c_white);

