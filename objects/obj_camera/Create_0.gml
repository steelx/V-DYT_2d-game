/// @description obj_camera Create, added in rm_init
var _viewport_camera_index = 0;
_base_w = camera_get_view_width(view_camera[_viewport_camera_index]);
_base_h = camera_get_view_height(view_camera[_viewport_camera_index]);

var _x_speed = 5;
var _y_speed = 5;
var _border = 128;
camera = camera_create_view(0, 0, _base_w, _base_h, 0, -1, _x_speed, _y_speed, _border, _border);
view_set_camera(_viewport_camera_index, camera);


// follow (we will be following o_player, but once we init Room with player is loaded)
follow = noone;
move_to_x = x;
move_to_y = y;
// zoom_level = 1 Normal view, zoom_level > 1 zoom in, zoom_level < 1 Zoom out
zoom_level = 1;

camera_pan_speed_initial = 0.15;
camera_pan_speed = 1.6;

screen_shake = false;
screen_shake_amount_initial = 2;
screen_shake_amount = screen_shake_amount_initial;

// reset camera to default pan speed CAMERA_RESET_PAN 0
alarm_set(CAMERA_RESET_PAN, 3);


function background_parallax_scrolling(_camera) {
    var _layer_id = layer_get_id("Background");
    layer_x(_layer_id, lerp(0, camera_get_view_x(_camera), 0.7));
    layer_y(_layer_id, lerp(0, camera_get_view_y(_camera), 0.4));
}