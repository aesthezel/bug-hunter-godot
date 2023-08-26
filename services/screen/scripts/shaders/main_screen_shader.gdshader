shader_type canvas_item;
uniform float scroll_speed_x = 0.1;
uniform float scroll_speed_y = 0.1;

void fragment() {
    vec2 shifteduv = UV;
    shifteduv.x += TIME * scroll_speed_x;
	shifteduv.y += TIME * scroll_speed_y;
    vec4 color = texture(TEXTURE, shifteduv);
    COLOR = color;
}
