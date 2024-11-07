// obj_pixel_filter Create Event
follow_target = noone;
transition_layer = layer_create(-999);
transition_filter = fx_create("_filter_pixelate");
layer_set_fx(transition_layer, transition_filter);
fx_set_parameter(transition_filter, "g_CellSize", 8);
image_xscale = 0;
image_yscale = 0;
