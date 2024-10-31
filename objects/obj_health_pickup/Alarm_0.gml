/// @description hp gain
/// we use this so that obj_game can stop spr_hp_gain animation
if instance_exists(obj_player) {
    obj_player.hp_gain_animation_active = false;
    instance_destroy();
}
