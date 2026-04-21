extends Control
@onready var recover = $VBoxContainerMain/Recover
@onready var start = $VBoxContainerMain/Start
func _ready():
	start.pressed.connect(_go_to_game)
	recover.pressed.connect(_go_to_questions)
func _go_to_game():
	queue_free()
	# Le dices al LevelManager (Autoload) que inicie el primer nivel
	GameManager.change_level(TensionLevel.new())

func _go_to_questions():
	queue_free()
	GameManager.change_level(RecoveryState.new())
