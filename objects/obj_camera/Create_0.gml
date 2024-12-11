/// @description obj_camera Create, added in rm_init
var _viewport_camera_index = 0;
_base_w = camera_get_view_width(view_camera[_viewport_camera_index]);
_base_h = camera_get_view_height(view_camera[_viewport_camera_index]);

// follow (we will be following o_player, but once we init Room with player is loaded)
follow = noone;
move_to_x = x;
move_to_y = y;
// zoom_level = 1 Normal view, zoom_level > 1 zoom in, zoom_level < 1 Zoom out
zoom_level = 1;

// asymmetric following
vertical_offset_ratio = 0.8; // 70% above, 30% below
vertical_border_top = _base_h * vertical_offset_ratio;    // More space above
vertical_border_bottom = _base_h * (1 - vertical_offset_ratio); // Less space below

// Camera Ratio feel
vertical_offset_normal = _base_h * 0.3;     // Default 70:30 (more space above) Higher = more extreme top view
vertical_offset_reverse = _base_h * -0.2;    // Reverse 30:70 (more space below) Higher = more extreme bottom view
vertical_offset_transition_speed = 0.1;      // Higher = faster transition

current_vertical_offset = vertical_offset_normal;


// Set camera with asymmetric borders
var _x_speed = 5;
var _y_speed = 5;
camera = camera_create_view(
    0, 0,                    // x, y position
    _base_w, _base_h,       // width, height
    0,                      // angle
    -1,                     // target following (we'll handle this manually)
    _x_speed, _y_speed,     // speed
    vertical_border_top,    // horizontal border
    vertical_border_bottom  // vertical border
);

view_set_camera(_viewport_camera_index, camera);

// Configure the window view
view_set_wport(0, 1920);
view_set_hport(0, 1080);

// Set up surface/gui scaling
display_set_gui_size(1920, 1080);
window_set_size(1920, 1080);
surface_resize(application_surface, 1920, 1080);


// Zoom motion FX
zoom_motion_active = false;
zoom_motion_target = 1.5;// Lower = more zoomed out
zoom_motion_speed = 0.1;// Higher = faster zoom
zoom_motion_duration = 0;
zoom_motion_timer = 0;
maintain_zoom = false;
maintain_zoom_level = 1;

camera_pan_speed_initial = 0.15;
camera_pan_speed = 1.6;

// Screen shake variables
screen_shake = false;
screen_shake_amount_initial = 2;
screen_shake_amount = screen_shake_amount_initial;
screen_shake_direction = 1; // Used for controlling shake direction
screen_shake_decay = 0.2; // How quickly the shake effect decreases
screen_shake_vertical_bias = 0.8; // Makes the shake more vertical (0-1)

// reset camera to default pan speed CAMERA_RESET_PAN 0
alarm_set(CAMERA_RESET_PAN, 3);

// Player jetpack
jetpack_zoom_out = 1.2; // How much to zoom out during jetpack
jetpack_zoom_speed = 0.05; // How fast to transition zoom


function background_parallax_scrolling(_camera) {
    var _layer_id = layer_get_id("Background");
    layer_x(_layer_id, lerp(0, camera_get_view_x(_camera), 0.7));
    layer_y(_layer_id, lerp(0, camera_get_view_y(_camera), 0.4));
}