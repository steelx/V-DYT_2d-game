/// @description Draw Event of obj_pickup_sword
if (can_pickup) {
    // Yellow highlight when player is in range
    highlight_sprite(
        sprite_index,
        x,
        y,
        image_index,
        [0.0, 0.0, 1.0],
		0.55
    );
} else {
    draw_self();
}
