/// @description obj_enemy_highlight Step Event
if (target != noone and instance_exists(target)) {
    x = target.x;
    y = target.y;
    image_xscale = target.image_xscale + 0.1; // Increase the scale slightly
    image_yscale = target.image_yscale + 0.4;
} else {
    instance_destroy();
}

