/// @description obj_player_superattack_hitbox collision with obj_enemy_parent

// Reduce enemy's HP
other.hp--;

// Apply knockback to the enemy
var _knockback_speed = 4; // Adjust this value as needed
var _knockback_direction = point_direction(x, y, other.x, other.y);
var _knockback_x = lengthdir_x(_knockback_speed, _knockback_direction);
var _knockback_y = lengthdir_y(_knockback_speed, _knockback_direction);

// Apply knockback
other.vel_x = _knockback_x;
//other.vel_y = _knockback_y; // NO verticle knockback

// Set the enemy to a knockback state
other.state = CHARACTER_STATE.KNOCKBACK;

// Start enemy blinking
other.no_hurt_frames = 30; // Blink for 30 frames (adjust as needed)

// Play hit sound (if you have one)
audio_play_sound(snd_enemy_hit, 1, false);
