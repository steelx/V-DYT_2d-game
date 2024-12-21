/// @desc payer keyboard events
function player_input() {
	// Slot selection
    if (keyboard_check_pressed(ord("1"))) {
		if (obj_inventory.has_sword == false) {
			show_popup_notifications([
                ["[c_red]Ah oh![] Please pickup your sword first", 1]
            ]);
			return;
		}
        obj_inventory.selected_slot = INVENTORY_SLOTS.SWORD;
    }
    if (keyboard_check_pressed(ord("2"))) {
		if (obj_inventory.has_sword == false) {
			show_popup_notifications([
                ["[c_red]Ah oh![] Please pickup your sword first", 1]
            ]);
			return;
		}
        obj_inventory.selected_slot = INVENTORY_SLOTS.BLITZ;
    }
    if (keyboard_check_pressed(ord("3"))) {
        obj_inventory.selected_slot = INVENTORY_SLOTS.THROW;
    }
    if (keyboard_check_pressed(ord("4")) && obj_inventory.heal_potions > 0) {
        // Instant heal
        if (hp < max_hp) {
            hp = min(hp + 2, max_hp); // Heal 20 HP
            obj_inventory.heal_potions--;
            
            // Heal effect
			// TODO: spawn heal animation
            audio_play_sound(snd_health_pickup_01, 0, false);
            show_popup_notifications([
                ["[rainbow]Healed![]", 1]
            ]);
        } else {
            show_popup_notifications([
                ["[c_red]HP is already full![]", 1]
            ]);
        }
    }

    // Attack handling based on selected slot
    if (keyboard_check_pressed(vk_space)) {
		if (obj_inventory.has_sword == false) {
			show_popup_notifications([
                ["[c_red]Ah oh![] Please pickup your sword first", 1]
            ]);
			return;
		}
        if (state != CHARACTER_STATE.ATTACK and state != CHARACTER_STATE.SUPER_ATTACK) {
			if (keyboard_check(vk_shift)) {
                if (is_on_ground()) {
                    state = CHARACTER_STATE.SUPER_ATTACK;
                    add_screenshake(0.3, 1.5);
					spawn_super_attack();
				}
            } else {
				state = CHARACTER_STATE.ATTACK;
                add_screenshake(0.2, 1.0);
				
				switch(obj_inventory.selected_slot) {
	                case INVENTORY_SLOTS.SWORD:
	                    image_index = 0;
	                    add_screenshake(0.1, 1);
	                    break;
                    
	                case INVENTORY_SLOTS.BLITZ:
	                    spawn_blitz_attack();
	                    break;
                    
	                case INVENTORY_SLOTS.THROW:
						obj_inventory.has_sword = false;
	                    spawn_throw_sword_attack();
	                    break;
	            }
			}
        }
    }
	
    // Left movement
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        if (state != CHARACTER_STATE.KNOCKBACK && state != CHARACTER_STATE.ATTACK && state != CHARACTER_STATE.SUPER_ATTACK) {
            if (state != CHARACTER_STATE.JETPACK_JUMP) {
                state = CHARACTER_STATE.MOVE;
            }
            vel_x = -move_speed;
            image_xscale = -1;
            
            if (grounded && sprite_index != sprites_map[$ CHARACTER_STATE.FALL]) {
                sprite_index = obj_inventory.has_sword ? sprites_map[$ CHARACTER_STATE.MOVE] : spr_hero_run_without_sword;
            }
        }
    }
    
    // Right movement
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        if (state != CHARACTER_STATE.KNOCKBACK or state != CHARACTER_STATE.ATTACK or state != CHARACTER_STATE.SUPER_ATTACK) {
            if (state != CHARACTER_STATE.JETPACK_JUMP) {
                state = CHARACTER_STATE.MOVE;
            }
            vel_x = move_speed;
            image_xscale = 1;
        }
    }
    
    // Jump
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        if (state != CHARACTER_STATE.KNOCKBACK or state != CHARACTER_STATE.ATTACK or state != CHARACTER_STATE.SUPER_ATTACK) {
            jump_key_held_timer = 0;
            alarm_set(JET_PACK_JUMP, 1);
        }
    }
    
    // Jump down
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) and is_platform_below() {
        if (state != CHARACTER_STATE.KNOCKBACK or state != CHARACTER_STATE.ATTACK or state != CHARACTER_STATE.SUPER_ATTACK) {
            add_screenshake(0.2, 1.0);
            state = CHARACTER_STATE.FALL;
        }
    }
    
    // Stop horizontal movement if no left/right key is pressed
    if (!keyboard_check(vk_left) && !keyboard_check(vk_right) && !keyboard_check(ord("A")) && !keyboard_check(ord("D"))) {
        if (state == CHARACTER_STATE.MOVE) {
            state = CHARACTER_STATE.IDLE;
            vel_x = 0;
        }
    }
}

