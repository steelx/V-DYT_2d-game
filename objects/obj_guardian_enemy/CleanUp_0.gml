/// @description cleanup upon destroy from end step
if (bt_root != undefined and variable_struct_exists(bt_root, "Clean")) {
    bt_root.Clean();
}
