extends CanvasLayer

# Referencias a los botones de la interfaz
@onready var main_menu_btn = $ColorRect/PanelContainer/VBoxContainer/MainMenuBtn
@onready var restart_phase_btn = $ColorRect/PanelContainer/VBoxContainer/RestartPhaseBtn
@onready var restart_level_btn = $ColorRect/PanelContainer/VBoxContainer/RestartLevelBtn

func _ready():
	# Nos aseguramos de que el menú empiece oculto
	hide()
	
	# Conectamos las señales "pressed" de los botones por código
	main_menu_btn.pressed.connect(_on_main_menu_pressed)
	restart_phase_btn.pressed.connect(_on_restart_phase_pressed)
	restart_level_btn.pressed.connect(_on_restart_level_pressed)

func _input(event):
	# "ui_cancel" es la acción que Godot asocia a la tecla Escape por defecto
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	var is_paused = get_tree().paused
	get_tree().paused = !is_paused
	
	if get_tree().paused:
		show()
	else:
		hide()

func _on_main_menu_pressed():
	# 1. Quitamos la pausa antes de salir para que el resto del juego fluya
	get_tree().paused = false
	hide()
	
	# 2. Llamamos al método game_over del GameManager
	if GameManager.has_method("game_over"):
		GameManager.game_over()
	else:
		printerr("Asegúrate de que GameManager tiene un método llamado 'game_over'")

func _on_restart_phase_pressed():
	get_tree().paused = false
	hide()
	
	if GameManager.current_level:
		# 1. Limpiamos cualquier shader/efecto
		var efectos = get_tree().get_nodes_in_group("efectos_enemigos")
		for efecto in efectos:
			efecto.queue_free()
			
		# 2. Le decimos al nivel actual que limpie y borre sus cosas viejas
		if GameManager.current_level.has_method("exit"):
			GameManager.current_level.exit()
			
		# 3. Esperamos un frame para que Godot termine de destruir al jugador viejo en la memoria
		await get_tree().process_frame
		
		# 4. Volvemos a iniciar el estado limpio
		if GameManager.current_level.has_method("enter"):
			GameManager.current_level.enter()
	else:
		printerr("No se ha asignado un current_level en GameManager")


func _on_restart_level_pressed():
	# Este botón aún no hace nada, tal como se solicitó
	print("El botón 'Reiniciar nivel' presionado (Aún sin configurar)")
