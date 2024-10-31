/**
* @function DialogSystem class initialized list of dialoge
* @example
* dialog = DialogSystem();
* dialog.add(_picture, _message);
* @Author: Ajinkya Borade
* x.com/@ajinkyax
* youtube.com/@ajinkyax
*/

enum DIALOG_CALLBACK {
    FUNCTION,
    TRIGGER,
    NEXT,
    CLOSE
}

function DialogSystem() constructor {
    _dialogues = [];
	_typist = scribble_typist();
    _typist.in(0.5, 0); // Set typewriter speed (0.5 seconds per character)

    /**
    * Adds a new dialog message to the queue.
    * @param {Asset.GMSprite} _picture - The sprite or image to display with the message.
    * @param {string} _message - The text content of the dialog message.
    * @param {array} _options - Multi select options
    */
    add = function(_picture, _message, _options = [], _callbacks = []) {
        array_push(_dialogues, {
            picture: _picture,
            message: _message,
            options: _options,
            callbacks: _callbacks,
            current_option: 0
        });
    };
    
    
    /**
    * Removed first dialog from list.
    * @return {Struct{Asset.GMSprite, string}} - The first dialog item of the dialogues array.
    */
    pop = function() {
        var _t = array_first(_dialogues);
        array_delete(_dialogues, 0, 1);
        
        return _t;
    };
    
    /**
    * Returns the total number of dialog messages.
    * @returns {Real} The count of dialog messages.
    */
    count = function() {
        return array_length(_dialogues);
    };
    
    has_options = function(_dialog) {
        return _dialog != noone && array_length(_dialog.options) > 0;
    };
    
    next_option = function(_dialog) {
        if (_dialog != noone) {
            _dialog.current_option = (_dialog.current_option + 1) % array_length(_dialog.options);
        }
    };
    
    prev_option = function(_dialog) {
        if (_dialog != noone) {
            _dialog.current_option = (_dialog.current_option - 1 + array_length(_dialog.options)) % array_length(_dialog.options);
        }
    };
    
    get_selected_option = function(_dialog) {
        if (_dialog != noone && array_length(_dialog.options) > 0) {
            return _dialog.options[_dialog.current_option];
        }
        return "";
    };
    
    execute_callback = function(_dialog, _index) {
        if (_dialog != noone && array_length(_dialog.callbacks) > _index) {
            _dialog.callbacks[_index]();
        }
    };
    
    /**
    * Calls draw_dialog_box function to draw picture and text, similar to Deltarune.
    * @param {real} _x - The x-coordinate of the bottom-left corner of the dialog box.
    * @param {real} _y - The y-coordinate of the bottom-left corner of the dialog box.
    * @param {real} _width - The width of the dialog box.
    * @param {real} _height - The height of the dialog box.
    * @param {struct} _dialog - The sprite to display as the character picture.
    */
    draw = function (_x, _y, _width, _height, _dialog) {
        if (_dialog != noone) {
            draw_dialog_box(_x, _y, _width, _height, _dialog.picture, _dialog.message, _dialog.options, _dialog.current_option);
        }
    }
	
	// reset the typist for new messages
    reset_typist = function() {
        _typist.reset();
    }
}


