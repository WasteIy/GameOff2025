shader_type canvas_item;

uniform float color_offset = 0.0; //0 para vermelho, 0.25 para verde e 0.6 para azul
uniform float sFreq = 1.0; //1.0 para vermelho, 1.525 para verde e 1.875 para azul

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void vertex() {

}

void fragment() {
	float uvX = UV.x - 0.5;
	float sinX = sin((uvX + PI/2.0 + 1.0) * 14.0 * sFreq);
	sinX = (sinX + 1.0) / 5.0;

	float distanceToCenter = abs(uvX) / 0.5;
	COLOR.a = mix(1.0, 0.0, distanceToCenter);
	vec3 raibowColor = hsv2rgb(vec3(color_offset, 1.0, 1.0));
	if(UV.y < sinX || UV.y > (1.0 - sinX)){
		COLOR.a = 0.0;
	}
	int uvXListra = int(UV.x * 700.0) / 10;
	if(uvXListra % 2 == 0){
		COLOR.a = 0.0;
	}
	COLOR.rgb = raibowColor;
}
