shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.490196, 0.396078, 0.572549, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 3.0;

void fragment() {
	vec4 col = texture(TEXTURE, UV);

	if (col.a < 0.5) {
		vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
		float alpha = 0.0;
		alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
		alpha += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
		alpha += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
		alpha = min(alpha, 1.0);
		col = mix(col, outline_color, alpha);
	}

	COLOR = col;
}
