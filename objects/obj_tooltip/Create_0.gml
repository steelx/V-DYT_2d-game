/// @description obj_tooltip Create

text_el = undefined;

icon = -1;
alpha = 0;
target_alpha = 0;
fade_speed = 0.1;
padding = 10;
interaction_function = undefined; // Function to be called on interaction

// Initialize position
_init_x = 0;
_init_y = 0;

// Surface for tooltip
tooltip_surface = -1;
surface_width = window_get_width();  // Match viewport width
surface_height = window_get_height(); // Match viewport height
_viewport_scale_x = 1;
_viewport_scale_y = 1;

// Optimization variables
_last_cam_x = 0;
_last_cam_y = 0;
_needs_redraw = true;
_viewport_scale_x = surface_width / camera_get_view_width(view_camera[0]);
_viewport_scale_y = surface_height / camera_get_view_height(view_camera[0]);