shader_type canvas_item;



uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float saturation = 1.0;
uniform float contrast = 1.0;
uniform float brightness = 1.0;

void fragment() {
        vec4 tex_color = texture(screen_texture, UV);
		COLOR.rgb = mix(vec3(dot(tex_color.rgb, vec3(0.299,0.587,0.114))), tex_color.rgb, saturation);
		COLOR.rgb = mix(vec3(0.0), COLOR.rgb, brightness);
		COLOR.rgb = mix(vec3(0.5), COLOR.rgb, contrast);
}
