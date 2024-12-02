precision highp float;

#if __VERSION__ >= 130
	out vec4 frag_color;
	#define varying in
#else
	#define frag_color gl_FragColor
#endif

#define M_PI 3.1415926535897932384626433832795

varying vec4  index_color;

void main()
{		
	frag_color = index_color;
}