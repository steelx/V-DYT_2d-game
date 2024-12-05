precision highp float;

#if __VERSION__ >= 130
	#define attribute in
	#define varying out
#endif

const float shadow_height = 200.0;

vec4 get_index_color(float val)
{
	if (val < 8.0)
	{
		return vec4(pow(2.0, val) / 255.0, 0.0, 0.0, 0.0);
	}
		
	if (val < 16.0)
	{
		val -= 8.0;
		return vec4(0.0, pow(2.0, val) / 255.0, 0.0, 0.0);
	}
	
	if (val < 24.0)
	{
		val -= 16.0;
		return vec4(0.0, 0.0, pow(2.0, val) / 255.0, 0.0);
	}
	
	val -= 24.0;
	return vec4(0.0, 0.0, 0.0, pow(2.0, val) / 255.0);
}

attribute vec3 in_Position;

varying vec4 index_color;

uniform vec3  u_position;
uniform float u_index;

void main()
{
	float directional = float(u_index < 0.0);
	float shadow_depth = in_Position.z;
	float shadow_magnitude = floor(shadow_depth * 0.1);
	shadow_depth = shadow_depth - shadow_magnitude * 10.0;
	float light_depth = (u_position.z - floor(u_position.z)) * 10.0 + 0.001;
		
	vec3 vert_pos = vec3(in_Position.xy, -shadow_height);
	if (shadow_magnitude > 0.0) 
	{
		vec3 vert_dir = vert_pos - (u_position.xyz + vert_pos * directional);
		float t_cos = vert_dir.z / length(vert_dir); 
		vert_pos -= normalize(vert_dir) * (shadow_height/t_cos) * shadow_magnitude;
	}
	
	float index = abs(u_index);
    vec4 object_space_pos = vec4(vert_pos.x, vert_pos.y, index * 10.0 + float(light_depth < shadow_depth) * 32000.0, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	index_color = get_index_color(index);
}