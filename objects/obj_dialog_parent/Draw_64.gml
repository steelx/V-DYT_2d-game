
/// @description obj_dialog_parent Draw GUI Event
if (dialog_active && current_dialog != noone) {
    if (!surface_exists(dialog_surface)) {
        dialog_surface = surface_create(surface_width, surface_height);
        _needs_redraw = true;
    }

    if (_needs_redraw) {
        surface_set_target(dialog_surface);
        draw_clear_alpha(c_black, 0);

        var _dialog_width = 300 * (surface_width / display_get_gui_width());
        var _dialog_height = 75 * (surface_height / display_get_gui_height());
        var _dialog_x = (surface_width - _dialog_width) / 2;
        var _dialog_y = surface_height - (_dialog_height + 20 * (surface_height / display_get_gui_height()));

        dialog_system.draw(_dialog_x, _dialog_y, _dialog_width, _dialog_height, current_dialog);

        surface_reset_target();
        _needs_redraw = false;
    }

    // Draw the surface stretched to fit the GUI
    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    draw_surface_stretched(dialog_surface, 0, 0, _gui_width, _gui_height);
}
