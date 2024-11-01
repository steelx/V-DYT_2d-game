/// @function cutscene_finished()
/// @description Called when a cutscene sequence finishes
function cutscene_finished() {
    // Transition to the next room after the cutscene
    transition_init(rm_level_1, seq_fade_out, seq_fade_in);
}

/// @function start_cutscene(_sequence)
/// @param {asset.GMSequence} _sequence The sequence to play as a cutscene
function start_cutscene(_sequence) {
    var _cutscene_layer = layer_create(-9999, "Cutscene");
    var _seq_element = layer_sequence_create(_cutscene_layer, 0, 0, _sequence);
    
    // Set the callback for when the sequence finishes
    layer_sequence_callback_set(_seq_element, seqtracktype_moment, 0, cutscene_finished);
    
    // Play the sequence
    layer_sequence_play(_seq_element);
    
    // Set game state to cutscene
    global.game_state = GAME_STATES.CUTSCENE;
}
