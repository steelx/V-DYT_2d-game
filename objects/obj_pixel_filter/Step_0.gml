// obj_pixel_filter Step Event
if (follow_target != noone and instance_exists(follow_target)) {
    x = follow_target.x;
    y = follow_target.y;
    image_xscale = follow_target.image_xscale;
    image_yscale = follow_target.image_yscale;
} else {
    instance_destroy();
}
