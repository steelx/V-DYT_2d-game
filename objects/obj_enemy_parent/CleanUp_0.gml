/// @description obj_enemy_parent cleanup event
if (ds_exists(search_path_points, ds_type_list)) {
    ds_list_destroy(search_path_points);
}
