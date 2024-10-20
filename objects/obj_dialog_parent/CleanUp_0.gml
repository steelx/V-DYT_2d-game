/// @description obj_dialog_parent Clean Up event
if (surface_exists(dialog_surface)) {
    surface_free(dialog_surface);
}
