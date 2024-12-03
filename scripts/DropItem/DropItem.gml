/**
 * DropItem handles the movement and physics of dropped items (like gems, coins, etc.)
 * in a 2D environment. It manages:
 * - Arc-based initial movement (throwing effect)
 * - Multiple bounces with decreasing height
 * - Gravity-based falling
 * - Ground collision detection
 * 
 * The item goes through several states:
 * 1. Initial arc movement
 * 2. Optional bounces (configured by max_bounces)
 * 3. Gravity-based falling
 * 4. Coming to rest on ground (becomes pickupable)
 * 
 * @param {Id.Instance} _inst_id - The instance ID of the dropped item
 * @param {Real} _x - Initial X position
 * @param {Real} _y - Initial Y position
 * @param {String} _type - Type of dropped item (e.g., "gem", "coin")
 * 
 * @example
 * // In obj_gem Create Event:
 * drop_item = new DropItem(id, x, y, "gem");
 */
function DropItem(_inst_id, _x, _y, _type) constructor {
    // Instance reference
    inst_id = _inst_id;
    
    // Path management
    arc_path = new ArcPath();
    arc_path._inst = _inst_id;
    current_point = undefined;
    
    // Position tracking
    current_x = _x;
    current_y = _y;
    
    // Bounce configuration
    bounce_count = 0;
    max_bounces = 2;
    bounce_force = 1;
    initial_height = 48;
    
    // Physics state
    falling = false;
    fall_speed = 0;
	// set to true when the item has completed its entire movement sequence and come to rest on the ground.
    can_pickup = false;
    
    // Initialize first arc
    InitializeFirstArc();
    
    /**
     * Generates the initial arc path for the item
     */
    static InitializeFirstArc = function() {
        var _angle = random_range(60, 120);
        var _distance = random_range(32, 64);
        var _end_x = current_x + lengthdir_x(_distance, _angle);
        var _end_y = current_y;
        
        arc_path.GenerateArc(current_x, current_y, _end_x, _end_y, initial_height);
        current_point = arc_path.GetCurrentPoint();
    }
    
    /**
     * Updates position based on arc path movement
     */
    static UpdateArcMovement = function() {
        UpdatePosition();
        
        if (!arc_path.MoveNext()) {
            HandleEndOfPath();
        } else {
            UpdateCurrentPoint();
        }
    }
    
    /**
     * Updates the item's position based on current point
     */
    static UpdatePosition = function() {
        with(inst_id) {
            x = other.current_point.x;
            y = other.current_point.y;
        }
    }
    
    /**
     * Handles logic when reaching end of current path
     */
    static HandleEndOfPath = function() {
        if (bounce_count < max_bounces) {
            bounce_count++;
            GenerateNewBounce();
        } else {
            StartFalling();
        }
    }
    
    /**
     * Updates current point and checks for path end
     */
    static UpdateCurrentPoint = function() {
        current_point = arc_path.GetCurrentPoint();
        if (current_point == undefined) {
            StartFalling();
        }
    }
    
    /**
     * Initiates falling state
     */
    static StartFalling = function() {
        current_point = undefined;
        falling = true;
        fall_speed = 0;
    }
    
    /**
     * Generates a new bounce arc
     */
    static GenerateNewBounce = function() {
        var _start_x = current_point ? current_point.x : current_x;
        var _start_y = current_point ? current_point.y : current_y;
        
        var _bounce_angle = random_range(45, 135);
        bounce_force *= 0.6;
        
        var _success = arc_path.GenerateBounceArc(
            _start_x, 
            _start_y, 
            _bounce_angle, 
            bounce_force,
            initial_height
        );
        
        if (!_success) {
            StartFalling();
            return;
        }
        
        UpdateCurrentPoint();
        StorePosition();
    }
    
    /**
     * Stores current position for reference
     */
    static StorePosition = function() {
        if (current_point) {
            current_x = current_point.x;
            current_y = current_point.y;
        }
    }
    
    /**
     * Updates falling movement with gravity
     */
    static UpdateFalling = function() {
        if (!falling) return;
        
        ApplyGravity();
        var _move_y = min(fall_speed, 8); // Terminal velocity
        
        with(inst_id) {
            if (!check_collision(0, _move_y)) {
                y += _move_y;
            } else {
                other.LandOnGround();
            }
        }
    }
    
    /**
     * Applies gravity to falling speed
     */
    static ApplyGravity = function() {
        fall_speed += 0.5;
    }
    
    /**
     * Handles landing on ground
     */
    static LandOnGround = function() {
        with(inst_id) {
            while (!check_collision(0, 1)) {
                y += 1;
            }
        }
        falling = false;
        can_pickup = true;
    }
}
