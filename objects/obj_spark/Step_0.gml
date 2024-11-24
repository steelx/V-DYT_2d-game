/// @description obj_spark Step
// Calculate spiral movement
spiral_angle += spiral_speed;
spiral_radius *= radius_decay;

// Calculate new position
var _center_x = x;
var _center_y = y;

// Move upward
y += vertical_speed;

// Add spiral motion around the vertical path
x = _center_x + lengthdir_x(spiral_radius, spiral_angle);
y += lengthdir_y(spiral_radius * spiral_tightness, spiral_angle);

// Decay effects
vertical_speed *= 0.98;  // Gradually slow the upward movement
alpha -= fade_speed;

// Update trail
ds_list_delete(trail_positions, 0);
ds_list_add(trail_positions, [x, y]);

// Destroy when effect is done
if (alpha <= 0) instance_destroy();
