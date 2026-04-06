shader_type canvas_item;

// Capturamos lo que la pantalla está mostrando
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
// Controlamos qué tan borroso se ve
uniform float blur_amount : hint_range(0.0, 5.0) = 0.0;

void fragment() {
    // Aplicamos el desenfoque
    COLOR = textureLod(screen_texture, SCREEN_UV, blur_amount);
}