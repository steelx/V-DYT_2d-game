/// @description SLIME_ROAM
// upon alarm slime will change state to MOVE
// alarm starts again from animation end

slime_jump_move();
vel_y = -jump_speed;
sprite_index = spr_slime_hop;
image_speed = 1;
