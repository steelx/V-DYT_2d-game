/// @description obj_drop_manager Step_Event
// Only process drops that still exist
for (var i = 0; i < array_length(drops); i++) {
    var _drop = drops[i];
    with(_drop.inst_id) {
        // If we have a current point in the arc path
        if (drop_item.current_point != undefined) {
            x = drop_item.current_point.x;
            y = drop_item.current_point.y;
            
            // Move to next point
            if (!drop_item.arc_path.MoveNext()) {
                // Generate new bounce if possible
                if (drop_item.bounce_count < drop_item.max_bounces) {
                    drop_item.bounce_count++;
                    drop_item.GenerateNewBounce();
                } else {
                    // Start falling when bounces are done
                    drop_item.current_point = undefined;
                    drop_item.falling = true;
                    drop_item.fall_speed = 0;
                }
            } else {
                drop_item.current_point = drop_item.arc_path.GetCurrentPoint();
                if (drop_item.current_point == undefined) {
                    // If we run out of points, start falling
                    drop_item.falling = true;
                    drop_item.fall_speed = 0;
                }
            }
        } else if (!drop_item.can_pickup) { // Only fall if not yet pickupable
            // Apply gravity-based falling
            drop_item.fall_speed += 0.5; // Gravity
            var _move_y = min(drop_item.fall_speed, 8); // Terminal velocity
                
            // Check for ground collision
            if (!check_collision(0, _move_y)) {
                y += _move_y;
            } else {
                // Stop falling when hitting ground
                while (!check_collision(0, 1)) {
                    y += 1;
                }
                drop_item.falling = false;
                drop_item.can_pickup = true;
            }
        }
    }
}
