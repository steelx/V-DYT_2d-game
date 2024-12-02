precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

const float shadow_height = 200.0;

attribute vec3 in_Position;

varying vec3 params;
varying vec4 view;
varying vec4 color;

uniform vec4 u_position;
uniform vec4 u_size;
uniform vec2 u_cell;

void main()
{
	float shadow_blend = 0.0;
	float directional = float(u_position.w < 0.0);
	vec3 vert_pos = vec3(in_Position.xy, -shadow_height);	
	float shadow_depth = in_Position.z;
	float shadow_magnitude = floor(shadow_depth * 0.1);
	shadow_depth = shadow_depth - shadow_magnitude * 10.0;
	float light_depth = (u_position.z - floor(u_position.z)) * 10.0 + 0.1;
	shadow_depth = shadow_depth * float(light_depth >= shadow_depth);
	
	// Move vertex away from light
	if (shadow_magnitude > 0.0) 
	{
		vec3 vert_dir = vert_pos - (u_position.xyz + vert_pos * directional);
		float t_cos = vert_dir.z / length(vert_dir); 
		vert_pos -= normalize(vert_dir) * (shadow_height/t_cos) * shadow_magnitude;
		shadow_blend = 1.0;
	}
	
	float hardness = abs(u_position.w);
	float index = floor(hardness);
	params = vec3(shadow_depth, shadow_blend, hardness - index);
	
	// Color channel since early GLSL ES wont do array indexing properly...
	float channel = mod(index, 4.0);
	color = vec4(float(channel == 0.0), float(channel == 1.0), float(channel == 2.0), float(channel == 3.0));
	
	// The shadow atlas is a 3D array with rows, columns, and RGBA channels
	float atlas_index = floor(index / 4.0); // determine RGBA
	float atlas_x = mod(atlas_index, u_size.w);
	float atlas_y = floor(atlas_index / u_size.w);
		
	// Used to cull the map's cell
	float left = atlas_x * u_size.x;
	float top  = atlas_y * u_size.y;
	view = vec4(left, left + u_size.x, top, top + u_size.y);
		
	// Shift to cell within normalized surface space
	vec4 pos_transformed = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(vert_pos.x, vert_pos.y, 0.0, 1.0);
	pos_transformed.x += atlas_x * u_cell.x; 
	
	// Because GM does not flip things for us on DirectX
	#ifdef _YY_HLSL11_
		pos_transformed.y -= atlas_y * u_cell.y;
	#else
		pos_transformed.y += atlas_y * u_cell.y;
	#endif
	
	gl_Position = pos_transformed;
}