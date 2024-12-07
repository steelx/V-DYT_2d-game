/// @description obj_little_ninja Draw event
// Inherit the parent event
event_inherited();

// Draw grid path
if (bt_root != undefined) {
    bt_root.Draw(id);
}

//player_detected_debug();
