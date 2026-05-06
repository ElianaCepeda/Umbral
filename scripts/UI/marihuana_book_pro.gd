extends BookProtectiveBaseState
class_name MarihuanaBookProtectiveState

func _init() -> void:
	level_name = "Book marihuana"
	scene_path = "res://scenes/UI/MarihuanaBook.tscn"
	page_data = {
		"descriptions": [
			"En esta conducta se evalúa la importancia de dormir y recuperar el descanso, porque la combinación entre consumo y falta de sueño puede aumentar la ansiedad, la paranoia y la dificultad para responder con claridad.",
			"En esta conducta se evalúa el control de dosis como una forma de reconocer límites, disminuir la intensidad de efectos adversos y evitar que el consumo aumente la confusión, la alteración perceptiva o la pérdida de control.",
			"En esta conducta se evalúa evitar mezclar con alcohol, ya que la combinación puede intensificar la alteración corporal y mental, aumentando riesgos como desorientación, náuseas, ansiedad o dificultad para tomar decisiones."
		],
		"titles": ["DORMIR", "CONTROL DE DOSIS", "NO MEZCLAR ALCOHOL"],
		"images": [
			preload("res://assets/characterAttacks/Dormir.png"),
			preload("res://assets/defenses/Dosis-Marihuana.png"),
			preload("res://assets/defenses/SinAlcohol-Marihuana.png")
		]
	}
