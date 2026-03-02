extends Control
@onready var recover = $VBoxContainerMain/Button2
@onready var start = $VBoxContainerMain/Button
func _ready():
	start.pressed.connect(_go_to_game)
	recover.pressed.connect(_go_to_questions)
func _go_to_game():
	#get_tree().change_scene_to_file("res://scenes/levels/insomnio.tscn")
	get_tree().change_scene_to_file("res://scenes/levels/map.tscn")

func _go_to_questions():
	get_tree().change_scene_to_file("res://scenes/recovery/recovery_room.tscn")
