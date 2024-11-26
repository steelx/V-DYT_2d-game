/// @description obj_kutra Step event
if (variable_instance_exists(id, "enabled") and !enabled) exit;//used for attack seq spawner
if (should_pause_object()) exit;    

bt_root.Process();

apply_horizontal_movement();
apply_verticle_movement();

if (!is_on_ground()) {
    vel_y += grav_speed;
}
