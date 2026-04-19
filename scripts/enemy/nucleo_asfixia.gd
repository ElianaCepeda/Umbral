extends StaticBody2D

# Cuando tu bala toque este nodo, buscará esta función
func take_damage(amount: int):
	# 1. Le avisa al enemigo que reste la vida
	get_parent().take_damage(amount)
	
	# 2. Hacemos que el núcleo palpite visualmente para dar feedback de que acertaste
	var tween = create_tween()
	scale = Vector2(1.5, 1.5)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
