/// @description obj_game Clean Up Event

if (surface_exists(menu_surface)) {
    surface_free(menu_surface);
}

if (variable_global_exists("collision_grid")) {
    global.collision_grid.Cleanup();
}

if (surface_exists(transition_surface)) {
    surface_free(transition_surface);
}
