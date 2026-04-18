extends Control
@onready var recover = $VBoxContainerMain/Recover
@onready var start = $VBoxContainerMain/Start
func _ready():
	start.pressed.connect(_go_to_game)
	recover.pressed.connect(_go_to_questions)
func _go_to_game():
	queue_free()
	# Le dices al LevelManager (Autoload) que inicie el primer nivel
	GameManager.change_level(AnsiedadLevel.new())

func _go_to_questions():
	get_tree().change_scene_to_file("res://scenes/recovery/recovery_room.tscn")
