# Understanding Jetpack Movement and Collision System in GameMaker

## Overview
This tutorial explains how to implement a robust jetpack movement system with proper collision handling in a 2D platformer game. The system handles both upward and downward movement, ceiling and floor collisions, and smooth state transitions.

## Key Components

### 1. Movement Direction
```gml
var _move_dir_y = sign(vel_y);
```
- Positive value (+1): Moving downward
- Negative value (-1): Moving upward
- Zero (0): No vertical movement

### 2. Buffer Distance
```gml
var _buffer_distance = 4; // Small buffer to prevent getting too close to ceiling
```
This creates a small gap between the player and the ceiling, preventing the player from getting stuck.

## Main Movement Logic

### 1. Jetpack State Handling
```gml
if (state == CHARACTER_STATE.JETPACK_JUMP) {
    if (_move_dir_y < 0) {
        // Upward movement logic
    } else if (_move_dir_y > 0) {
        // Downward movement logic
    }
}
```

### 2. Upward Movement (Ceiling Detection)
```gml
// Check for ceiling ahead with buffer
var _ceiling_ahead = check_tilemap_collision(0, _step - _buffer_distance);

if (_ceiling_ahead) {
    // Find exact distance to ceiling
    var _dist_to_ceiling = 0;
    for (var i = 1; i <= abs(_step); i++) {
        if (check_tilemap_collision(0, -i)) {
            _dist_to_ceiling = i - 1; // Stay one pixel away
            break;
        }
    }
    if (_dist_to_ceiling > 0) {
        y -= _dist_to_ceiling;
    }
    vel_y = 0;
    break;
}
```
This code:
1. Checks if there's a ceiling ahead
2. If found, calculates exact distance to ceiling
3. Moves player to a safe position just below the ceiling
4. Stops vertical movement

### 3. Downward Movement (Floor Detection)
```gml
if (check_tilemap_collision(0, _step)) {
    y = floor(y);
    vel_y = 0;
    grounded = true;
    state = CHARACTER_STATE.IDLE;
    sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
    break;
}
```
When hitting the ground:
1. Aligns player with the floor using `floor(y)`
2. Stops vertical movement
3. Sets grounded state
4. Transitions to IDLE state
5. Updates sprite

### 4. Platform Collision
```gml
var _platform = instance_place(x, y + _step, obj_collision);
if (_platform != noone) {
    if (_move_dir_y > 0 && bbox_bottom <= _platform.bbox_top) {
        y = _platform.bbox_top - (bbox_bottom - y);
        vel_y = 0;
        grounded = true;
        if (state == CHARACTER_STATE.JETPACK_JUMP) {
            state = CHARACTER_STATE.IDLE;
            sprite_index = sprites_map[$ CHARACTER_STATE.IDLE];
        }
        break;
    }
}
```
Handles collision with platform objects:
1. Checks if player is above platform
2. Aligns player with platform top
3. Sets grounded state
4. Transitions to IDLE if in jetpack state

## Safety Checks

### Emergency Ceiling Escape
```gml
if (state == CHARACTER_STATE.JETPACK_JUMP) {
    if (check_tilemap_collision(0, 0)) {
        // Find safe position below
        var _safe_distance = 1;
        while (check_tilemap_collision(0, _safe_distance) && _safe_distance < 32) {
            _safe_distance++;
        }
        if (_safe_distance < 32) {
            y += _safe_distance;
            vel_y = 0;
        }
    }
}
```
This safety check:
1. Detects if player is stuck in ceiling
2. Finds nearest safe position below
3. Moves player to safe position

## Best Practices

1. **Precise Collision Detection**
   - Always check collisions before moving
   - Use buffer distances to prevent getting stuck
   - Calculate exact distances to surfaces

2. **State Management**
   - Clear state transitions (JETPACK_JUMP → IDLE)
   - Update sprites with state changes
   - Reset relevant variables on state change

3. **Movement Safety**
   - Use floor() for clean alignment with surfaces
   - Implement safety checks for edge cases
   - Break movement loop when collision occurs

4. **Clean Code Structure**
   - Separate upward and downward movement logic
   - Handle different collision types separately
   - Include safety checks at appropriate points

## Conclusion
This system provides a smooth and reliable jetpack movement experience while handling all necessary collision cases. The combination of precise collision detection, proper state management, and safety checks ensures a bug-free player movement system.
