extends BookProtectiveBaseState
class_name CocainaBookProtectiveState

func _init() -> void:
	level_name = "Book cocaina"
	scene_path = "res://scenes/UI/CocaineBook.tscn"
	page_data = {
		"descriptions": [
			"En esta conducta se evalúa el control de la temperatura corporal, teniendo en cuenta que el calor excesivo puede aumentar el riesgo de deshidratación, sobrecarga física y complicaciones durante estados de alta activación.",
			"En esta conducta se evalúa el cuidado nasal mediante higiene, descanso y reducción de irritación, ya que esto puede disminuir inflamación, prevenir infecciones y reducir el riesgo de daño estructural en el tabique.",
			"En esta conducta se evalúa evitar el consumo después de ejercicio intenso, porque hacerlo con el pulso elevado incrementa la carga sobre el corazón y puede aumentar el riesgo de eventos cardiovasculares."
		],
		"titles": ["TEMPERATURA", "CUIDADO NASAL", "EJERCICIO"],
		"images": [
			preload("res://assets/characterAttacks/Temperatura.png"),
			preload("res://assets/defenses/Nasal-Cocaina.png"),
			preload("res://assets/defenses/SinEjercicio-Cocaina.png")
		]
	}
