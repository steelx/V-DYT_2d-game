precision highp float;

#define EM_BIT 0.0039215686274509803921568627451

#if __VERSION__ >= 130
	out vec4 frag_color0;
	out vec4 frag_color1;
	out vec4 frag_color2;
	#define varying in
	#define texture2D texture
#else
	#define frag_color0 gl_FragData[0]
	#define frag_color1 gl_FragData[1]
	#define frag_color2 gl_FragData[2]
#endif

varying vec4 params;
varying vec4 uv;
varying float occlusion;

uniform sampler2D u_normal;
uniform sampler2D u_material;

void main()
{
	vec4 normal   = texture2D(u_normal, uv.xy);
	vec4 material = texture2D(u_material, uv.zw);
	
	if (material.a < 0.01) discard;
	
	vec2 f_norm = vec2(normal.xy * 2.0 - 1.0);
	float tcos = params.z;
	float tsin = params.w;
	
	normal.x = (f_norm.x * tcos - f_norm.y * tsin) * 0.5 + 0.5;
	normal.y = (f_norm.x * tsin + f_norm.y * tcos) * 0.5 + 0.5;
	
	frag_color0 = vec4(normal.rgb, (normal.a - EM_BIT) * params.x); // z = emissive
	frag_color1 = vec4(material.rgb, params.y); // w = shadow depth
	frag_color2 = vec4(params.y, occlusion, 0.0, 1.0);
}