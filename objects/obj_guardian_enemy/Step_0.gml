/// @description obj_guardian_enemy Step event
check_animation();
if (!enabled) exit;
if (should_pause_object()) exit;    

bt_root.Process();

apply_horizontal_movement();
apply_verticle_movement();

if (!is_on_ground()) {
    vel_y += grav_speed;
}
