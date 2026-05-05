extends BookProtectiveBaseState
class_name TabacoBookProtectiveState

func _init() -> void:
	page_data = {
		"descriptions": [
			"En esta conducta se evalúa el uso del chicle como estrategia para distraer el impulso de fumar, reducir la ansiedad momentánea por nicotina y darle al jugador una alternativa simbólica frente al deseo de consumir.",
			"En esta conducta se evalúa el uso del parche de nicotina como una forma controlada de disminuir la ansiedad y los síntomas de abstinencia, evitando la exposición directa a las sustancias tóxicas presentes en el humo.",
			"En esta conducta se evalúa la importancia del ejercicio para disminuir el deseo de fumar, mejorar la función pulmonar y apoyar la circulación, contrarrestando parte del deterioro físico asociado al tabaco."
		],
		"titles": ["Chicle", "Parche de nicotina", "Ejercicio"],
		"images": [
			preload("res://assets/characterAttacks/gumAttack_single.png"),
			preload("res://assets/defenses/Parche-Tabaco.png"),
			preload("res://assets/defenses/Ejercicio-Tabaco.png")
		]
	}
