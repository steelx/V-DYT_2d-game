/// @description draw_tooltip Initializes obj_tooltip
/// @param {String} _text The text to display
/// @param {Asset.GMSprite} _icon The icon sprite to display
/// @param {Real} _x The x position relative to the room
/// @param {Real} _y The y position relative to the room
/// @param {Function} _interaction_func The function to call on interaction
/// @return {Id.Instance} return obj_tooltip instance
function draw_tooltip(_text, _icon, _x, _y, _interaction_func = undefined) {
    var _inst = instance_create_layer(_x, _y, "Instances", obj_tooltip);
    with(_inst) {
        text = _text;
        icon = _icon;
        _init_x = _x;
        _init_y = _y;
        interaction_function = _interaction_func;
        target_alpha = 1; 
    }
    return _inst;
}
