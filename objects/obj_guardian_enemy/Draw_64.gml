/// @description Insert description here
// You can write your code in this editor


gui_surface = draw_to_surface(
    gui_surface,
    surface_width,
    surface_height,
	x,
    y-sprite_height,
    function(_x, _y) {
        bt_root.DrawGUI(_x, _y);
    }
);
