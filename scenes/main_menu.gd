extends Control

@onready var door = $VBoxContainer/ContentGroup/Brainholder/Door

@onready var btn_family = $VBoxContainer/ContentGroup/BtnRow/BtnFamily
@onready var btn_sympt = $VBoxContainer/ContentGroup/BtnRow/BtnSympt
@onready var btn_exit = $VBoxContainer/ContentGroup/BtnRow/BtnExit

func _ready() -> void:
	door.door_pressed.connect(_go_to_game)

	btn_family.pressed.connect(_go_to_recovery)
	btn_sympt.pressed.connect(_go_to_recovery)
	btn_exit.pressed.connect(_exit_game)

func _go_to_game() -> void:
	queue_free()
	GameManager.change_level(GastritisLevel.new())

func _go_to_recovery() -> void:
	queue_free()
	GameManager.change_level(RecoveryState.new())

func _exit_game() -> void:
	get_tree().quit()
