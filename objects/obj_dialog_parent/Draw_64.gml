/// @description draw dialog

if showing_dialog {
    var _dialog_width = 600;
    var _dialog_height = 100;
    var _dialog_x = (display_get_gui_width() - _dialog_width) / 2;
    var _dialog_y = display_get_gui_height() - 20; // 20 pixels from the bottom
    var _picture = current_dialog.picture;
    var _message = current_dialog.message;
    
    if sprite_get_height(_picture) > _dialog_height {
        _dialog_height = sprite_get_height(_picture);
    }
    
    dialog.draw(_dialog_x, _dialog_y, _dialog_width, _dialog_height, _picture, _message);
}
