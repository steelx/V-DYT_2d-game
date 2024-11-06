/// @description obj_sequence_spawner Step event
// Check if the sequence is finished
check_sequence();

// If the spawner no longer exists, clean up
if (!instance_exists(spawner)) {
    cleanup_sequence();
}
