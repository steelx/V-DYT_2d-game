/// @description obj_game Room state: persistent object
global.collision_tilemap = layer_tilemap_get_id("Collision_tiles");
global.tile_size = 16;
global.grav = 0.375;
global.game_paused = false;


// GUI
display_set_gui_size(GUI_WIDTH,GUI_HEIGHT);
