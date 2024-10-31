/// @description obj_health_picked_up create
// we set GUI health animation to start and end after alarm ends.
if instance_exists(obj_player) {
    obj_player.hp_gain_animation_active = true;
}
