/// @desc Draws a sprite with highlight border effect, call at Draw event
/// Remember that the color values should be between 0.0 and 1.0, not 0-255. If you need to convert from 0-255 color values, divide by 255
/// @param {Asset.GMSprite} _sprite       Sprite to draw
/// @param {Real} _x                      X position
/// @param {Real} _y                      Y position
/// @param {Real} _subimg                 Subimage index
/// @param {Array<Real>} _color          RGB array [r,g,b] where each is 0-1
/// @param {Real} _thickness              Border thickness
/*
@example
// Red highlight
draw_highlight_sprite(sprite_index, x, y, image_index, [1.0, 0.0, 0.0]);

// Green highlight with thicker border
draw_highlight_sprite(sprite_index, x, y, image_index, [0.0, 1.0, 0.0], 2.0);

// Blue highlight
draw_highlight_sprite(sprite_index, x, y, image_index, [0.0, 0.0, 1.0]);

// White highlight
draw_highlight_sprite(sprite_index, x, y, image_index, [1.0, 1.0, 1.0]);

// Convert from 255-based color to 0-1 range
var color_255 = make_color_rgb(255, 128, 0); // Orange
draw_highlight_sprite(
    sprite_index, 
    x, 
    y, 
    image_index,
    [
        color_get_red(color_255) / 255,
        color_get_green(color_255) / 255,
        color_get_blue(color_255) / 255
    ]
);
**/
function highlight_sprite(_sprite, _x, _y, _subimg, _color, _thickness = 0.5) {
    static shader = sh_highlight;
    static u_highlight_color = shader_get_uniform(shader, "u_highlight_color");
    static u_thickness = shader_get_uniform(shader, "u_thickness");
    static u_texel_size = shader_get_uniform(shader, "u_texel_size");
    
    shader_set(shader);
    
    // Set uniforms
    shader_set_uniform_f(u_highlight_color, _color[0], _color[1], _color[2]);
    shader_set_uniform_f(u_thickness, _thickness);
    shader_set_uniform_f(u_texel_size, 
        texture_get_texel_width(sprite_get_texture(_sprite, _subimg)),
        texture_get_texel_height(sprite_get_texture(_sprite, _subimg))
    );
    
    draw_sprite(_sprite, _subimg, _x, _y);
    
    shader_reset();
}
