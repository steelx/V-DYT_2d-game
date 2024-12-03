/// @description obj_game Room start: persistent object
global.collision_tilemap = layer_tilemap_get_id("Collision_tiles");
global.tile_size = 16;
global.grav = 0.375;

global.collision_grid = new CollisionGrid();
global.collision_grid.Initialize();

// ensure obj_drop_manager gets created in each room start after grid
if (!instance_exists(obj_drop_manager)) {
    instance_create_layer(0, 0, "Instances", obj_drop_manager);
}

resume_game();

// GUI
display_set_gui_size(window_get_width(),window_get_height());
scribble_font_set_default("fnt_dialog");
scribble_font_set_default("font_tooltip");
