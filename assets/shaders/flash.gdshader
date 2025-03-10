shader_type canvas_item;
uniform bool white;

void fragment()
{
	vec4 color = texture(TEXTURE, UV);

	if (white)
	{
		COLOR = vec4(1, 1, 1, color.a);
	}
	else
	{
		COLOR = color;
	}
}