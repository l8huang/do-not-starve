   uifade   	   MatrixPVW                                                                                SAMPLER    +         ALPHA_RANGE                        PosUVColour.vsg  uniform mat4 MatrixPVW;

attribute vec3 POSITION;
attribute vec2 TEXCOORD0;
attribute vec4 DIFFUSE;

varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

void main()
{
	gl_Position = MatrixPVW * vec4( POSITION.xyz, 1.0 );
	PS_TEXCOORD.xy = TEXCOORD0.xy;
	PS_COLOUR.rgba = vec4( DIFFUSE.rgb * DIFFUSE.a, DIFFUSE.a ); // premultiply the alpha
}

 	   uifade.ps!  #if defined( GL_ES )
precision mediump float;
#endif

uniform sampler2D SAMPLER[1];
varying vec2 PS_TEXCOORD;
varying vec4 PS_COLOUR;

uniform vec2 ALPHA_RANGE;
#define ALPHA_MIN ALPHA_RANGE.x
#define ALPHA_MAX ALPHA_RANGE.y

void main()
{
	// Some Android shader compilers cannot read from output vars
    vec4 colour = texture2D( SAMPLER[0], PS_TEXCOORD.xy );
    float alpha = clamp( ( colour.a - ALPHA_MIN ) / ( ALPHA_MAX - ALPHA_MIN ), 0.0, 1.0 );
	gl_FragColor = vec4( colour.rgb * alpha, alpha ) * PS_COLOUR.rgba;
}

                 