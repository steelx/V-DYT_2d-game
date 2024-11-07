/// @description obj_player_attack_hitbox collision with obj_enemy_parent

// Parameters to adjust the blood splash
create_blood_splash();

// Create the pixel filter effect on the enemy
/*
var _pixel_filter = instance_create_layer(other.x, other.y, "Enemies", obj_pixel_filter);
_pixel_filter.follow_target = other;
*/
// Reduce enemy's HP
other.hp--;

// Apply knockback to the enemy
var _knockback_speed = 1; // Adjust this value as needed
var _knockback_direction = sign(other.x - x);
other.vel_x = lengthdir_x(_knockback_speed, _knockback_direction);
other.vel_y = 0;

// Set the enemy to a knockback state
other.state = CHARACTER_STATE.KNOCKBACK;

// Start enemy blinking
other.no_hurt_frames = 60; // Blink for 30 frames (adjust as needed)
audio_play_sound(snd_enemy_hit, 1, false);

