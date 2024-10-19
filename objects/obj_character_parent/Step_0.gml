/// @description obj_character_parent step event

if (state == CHARACTER_STATE.PAUSED) {
    // Do nothing while paused
    exit;
}

// Handle invincibility frames
if (no_hurt_frames > 0) {
    no_hurt_frames--;
}
