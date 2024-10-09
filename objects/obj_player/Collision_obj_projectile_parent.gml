/// @description obj_player Collision with obj_projectile

// Check if the player is invincible
if (no_hurt_frames > 0)
{
    exit;
}

// Damage the player
hp -= other.damage;

// Apply knockback
state = CHARACTER_STATE.KNOCKBACK;
var _x_sign = sign(x - other.x);
vel_x = _x_sign * 10; // Adjust knockback strength as needed

// Set invincibility frames
no_hurt_frames = get_room_speed() * 1; // 1 second of invincibility

// Change sprite to hurt sprite
sprite_index = spr_player_hurt;
image_index = 0;

// Set Alarm 0 to run after 15 frames to end knockback
alarm[0] = 15;

// Add screen shake if player is still alive
if (hp > 0) add_screenshake(0.2);

// Play hurt sound
audio_play_sound(snd_life_lost_01, 0, 0);

// Destroy the projectile
instance_destroy(other);
