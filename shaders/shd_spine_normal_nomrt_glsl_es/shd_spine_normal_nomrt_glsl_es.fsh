precision highp float;

#define EM_BIT 0.0039215686274509803921568627451

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

varying vec4 params;
varying vec2 rot;

uniform sampler2D u_normal;
//uniform sampler2D u_material;

void main()
{
	vec2 uv = params.xy;
	vec4 normal   = texture2D(u_normal, uv);
	//vec4 material = texture2D(u_material, uv);
	
	if (normal.a < 0.01) discard;
	
	vec2 f_norm = vec2(normal.xy * 2.0 - 1.0);
	float tcos = rot.x;
	float tsin = rot.y;
	
	normal.x = (f_norm.x * tcos - f_norm.y * tsin) * 0.5 + 0.5;
	normal.y = (f_norm.x * tsin + f_norm.y * tcos) * 0.5 + 0.5;
	
	frag_color = vec4(normal.rgb, (normal.a - EM_BIT) * params.z); // z = emissive
}