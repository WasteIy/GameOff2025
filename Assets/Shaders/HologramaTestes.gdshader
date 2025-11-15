shader_type spatial;

uniform sampler2D randomSquares : filter_nearest;
uniform sampler2D mainTexture : filter_linear;
uniform bool visible = true;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(visible){
		vec4 color = texture(mainTexture, UV);
		ALBEDO = color.rgb;
		SPECULAR = 0.0;
	} else {
		vec2 newUV = UV * vec2(2.0);
		vec4 finalColor = texture(randomSquares, newUV);
		vec4 finalColor2 = texture(randomSquares, -newUV);
		float norCos = (cos(TIME) + 1.0) / 2.0;
		float norSin = (sin(TIME * 5.0) + 1.0) / 2.0;
		vec3 cor = (finalColor.rgb * norSin) + (finalColor2.rgb * (1.0 - norSin));
		ALBEDO = cor * vec3(1.0, 0.0, 0.0);
		ALPHA = ALBEDO.r;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
