/// @description obj_spark Create
// Base movement (now mainly upward)
base_speed = random_range(3, 5);
vertical_speed = -base_speed * 1.2;  // Negative for upward movement
lifetime = 1;
alpha = 1;
fade_speed = 0.04;

// Spiral motion controls
spiral_radius = random_range(3, 6);     // Width of the spiral
spiral_angle = random(360);             // Starting angle
spiral_speed = random_range(8, 12);     // How fast it rotates around center
spiral_tightness = random_range(0.2, 0.6); // How tight the spiral is (smaller = tighter)
radius_decay = 0.97;                    // How quickly spiral narrows

// Trail system
trail_length = 20;  // Increased for longer trails
trail_positions = ds_list_create();
for(var i = 0; i < trail_length; i++) {
    ds_list_add(trail_positions, [x, y]);
}

// Colors (will be set by spawner)
col_head = c_white;
col_tail = c_white;

// Optional: Add slight randomness to starting position
x += random_range(-5, 5);
y += random_range(-5, 5);

