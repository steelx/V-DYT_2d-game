/// @description obj_guided_arrow Step event
if (path_following) {
    var _current_point = path.GetCurrentPoint();
    var _next_point = path.GetNextPoint();
    
    if (_next_point != noone) {
        // Calculate direction to next point
        var _dir = point_direction(x, y, _next_point.x, _next_point.y);
        image_angle = _dir;
        
        // Move towards next point
        var _spd = 8;  // Adjust speed as needed
        x += lengthdir_x(_spd, _dir);
        y += lengthdir_y(_spd, _dir);
        
        // Check if we should move to next point
        if (point_distance(x, y, _next_point.x, _next_point.y) < _spd) {
            if (!path.MoveNext()) {
                path_following = false;
            }
        }
    } else {
        path_following = false;
    }
} else {
    // Free-fall physics when path is complete
    vel_y += grav;
    x += vel_x;
    y += vel_y;
    image_angle = point_direction(x - vel_x, y - vel_y, x, y);
}

// Destroy if lifetime is up
lifetime--;
if (lifetime <= 0) instance_destroy();

// Collision with walls or targets
if (place_meeting(x, y, obj_collision)) {
    instance_destroy();
}

