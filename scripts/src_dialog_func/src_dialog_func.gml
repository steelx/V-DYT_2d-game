/**
* @function DialogSystem class initialized list of dialoge
* @example
* dialog = DialogSystem();
* dialog.add(_picture, _message);
* @Author: Ajinkya Borade
* x.com/@ajinkyax
* youtube.com/@ajinkyax
*/
function DialogSystem() constructor {
    _dialogues = [];
    
    /**
    * Adds a new dialog message to the queue.
    * @param {Asset.GMSprite} _picture - The sprite or image to display with the message.
    * @param {string} _message - The text content of the dialog message.
    */
    add = function(_picture, _message) {
        array_push(_dialogues, {
            picture: _picture,
            message: _message
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
    
    /**
    * Calls draw_dialog_box function to draw picture and text, similar to Deltarune.
    * @param {real} _x - The x-coordinate of the bottom-left corner of the dialog box.
    * @param {real} _y - The y-coordinate of the bottom-left corner of the dialog box.
    * @param {real} _width - The width of the dialog box.
    * @param {real} _height - The height of the dialog box.
    * @param {sprite} _picture - The sprite to display as the character picture.
    * @param {string} _text - The text to display in the dialog box.
    */
    draw = function (_x, _y, _width, _height, _picture, _text) {
        draw_dialog_box(_x, _y, _width, _height, _picture, _text);
    }
}