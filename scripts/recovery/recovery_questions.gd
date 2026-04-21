extends LevelState
class_name RecoveryQuestions

var question_label: Label
var answer1: Button
var answer2: Button
var answer3: Button
var answer4: Button
var scoreattack_label: Label
var scoredefense1_label: Label
var scoredefense2_label: Label
var mensaje_feedback: Label
var boton_terminado: Button

var attackpoints: int = 0
var defense1points : int = 0
var defense2points : int = 0
var first_question: int = 0 
var last_question: int = 6
var current_question_index: int = 0

var type:String
var correct_answer: int

var questions = [
	{
		"question": "¿Pregunta ejemplo? 1",
		"answers": ["A)  SI", "B)  NO", "C)  NO", "D)  NO"],
		"correct": 1,
		"type": "Attack"
	},
	{
		"question": "¿Pregunta ejemplo 2?",
		"answers": ["A)  NO", "B)  NO", "C)  SI", "D)  NO"],
		"correct": 3,
		"type":"Defense"
	},
	{
		"question": "¿Pregunta ejemplo 3?",
		"answers": ["A)  NO", "B)  NO", "C)  SI", "D)  NO"],
		"correct": 3,
		"type":"Defense"
	},
	{
		"question": "¿Pregunta ejemplo 4?",
		"answers": ["A)  NO", "B)  NO", "C)  SI", "D)  NO"],
		"correct": 3,
		"type":"Attack"
	},
	{
		"question": "¿Pregunta ejemplo 5?",
		"answers": ["A)  NO", "B)  NO", "C)  SI", "D)  NO"],
		"correct": 3,
		"type":"Defense"
	},
	{
		"question": "¿Pregunta ejemplo 6?",
		"answers": ["A)  NO", "B)  NO", "C)  SI", "D)  NO"],
		"correct": 3,
		"type":"Attack"
	}
]

func _init():
	level_name = "Recovery"
	scene_path = "res://scenes/recovery/question_room.tscn"
	timeline_name = ""
	enemy_type = ""

func enter():
	print("Entrando al minijuego de recuperación...")
	
	# 1. HACEMOS EL TRABAJO DEL PADRE: Instanciar y añadir la escena
	scene_instance = load(scene_path).instantiate()
	add_child(scene_instance)
	
	# 2. VINCULAMOS NUESTROS NODOS (ahora que scene_instance ya existe)
	question_label = scene_instance.get_node("VBoxContainer/AnswersContainer/QuestionLabel")
	answer1 = scene_instance.get_node("VBoxContainer/AnswersContainer/Answer1")
	answer2 = scene_instance.get_node("VBoxContainer/AnswersContainer/Answer2")
	answer3 = scene_instance.get_node("VBoxContainer/AnswersContainer/Answer3")
	answer4 = scene_instance.get_node("VBoxContainer/AnswersContainer/Answer4")
	scoreattack_label = scene_instance.get_node("VBoxContainer/HBoxContainer/LabelAtack")
	scoredefense1_label = scene_instance.get_node("VBoxContainer/HBoxContainer/LabelDefense1")
	scoredefense2_label = scene_instance.get_node("VBoxContainer/HBoxContainer/LabelDefense2")
	mensaje_feedback = scene_instance.get_node("VBoxContainer/LabelFeedback")
	boton_terminado = scene_instance.get_node("VBoxContainer/Terminado")
	
	# 3. LÓGICA DE PREGUNTAS
	boton_terminado.pressed.connect(_on_boton_terminado_pressed)
	boton_terminado.hide()
	
	scoreattack_label.text = str("Ataque: ", attackpoints)
	scoredefense1_label.text = str("Defensa1: ", defense1points)
	scoredefense2_label.text = str("Defensa2: ", defense2points)
	
	answer1.pressed.connect(check_answer.bind(1))
	answer2.pressed.connect(check_answer.bind(2))
	answer3.pressed.connect(check_answer.bind(3))
	answer4.pressed.connect(check_answer.bind(4))
	
	current_question_index = first_question
	load_question(current_question_index)

func setup(gm_first_question: int, gm_last_question: int):
	first_question = gm_first_question
	last_question = gm_last_question
	

func load_question(count:int):
	var q = questions[count]
	correct_answer = q["correct"]
	question_label.text = q["question"]
	answer1.text = q["answers"][0]
	answer2.text = q["answers"][1]
	answer3.text = q["answers"][2]
	answer4.text = q["answers"][3]
	type = q["type"]
	correct_answer= q["correct"]
	
	cambiar_estado_botones(false)
	

func check_answer(answer):
	cambiar_estado_botones(true)
	
	if answer == correct_answer:
		add_points()
	else:
		sub_points()
		
	scoreattack_label.text = str("Ataque: ",attackpoints)
	scoredefense1_label.text = str("Defensa1: ",defense1points)
	scoredefense2_label.text = str("Defensa2: ",defense2points)
	
	current_question_index += 1
	if current_question_index < last_question:
		load_question(current_question_index)
	else:
		print("¡Se acabaron las preguntas de esta ronda!")
		GameManager.attackpoints = attackpoints
		GameManager.defense1points = defense1points
		GameManager.defense2points = defense2points
		boton_terminado.show()

func add_points ():
	if type == "Attack":
		attackpoints +=5
		await mostrar_feedback_temporal("Respuesta Correcta tienes 5 puntos más de ataque", Color.DARK_GREEN)
		
	else:
		var select = randi_range(1, 2)
		if select == 1:
			defense1points+=2
			await mostrar_feedback_temporal("Respuesta Correcta tienes 2 puntos más de defensa 1", Color.DARK_GREEN)
			
		else:
			defense2points+=2
			await mostrar_feedback_temporal("Respuesta Correcta tienes 2 puntos más de defensa 2", Color.DARK_GREEN)
			

func sub_points ():
	if type == "Attack":
		attackpoints -=2
		await mostrar_feedback_temporal("Respuesta Incorrecta tienes 2 puntos menos de ataque", Color.DARK_RED)
		
	else:
		var select = randi_range(1, 2)
		if select == 1:
			defense1points-=1
			await mostrar_feedback_temporal("Respuesta Incorrecta tienes 1 punto menos de defensa 1", Color.DARK_RED)
			
		else:
			defense2points-=1
			await mostrar_feedback_temporal("Respuesta Incorrecta tienes 1 punto menos de defensa 2", Color.DARK_RED)
				


func mostrar_feedback_temporal(texto_mensaje: String, color: Color) -> void:
	# 1. Configuramos el texto y el color
	mensaje_feedback.text = texto_mensaje
	mensaje_feedback.add_theme_color_override("font_color", color)
	# 2. Hacemos visible el mensaje
	mensaje_feedback.show()
	# 3. Esperamos 2 segundos exactos
	await get_tree().create_timer(2.0).timeout
	# 4. Volvemos a ocultar el mensaje
	mensaje_feedback.hide()
	
func cambiar_estado_botones(deshabilitados: bool):
	answer1.disabled = deshabilitados
	answer2.disabled = deshabilitados
	answer3.disabled = deshabilitados
	answer4.disabled = deshabilitados

func _on_boton_terminado_pressed():
	# Guardamos el estado globalmente antes de irnos
	GameManager.preguntas_completadas = true
	GameManager.change_level(RecoveryState.new())
