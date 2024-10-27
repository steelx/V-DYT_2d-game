/// @description obj_game Room state: persistent object
global.collision_tilemap = layer_tilemap_get_id("Collision_tiles");
global.tile_size = 16;
global.grav = 0.375;


// GUI
display_set_gui_size(window_get_width(),window_get_height());
