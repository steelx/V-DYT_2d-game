/// @description cleanup upon destroy from end step
if (instance_exists(active_attack_sequence)) {
    active_attack_sequence.cleanup_sequence();
}
