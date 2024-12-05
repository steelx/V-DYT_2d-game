precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 tex_coord;
varying vec4 part_color;
varying vec4 params;

uniform vec2 u_depth;

void main()
{
	vec4 object_space_pos = vec4(in_Position.x, in_Position.y, u_depth.y, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	tex_coord = in_TextureCoord;
	
	// Store the alpha and emissive values in vertex color alpha
	// Example: Alpha 0.6045 = 0.6 emissive and 0.045 alpha
	// The following extracts these with an example in comments
	// ** Note multiplying by 0.1 is faster than dividing by 10 **
	
	vec4 col = in_Colour;              // Alpha = 0.6045
	float alpha = in_Colour.a * 100.0; // Alpha = 60.45
	float em = floor(alpha * 0.1);     // Emissive = 6.0
	col.a = alpha - em * 10.0;         // Alpha = 60.45 - 60.0 = 0.45 
	part_color = col;
	float y_norm = mod(in_Colour.b * 255.0, 2.0);
    params = vec4(abs(y_norm - mod(in_Colour.r * 255.0, 2.0)), y_norm, u_depth.x, em * 0.1); // Emissive = 6.0 * 0.1 = 0.6
}
