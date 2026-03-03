shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 1.0;
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.05;
uniform vec4 liquid_color : source_color = vec4(0.0, 1.0, 0.0, 1.0); // Verde por defecto

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.2337))) * 43758.5453);
}

void fragment() {
	// Obtenemos las coordenadas UV (0 a 1)
	vec2 uv = UV;
	
	// Creamos una distorsión basada en el tiempo y el ruido
	vec2 distorted_uv = uv;
	distorted_uv.x += sin(TIME * speed + uv.y * 10.0) * distortion_strength;
	distorted_uv.y += cos(TIME * speed + uv.x * 10.0) * distortion_strength;
	
	// Obtenemos el color original de la textura (el círculo negro)
	vec4 tex_color = texture(TEXTURE, distorted_uv);
	
	// Mezclamos el color original con el color líquido deseado
	// Si tu círculo era negro puro, esto lo teñirá de verde
	vec4 final_color = tex_color * liquid_color;
	
	// Mantenemos la transparencia original del círculo
	final_color.a = tex_color.a;
	
	COLOR = final_color;
}