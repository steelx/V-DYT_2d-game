precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color0;
	out vec4 frag_color1;
	#define varying in
	#define texture2D texture
#else
	#define frag_color0 gl_FragData[0]
	#define frag_color1 gl_FragData[1]
#endif

varying vec2 tex_coord;
varying vec4 material;
varying float occlusion;

void main()
{	
	vec4 col = texture2D(gm_BaseTexture, tex_coord);
	if (col.a < 0.01) discard;
	
	frag_color0 = vec4(col.rgb * material.rgb, material.a);
	frag_color1 = vec4(material.a, occlusion, 0.0, 1.0);
}