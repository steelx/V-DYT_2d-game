/// @description alarm 0
// runs after 1 seconds to stop health GUI animation
if instance_exists(obj_player) {
    obj_player.hp_gain_animation_active = false;
}
instance_destroy();
