precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

varying vec4 part_color;
varying vec3 params;

void main()
{	
	// params: xy = uv, z = shadow depth, w = emissive strength
	vec4 albedo = texture2D(gm_BaseTexture, params.xy) * part_color;
	float blend = albedo.a;
	if (blend < 0.01) discard;
	
	frag_color = vec4(0.8 * blend, 0.8 * blend, blend, params.z);
}
