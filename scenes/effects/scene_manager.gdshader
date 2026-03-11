shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0);
uniform bool reverse = true;
uniform vec2 numberofSquares = vec2(16, 9);
uniform vec2 pixelsPerTile = vec2(16,16);

void fragment() {
	vec2 positionInSquare = UV * numberofSquares;
	vec2 pixelPosition = round(positionInSquare*pixelsPerTile);
	vec2 frac = fract(pixelPosition/ pixelsPerTile);
	vec2 direction = abs(frac-0.5);
	
	if(direction.x + direction.y +UV.x + UV.y >= progress * 4.0){
		if(!reverse){
			discard;
		}
	}
	else if (reverse){
		discard;
	}	
}
