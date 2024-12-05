precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

varying vec4 params;

//uniform sampler2D u_normal;
uniform sampler2D u_material;

void main()
{
	vec2 uv = params.xy;
	//vec4 normal   = texture2D(u_normal, uv);
	vec4 material = texture2D(u_material, uv);
	
	if (material.a < 0.01) discard;
	
	frag_color = vec4(material.rgb, params.w); // w = shadow depth
}