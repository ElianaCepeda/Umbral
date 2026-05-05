extends BookProtectiveBaseState
class_name AlcoholBookProtectiveState

func _init() -> void:
	page_data = {
		"descriptions": [
			"En esta conducta se evalúa el uso del agua como apoyo para mantener la hidratación, reducir parcialmente el malestar físico asociado al consumo de alcohol y evitar que la deshidratación aumente la sensación de mareo o deterioro.",
			"En esta conducta se evalúa la importancia de comer antes o durante el consumo, ya que la comida puede proteger la mucosa gástrica, ralentizar la absorción del alcohol y disminuir el impacto inmediato sobre el cuerpo.",
			"En esta conducta se evalúa el riesgo de mezclar alcohol con medicamentos, teniendo en cuenta que puede potenciar efectos secundarios, alterar la eficacia de los fármacos y afectar especialmente al hígado y al sistema nervioso."
		],
		"titles": ["AGUA", "COMIDA", "NO MEZCLAR"],
		"images": [
			preload("res://assets/characterAttacks/waterAttack_single.png"),
			preload("res://assets/defenses/Comida-Alcohol.png"),
			preload("res://assets/defenses/Medicina-Alcohol.png")
		]
	}
