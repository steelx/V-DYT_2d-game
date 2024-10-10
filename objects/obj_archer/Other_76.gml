/// @description obj_archer broadcast message

switch(event_data[? "message"]) {
    case "archer_fire":
        var _x = x + (32* image_xscale);// point close to archer
        var _y = bbox_top-16; // Adjust vertical offset as needed
        if !instance_exists(obj_player) break;
        with (instance_create_layer(_x, _y, "Player", obj_arrow)) {
            target_x = obj_player.x;
            target_y = obj_player.y - 32; // Aim higher on the player
            
            // Calculate initial velocity
            var _distance = point_distance(_x, _y, target_x, target_y);
            var _time = _distance / 16; // Adjust this value to change arrow speed
            
            angle = point_direction(_x, _y, target_x, target_y);
            
            // Add an upward component to the velocity
            var _upward_boost = 4; // Adjust this value to change the arc height
            vel_x = lengthdir_x(_distance / _time, angle);
            vel_y = lengthdir_y(_distance / _time, angle) - _upward_boost;
            
            // Set the sprite angle
            image_angle = angle;
        }
        break;
    
}
