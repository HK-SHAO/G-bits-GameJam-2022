shader_type canvas_item;

uniform float rateX = 1;
uniform float rateY = 1;

vec4 mainImage(sampler2D my_texture, vec2 my_uv, float iTime)
{
	vec2 uv = my_uv;
//	uv.y = -uv.y;
	
	uv.y += (cos((uv.y + (iTime * 0.04)) * 45.0) * 0.0039 * rateX) +
		(cos((uv.y + (iTime * 0.1)) * 10.0) * 0.002);

	uv.x += (sin((uv.y + (iTime * 0.07)) * 15.0) * 0.0029 * rateY) +
		(sin((uv.y + (iTime * 0.1)) * 15.0) * 0.002);
		

	vec4 texColor = texture(my_texture, uv);
	return texColor;
}

void fragment() {
	COLOR = mainImage(SCREEN_TEXTURE, SCREEN_UV, TIME);
}