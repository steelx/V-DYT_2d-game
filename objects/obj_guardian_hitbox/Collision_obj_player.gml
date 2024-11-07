/// @description collision with obj_player

var _x = x, _y = y;
// Check if the colliding instance is obj_player
with (other) {
	// Check if the player is invincible
	if (no_hurt_frames > 0) {
		exit;
	}
	// inside WITH 'other' refers to hitbox
	hp -= other.damage;
    if (hp > 0) {
		// player hurt fx
		create_pixelated_blood_fx();
		apply_zoom_motion_fx(1.2);
	}
		
	// Change sprite to hurt sprite
	sprite_index = spr_player_hurt;
	image_index = 0;
	// Set invincibility frames
	no_hurt_frames = get_room_speed() * 2; // 2 second of invincibility
	// Set Alarm 0 to run after 30 frames to end knockback
	alarm_set(KNOCKED_BACK, 30);
	audio_play_sound(snd_life_lost_01, 0, 0);
	
	// Apply knockback
	var knockback_direction = point_direction(_x, _y, x, y);
	var knockback_speed = 5;
	var kx = lengthdir_x(knockback_speed, knockback_direction);
	// Check for collisions before applying knockback
	if (!place_meeting(x + kx, y, obj_collision)) {
	    x += kx;
	}
}
