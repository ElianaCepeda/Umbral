extends Control

@onready var question_label = $VBoxContainer/AnswersContainer/QuestionLabel
@onready var answer1 = $VBoxContainer/AnswersContainer/Answer1
@onready var answer2 = $VBoxContainer/AnswersContainer/Answer2
@onready var answer3 = $VBoxContainer/AnswersContainer/Answer3
@onready var answer4 = $VBoxContainer/AnswersContainer/Answer4
@onready var scoreattack_label = $VBoxContainer/HBoxContainer/ScoreLabel
@onready var scoredefense1_label = $VBoxContainer/HBoxContainer/ScoreLabel1
@onready var scoredefense2_label = $VBoxContainer/HBoxContainer/ScoreLabel2

var attackpoints: int = 0
var defense1points : int = 0
var defense2points : int = 0

var type:String

var correct_answer = 1

var questions = [
	{
		"question": "¿Pregunta ejemplo?",
		"answers": ["A)  SI", "B)  NO", "C)  NO", "D)  NO"],
		"correct": 1,
		"type": "Attack"
	},
	{
		"question": "¿Pregunta ejemplo 2?",
		"answers": ["A)  NO", "B)  NO", "C)  SI", "D)  NO"],
		"correct": 3,
		"type":"Defense"
	}
]

func _ready():
	scoreattack_label.text = str(GameManager.get_points())
	scoredefense1_label.text = str(GameManager.get_defense1points())
	scoredefense2_label.text = str(GameManager.get_defense2points())
	load_question(1)
	answer1.pressed.connect(func(): check_answer(1))
	answer2.pressed.connect(func(): check_answer(2))
	answer3.pressed.connect(func(): check_answer(3))
	answer4.pressed.connect(func(): check_answer(4))

func load_question(count:int):
	var q = questions[count]
	correct_answer = q["correct"]
	question_label.text = q["question"]
	answer1.text = q["answers"][0]
	answer2.text = q["answers"][1]
	answer3.text = q["answers"][2]
	answer4.text = q["answers"][3]
	type = q["type"]

func check_answer(answer):
	if answer == correct_answer:
		add_points(type) 
	else:
		sub_points(type)
	scoreattack_label.text = str(GameManager.get_points())
	scoredefense1_label.text = str(GameManager.get_defense1points())
	scoredefense2_label.text = str(GameManager.get_defense2points())
	print("Correcto! Puntos:", GameManager.get_points())
	load_question(GameManager.get_count())
	GameManager.set_count(GameManager.get_count()+1)

func add_points (type:String):
	if type == "Attack":
		attackpoints +=5
		GameManager.set_attackpoints(attackpoints)
	else:
		var select = randi_range(1, 2)
		if select == 1:
			defense1points+=2
			GameManager.set_defense1points(defense1points)
		else:
			defense2points+=2
			GameManager.set_defense2points(defense2points)


func sub_points ( type:String):
	if type == "Attack":
		attackpoints -=2
	else:
		var select = randi_range(1, 2)
		if select == 1:
			defense1points-=1
		else:
			defense2points-=1	
