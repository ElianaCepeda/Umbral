extends Control

@onready var question_label = $VBoxContainer/AnswersContainer/QuestionLabel
@onready var answer1 = $VBoxContainer/AnswersContainer/Answer1
@onready var answer2 = $VBoxContainer/AnswersContainer/Answer2
@onready var answer3 = $VBoxContainer/AnswersContainer/Answer3
@onready var answer4 = $VBoxContainer/AnswersContainer/Answer4
@onready var score_label = $VBoxContainer/HBoxContainer/ScoreLabel

var correct_answer = 1

var questions = [
	{
		"question": "¿Pregunta ejemplo?",
		"answers": ["A)  SI", "B)  NO", "C)  NO", "D)  NO"],
		"correct": 1
	},
	{
		"question": "¿Pregunta ejemplo 2?",
		"answers": ["A)  NO", "B)  NO", "C)  SI", "D)  NO"],
		"correct": 3
	}
]

func _ready():
	score_label.text = str(GameManager.get_points())
	load_random_question()
	
	answer1.pressed.connect(func(): check_answer(1))
	answer2.pressed.connect(func(): check_answer(2))
	answer3.pressed.connect(func(): check_answer(3))
	answer4.pressed.connect(func(): check_answer(4))

func load_random_question():
	var q = questions[randi() % questions.size()]
	correct_answer = q["correct"]
	question_label.text = q["question"]
	answer1.text = q["answers"][0]
	answer2.text = q["answers"][1]
	answer3.text = q["answers"][2]
	answer4.text = q["answers"][3]

func check_answer(answer):
	if answer == correct_answer:
		GameManager.add_points(10)
		score_label.text = str(GameManager.get_points())
		print("Correcto! Puntos:", GameManager.get_points())
		load_random_question()  # carga otra pregunta automáticamente
	else:
		print("Incorrecto")
