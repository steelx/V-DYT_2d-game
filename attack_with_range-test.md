```bash
Root
└── Selector Root
    ├── Knockback Sequence
    ├── Combat Selector
    │   ├── Detect Player
    │   ├── Attack Sequence
    │   │   ├── Check Attack Range
    │   │   └── Attack Player Task
    │   └── Chase Sequence
    │       └── Chase Player Task
    └── Patrol Sequence
        ├── Idle Task
        └── Patrol Task
```
 - Attack Sequence fails
 - Combat Selector moves to Chase Sequence
 - Guardian will chase the player if they're detected but not in attack range


```
Root 
└── var bt_root = new BTreeRoot(id);
    └── Selector Root (var selector_root = new BTreeSelector();)
        bt_root.ChildAdd(selector_root);
        ├── Knockback Sequence (knockback_sequence = new GuardianKnockbackSequenceContainer();)
        │   selector_root.ChildAdd(knockback_sequence);
        │
        ├── Combat Selector (var combat_selector = new BTreeSelector();)
        │   selector_root.ChildAdd(combat_selector);
        │   │
        │   ├── Detect Player (var detect_player = new GuardianDetectPlayerTask(visible_range);)
        │   │   combat_selector.ChildAdd(detect_player);
        │   │
        │   ├── Attack Sequence (var attack_sequence = new BTreeSequence();)
        │   │   combat_selector.ChildAdd(attack_sequence);
        │   │   ├── Check Attack Range (var check_attack_range = new GuardianCheckAttackRangeTask();)
        │   │   │   attack_sequence.ChildAdd(check_attack_range);
        │   │   │
        │   │   └── Attack Player Task (var attack_player_task = new GuardianAttack2Task(seq_guardian_attack, 1);)
        │   │       attack_sequence.ChildAdd(attack_player_task);
        │   │
        │   └── Chase Sequence (var chase_sequence = new BTreeSequence();)
        │       combat_selector.ChildAdd(chase_sequence);
        │       └── Chase Player Task (var chase_player_task = new GuardianChaseTask(move_speed);)
        │           chase_sequence.ChildAdd(chase_player_task);
        │
        └── Patrol Sequence (var patrol_sequence = new BTreeSequence();)
            selector_root.ChildAdd(patrol_sequence);
            ├── Idle Task (var idle_task = new GuardianIdleTask();)
            │   patrol_sequence.ChildAdd(idle_task);
            │
            └── Patrol Task (var patrol_task = new GuardianPatrolTask(move_speed);)
                patrol_sequence.ChildAdd(patrol_task);
```

```js

#region Behaviour_tree
state = noone;
bt_root = new BTreeRoot(id);

// Create root selector
var selector_root = new BTreeSelector();

// Knockback Sequence
knockback_sequence = new GuardianKnockbackSequenceContainer();

// Combat branch
var combat_selector = new BTreeSelector();
var detect_player = new GuardianDetectPlayerTask(visible_range);

// Attack sequence (checks range AND attacks)
var attack_sequence = new BTreeSequence();
var check_attack_range = new GuardianCheckAttackRangeTask();
var attack_player_task = new GuardianAttack2Task(seq_guardian_attack, 1);

// Chase sequence
var chase_sequence = new BTreeSequence();
var chase_player_task = new GuardianChaseTask(move_speed);

// Patrol Sequence
var patrol_sequence = new BTreeSequence();
var idle_task = new GuardianIdleTask();
var patrol_task = new GuardianPatrolTask(move_speed);

// Build the tree:
bt_root.ChildAdd(selector_root);

// Add sequences to root selector
selector_root.ChildAdd(knockback_sequence);

// Build combat branch
combat_selector.ChildAdd(detect_player);      // Only proceed if player detected

// Attack sequence
attack_sequence.ChildAdd(check_attack_range); // Check if in attack range
attack_sequence.ChildAdd(attack_player_task); // If in range, attack
combat_selector.ChildAdd(attack_sequence);    // Try attack first

// Chase sequence
chase_sequence.ChildAdd(chase_player_task);   // If attack fails, try chase
combat_selector.ChildAdd(chase_sequence);     // Add chase as alternative

selector_root.ChildAdd(combat_selector);      // Add combat branch to root
selector_root.ChildAdd(patrol_sequence);      // Patrol is last resort

// Build patrol sequence
patrol_sequence.ChildAdd(idle_task);
patrol_sequence.ChildAdd(patrol_task);

// Initialize the tree
bt_root.Init();
#endregion
```
