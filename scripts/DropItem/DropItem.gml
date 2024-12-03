function DropItem(_inst_id, _x, _y, _type) constructor {
    inst_id = _inst_id;
    arc_path = new ArcPath();
    arc_path._inst = _inst_id;
    
    // Bounce properties
    bounce_count = 0;
    max_bounces = 2;
    bounce_force = 1;
    initial_height = 48;
    
    // Store current position
    current_x = _x;
    current_y = _y;
    
    // Generate initial arc
    var _angle = random_range(60, 120);
    var _distance = random_range(32, 64);
    var _end_x = _x + lengthdir_x(_distance, _angle);
    var _end_y = _y;
    
    arc_path.GenerateArc(_x, _y, _end_x, _end_y, initial_height);
    current_point = arc_path.GetCurrentPoint();
    
    static GenerateNewBounce = function() {
        // Use stored position if last point is undefined
        var _start_x = current_point ? current_point.x : current_x;
        var _start_y = current_point ? current_point.y : current_y;
        
        var _bounce_angle = random_range(45, 135);
        bounce_force *= 0.6; // Reduce force with each bounce
        
        arc_path.GenerateBounceArc(
            _start_x, 
            _start_y, 
            _bounce_angle, 
            bounce_force,
            initial_height
        );
        
        current_point = arc_path.GetCurrentPoint();
        
        // Update stored position
        if (current_point) {
            current_x = current_point.x;
            current_y = current_point.y;
        } else {
			
		}
    }
}
