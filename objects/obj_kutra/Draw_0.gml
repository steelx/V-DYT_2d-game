/// @description obj_little_ninja Draw event
// Inherit the parent event
event_inherited();

if (bt_root != undefined) {
    bt_root.Draw(id);
}

draw_visibility_ray(visible_range, attack_range);
