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

void main()
{
	vec4 object_space_pos = vec4(in_Position, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	tex_coord = in_TextureCoord;
	
	// Extract the real alpha.  
	// ** See deferred particle shader for description **
	
	vec4 col = in_Colour;
	float alpha = col.a * 100.0;
	col.a = alpha - floor(alpha * 0.1) * 10.0;
	part_color = col;
}
