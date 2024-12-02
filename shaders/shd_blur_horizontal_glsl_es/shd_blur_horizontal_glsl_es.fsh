precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
	#define texture2D texture
#else
	#define frag_color gl_FragColor
#endif

vec3 blur_dof(vec4 source, vec4 sample, float c)
{
	float use_sample = float(source.a == sample.a);
	return vec3((source.rgb * (1.0 - use_sample) + sample.rgb * use_sample) * c);
}

vec4 sample_bloom(vec2 uv, vec2 texel)
{
	vec4 source = texture2D(gm_BaseTexture, uv);
	vec3 result = source.rgb * 0.227027;
	result += blur_dof(source, texture2D(gm_BaseTexture, uv + vec2(texel.x, 0.0)), 0.1945946);
    result += blur_dof(source, texture2D(gm_BaseTexture, uv - vec2(texel.x, 0.0)), 0.1945946);
	result += blur_dof(source, texture2D(gm_BaseTexture, uv + vec2(texel.x * 2.0, 0.0)), 0.1216216);
    result += blur_dof(source, texture2D(gm_BaseTexture, uv - vec2(texel.x * 2.0, 0.0)), 0.1216216);	
    result += blur_dof(source, texture2D(gm_BaseTexture, uv + vec2(texel.x * 3.0, 0.0)), 0.054054);
    result += blur_dof(source, texture2D(gm_BaseTexture, uv - vec2(texel.x * 3.0, 0.0)), 0.054054);	
    result += blur_dof(source, texture2D(gm_BaseTexture, uv + vec2(texel.x * 4.0, 0.0)), 0.016216);
    result += blur_dof(source, texture2D(gm_BaseTexture, uv - vec2(texel.x * 4.0, 0.0)), 0.016216);	

	return vec4(result, source.a);	
}

varying vec2 tex_coord;
varying vec2 tex_size;

void main()
{
	frag_color = sample_bloom(tex_coord, tex_size);
}