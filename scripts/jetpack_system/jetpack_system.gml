function JetpackSystem(_owner) constructor {
    owner = _owner;
    max_fuel = 10;
    fuel = max_fuel;
    fuel_consumption_rate = 2/60;
    fuel_regeneration_rate = 0.5/60;
    max_height = 96;
    min_height = 36;
    hover_height = 96;
    hover_amplitude = 2;
    hover_speed = 4;
    hover_strength = 0.9;
    bob_range = 3;
    max_vertical_speed = 1.5;
    max_horizontal_speed = 1.5;
    horizontal_momentum = 0;
    acceleration = 0.2;
    deceleration = 0.1;
    ground_check_distance = 100;
    
    // Hover animation properties
    hover_direction = 1;
    hover_y_offset = 0;
    ground_reference_y = owner.y;
    last_ground_y = owner.y;
    
    function update() {
        if (owner.grounded and fuel < max_fuel) {
            regenerate_fuel();
        }
    }
    
    function regenerate_fuel() {
        fuel += fuel_regeneration_rate;
        fuel = min(fuel, max_fuel);
    }
    
    function consume_fuel() {
        if (has_sufficient_fuel()) {
            fuel -= fuel_consumption_rate;
            return true;
        }
        return false;
    }
    
    function has_sufficient_fuel() {
        return fuel > fuel_consumption_rate;
    }
    
    function update_hover_animation() {
        hover_y_offset += hover_direction * hover_speed * delta_time;
        if (abs(hover_y_offset) >= bob_range) {
            hover_direction *= -1;
        }
        return hover_y_offset;
    }
    
    function update_ground_reference() {
        var _platform = global.collision_grid.GetNearestPlatformBelow(
            owner.x, 
            owner.y, 
            ground_check_distance
        );
        
        if (_platform != noone) {
            ground_reference_y = _platform.bbox.top;
            return true;
        }
        
        var _obstacle = global.collision_grid.GetNearestObstacleBelow(
            owner.x, 
            owner.y, 
            ground_check_distance
        );
        
        if (_obstacle != noone) {
            ground_reference_y = _obstacle.position.y;
            return true;
        }
        
        return false;
    }
    
    function get_target_height() {
        update_ground_reference();
        var _target_height = ground_reference_y - hover_height;
        _target_height += update_hover_animation();
        return min(_target_height, last_ground_y - max_height);
    }
    
    function create_particles() {
        if (irandom(2) == 0) {
            var _particle = instance_create_layer(
                owner.x, 
                owner.bbox_bottom,
                "Instances",
                obj_jetpack_particle
            );
            _particle.direction = 270 + random_range(-15, 15);
            _particle.speed = random_range(2, 4);
        }
    }
    
    function vertical_movement(is_active, target_height = 0) {
        if (is_active) {
            owner.vel_y = approach(owner.vel_y, -hover_strength, acceleration * delta_time);
        } else {
            owner.vel_y = approach(owner.vel_y, 0, deceleration * delta_time);
        }
        
        // Smooth vertical movement to target height
        var _vertical_distance = target_height - owner.y;
        owner.vel_y += _vertical_distance * 0.1;
        
        // Cap vertical velocity
        owner.vel_y = clamp(owner.vel_y, -max_vertical_speed, max_vertical_speed);
    }
    
    function horizontal_movement(is_active) {
        var _input_x = (keyboard_check(vk_right) - keyboard_check(vk_left));
        
        if (is_active) {
            if (_input_x != 0) {
                horizontal_momentum = approach(
                    horizontal_momentum,
                    _input_x * max_horizontal_speed,
                    acceleration * delta_time
                );
            } else {
                horizontal_momentum = approach(
                    horizontal_momentum,
                    0,
                    deceleration * delta_time
                );
            }
        } else {
            horizontal_momentum = approach(horizontal_momentum, 0, deceleration * delta_time);
        }
        
        // Apply horizontal momentum
        owner.vel_x = horizontal_momentum;
        
        // Ensure horizontal speed is capped
        owner.vel_x = clamp(owner.vel_x, -max_horizontal_speed, max_horizontal_speed);
    }
}
