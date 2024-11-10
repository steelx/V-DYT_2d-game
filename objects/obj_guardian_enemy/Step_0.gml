/// @description obj_guardian_enemy Step event
check_animation();
if (!enabled) exit;
if (should_pause_object()) exit;

// Before Process
show_debug_message("--- Frame Start ---");
show_debug_message("Can Attack: " + string(can_attack));
show_debug_message("Distance to Player: " + string(distance_to_object(obj_player)));
show_debug_message("Attack Range: " + string(attack_range));
    
bt_root.Process();
    
// After Process
var current_node = bt_root.black_board.running_node;
if (current_node != noone) {
    show_debug_message("Current Node: " + string(current_node.name));
    show_debug_message("Node Status: " + string(current_node.status));
}

apply_horizontal_movement();
apply_verticle_movement();

if (!is_on_ground()) {
    vel_y += grav_speed;
}
