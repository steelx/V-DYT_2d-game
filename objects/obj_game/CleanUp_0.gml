/// @description obj_game Clean Up Event

if (surface_exists(menu_surface)) {
    surface_free(menu_surface);
}

if (global.collision_grid != undefined) {
    global.collision_grid.Cleanup();
}
