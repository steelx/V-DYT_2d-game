/// @description obj_title Create
surface_width = window_get_width();  // Match viewport width
surface_height = window_get_height(); // Match viewport height
alpha = 0;

title_message = "[wave] Made by Ajinkya";
typist = scribble_typist();
typist.in(1, 0);

// Optimization variables
_needs_redraw = false;
_surface = undefined;
