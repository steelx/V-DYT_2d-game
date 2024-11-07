/// @description obj_blood_splash create
// pixelate filter blood splash fx
image_blend = c_red;
transition_layer = layer_create(-10000);
transition_filter = fx_create("_filter_pixelate");
layer_set_fx(transition_layer, transition_filter);
fx_set_parameter(transition_filter, "g_CellSize", 8);
alarm[0] = 30; // Stop the pixelate effect after 30 frames
