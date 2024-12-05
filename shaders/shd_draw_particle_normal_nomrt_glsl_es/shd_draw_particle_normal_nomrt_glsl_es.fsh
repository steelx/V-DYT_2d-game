precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

varying vec2 tex_coord;
varying vec4 part_color;
varying vec3 params;

void main()
{	
	// params: xy = uv, z = shadow depth, w = emissive strength
	vec4 albedo = texture2D(gm_BaseTexture, tex_coord) * part_color;
	float blend = albedo.a;
	if (blend < 0.01) discard;
	
	float cutoff = smoothstep(0.1, 1.0, blend);
	float x_norm = (0.5 - abs(params.x - 0.5)) * cutoff;
	float y_norm = (0.5 - abs(params.y - 0.5)) * cutoff;

	frag_color = vec4(x_norm, y_norm, (x_norm + y_norm) * 2.0, params.z * blend);
}
