shader_type canvas_item;

group_uniforms palates;
uniform sampler2D texture_palate;
uniform sampler2D skin_texture_palate;
group_uniforms;

uniform int team_color;
uniform int skin_color : hint_enum("light", "mid", "dark");




vec2 px_to_uv(ivec2 pos,ivec2 tex_size) {
	return vec2(
		(float(pos[0]) + 0.5) / float(tex_size[0]),
		(float(pos[1]) + 0.5) / float(tex_size[1])
	);
}

vec4 get_palate_color(vec4 color, sampler2D texture_palate_, int selection) {
	ivec2 tex_size = textureSize(texture_palate_, 0);
	for (int i=0; i< tex_size[0]; i++) {
		vec2 uv_ref = px_to_uv(ivec2(i, 0), tex_size);
		vec4 color_ref = texture(texture_palate_, uv_ref);
		if (color == color_ref) {
			vec2 uv_color_dest =px_to_uv(ivec2(i, selection), tex_size);
			return texture(texture_palate_, uv_color_dest);
		}
	}
	return color;
}

void fragment() {
	COLOR = get_palate_color(COLOR, texture_palate, team_color);
	if (skin_color > 0) {
		COLOR = get_palate_color(COLOR, skin_texture_palate, skin_color);
	}
}
