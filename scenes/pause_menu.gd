extends CanvasLayer

@onready var main_menu_btn = $CenterContainer/PausePanel/MarginContainer/Content/ButtonsContainer/MainMenu
@onready var restart_phase_btn = $CenterContainer/PausePanel/MarginContainer/Content/ButtonsContainer/RePhase
@onready var restart_level_btn = $CenterContainer/PausePanel/MarginContainer/Content/ButtonsContainer/ReLevel
@onready var continue_btn = $CenterContainer/PausePanel/MarginContainer/Content/ButtonsContainer/Continue
@onready var exit_btn = $CenterContainer/PausePanel/MarginContainer/Content/ButtonsContainer/Exit

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

	main_menu_btn.pressed.connect(_on_main_menu_pressed)
	restart_phase_btn.pressed.connect(_on_restart_phase_pressed)
	restart_level_btn.pressed.connect(_on_restart_level_pressed)
	continue_btn.pressed.connect(_on_continue_pressed)
	exit_btn.pressed.connect(_on_exit_pressed)

	for btn in [continue_btn, restart_phase_btn, restart_level_btn, main_menu_btn, exit_btn]:
		_config_hover(btn)

func _config_hover(btn: Button) -> void:
	btn.mouse_entered.connect(func(): _hover_on(btn))
	btn.mouse_exited.connect(func(): _hover_off(btn))

func _hover_on(btn: Button) -> void:
	if btn.has_node("NinePatchRect"):
		btn.get_node("NinePatchRect").modulate = Color(1.15, 1.10, 0.85)
	btn.scale = Vector2(1.03, 1.03)

func _hover_off(btn: Button) -> void:
	if btn.has_node("NinePatchRect"):
		btn.get_node("NinePatchRect").modulate = Color.WHITE
	btn.scale = Vector2.ONE

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if GameManager.current_level != null:
			toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused

func _on_continue_pressed():
	get_tree().paused = false
	hide()

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().quit()

func _on_main_menu_pressed():
	get_tree().paused = false
	hide()

	

func _on_restart_phase_pressed():
	get_tree().paused = false
	hide()

	if GameManager.current_level:
		var efectos = get_tree().get_nodes_in_group("efectos_enemigos")
		for efecto in efectos:
			efecto.queue_free()

		if GameManager.current_level.has_method("exit"):
			GameManager.current_level.exit()

		await get_tree().process_frame

		if GameManager.current_level.has_method("enter"):
			GameManager.current_level.enter()
	else:
		printerr("No se ha asignado un current_level en GameManager")

func _on_restart_level_pressed():
	print("El botón 'Reiniciar nivel' presionado (Aún sin configurar)")
