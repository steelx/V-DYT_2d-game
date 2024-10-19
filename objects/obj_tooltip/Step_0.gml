/// @description Insert description here
// Fade in/out
alpha = lerp(alpha, target_alpha, fade_speed);

// Destroy if fully faded out
if (alpha < 0.01 && target_alpha == 0) {
    instance_destroy();
}

