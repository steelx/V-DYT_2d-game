/// @description Arrow movement and gravity Step event

vel_y += grav;

// Apply drag
vel_x *= drag;
vel_y *= drag;

// Move the arrow
x += vel_x;
y += vel_y;


// Rotate the arrow to match its trajectory
image_angle = point_direction(xprevious, yprevious, x, y);

