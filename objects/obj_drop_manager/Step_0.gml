/// @description obj_drop_manager Step_Event
// Only process drops that still exist
for (var i = 0; i < array_length(drops); i++) {
    var _drop = drops[i];
    
    with(_drop.inst_id) {
        if (drop_item.current_point) {
            x = drop_item.current_point.x;
            y = drop_item.current_point.y;
            
            // Move to next point
            if (!drop_item.arc_path.MoveNext()) {
                // Generate new bounce if possible
                if (drop_item.bounce_count < drop_item.max_bounces) {
                    drop_item.bounce_count++;
                    drop_item.GenerateNewBounce();
                } else {
                    drop_item.can_pickup = true;
                }
            } else {
                drop_item.current_point = drop_item.arc_path.GetCurrentPoint();
            }
        }
    }
}
