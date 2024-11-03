/// @description obj_title_parent Step
// Fade in/out
var _old_alpha = alpha;
var _fade_speed = 0.1;
alpha = lerp(alpha, 1, _fade_speed);

// Check if alpha changed significantly
if (abs(_old_alpha - alpha) > 0.01) {
    _needs_redraw = true;
}
