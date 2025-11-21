shader_type spatial;
render_mode cull_disabled, unshaded;

uniform sampler2D mainTex : filter_nearest;
uniform vec4 cor : source_color;
uniform sampler2D noiseTex;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	int fator = int(floor(COLOR.r * 4.0));
	vec2 newUV = UV * vec2(0.25, 1.0);
	newUV += vec2(0.25 * float(fator), 0.0);
	
	vec4 main = texture(mainTex, newUV);
	ALPHA = main.r;
	ALBEDO = cor.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
