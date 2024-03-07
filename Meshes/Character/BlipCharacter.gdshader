shader_type spatial;

uniform sampler2D NoiseText;
uniform float effectControl: hint_range(0.0, 1.0) = 0.309;

uniform sampler2D screen_texture : hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 direction = vec2(0.5, 0) * effectControl;
	float noiseValue = texture(NoiseText, UV + direction * TIME).r;
	float opacity;
	vec4 _screen_texture = texture(screen_texture, UV);
	
	ALPHA = noiseValue;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
