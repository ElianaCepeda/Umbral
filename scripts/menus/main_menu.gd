extends Control

@onready var door = $VBoxContainer/ContentGroup/Brainholder/Door

@onready var btn_family = $VBoxContainer/ContentGroup/BtnRow/BtnFamily
@onready var btn_sympt = $VBoxContainer/ContentGroup/BtnRow/BtnSympt
@onready var btn_exit = $VBoxContainer/ContentGroup/BtnRow/BtnExit

func _ready() -> void:
	door.door_pressed.connect(_go_to_game)
	btn_family.pressed.connect(_go_to_recovery)
	btn_sympt.pressed.connect(_go_to_levels)
	btn_exit.pressed.connect(_exit_game)

	_config_hover(btn_family)
	_config_hover(btn_sympt)
	_config_hover(btn_exit)


func _config_hover(btn: TextureButton) -> void:
	btn.mouse_entered.connect(func(): _hover_on(btn))
	btn.mouse_exited.connect(func(): _hover_off(btn))


func _hover_on(btn: TextureButton) -> void:
	btn.get_node("NinePatchRect").modulate = Color(1.15, 1.10, 0.85)
	btn.scale = Vector2(1.04, 1.04)


func _hover_off(btn: TextureButton) -> void:
	btn.get_node("NinePatchRect").modulate = Color(1, 1, 1)
	btn.scale = Vector2(1, 1)


func _go_to_game() -> void:
	var ultima_campana = SaveManager.get_latest_unlocked_campaign()
	print("1. Botón de inicio presionado. Enviando a: ", ultima_campana)
	
	GameManager.start_campaign(ultima_campana)
	hide()


func _go_to_recovery() -> void:
	queue_free()
	GameManager.change_level(RecoveryState.new())
	
func _go_to_levels() -> void:
	queue_free()
	GameManager.change_level(LevelMenuState.new())


func _exit_game() -> void:
	get_tree().quit()
