/// @description Draw Event: grid
/*
if (global.collision_grid != undefined) {
    global.collision_grid.DrawDebug();
}
*/

/// Room Transition
if (transition_active) {
    if (!surface_exists(transition_surface)) {
        transition_surface = surface_create(display_get_gui_width(), display_get_gui_height());
    }
    
    draw_diamond_transition();
    draw_surface(transition_surface, 0, 0);
}
