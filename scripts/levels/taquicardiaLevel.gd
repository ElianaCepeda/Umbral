extends Node2D

@export var timeline_name: String = "res://dialogues/illDescription/taquicardiaDescription.dtl"
@onready var fondo_custom = $FondoDialogo

func _ready():
	# 1. Iniciamos el diálogo
	fondo_custom.show()
	var layout = Dialogic.start(timeline_name)
	
	# 2. FORZAR que la interfaz ignore la pausa
	if layout:
		layout.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# 3. FORZAR que el manejador de inputs de Dialogic ignore la pausa
	# Esto es vital para que detecte el 'Enter' o el 'Click'
	Dialogic.Inputs.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# 4. Ahora sí, pausamos el juego
	get_tree().paused = true
	
	# 5. Conectamos la señal para reanudar
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_timeline_ended():
	# 1. Desconectamos y quitamos pausa
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	get_tree().paused = false
	fondo_custom.hide()
	
	# 2. Buscamos al jugador y le pedimos que muestre la barra
	# Asegúrate de que el nombre del nodo sea "Player" o como lo tengas en tu árbol
	if has_node("Player"): 
		$Player.mostrar_interfaz()
	
	print("¡Barra de consciencia activada!")
	
	get_tree().paused = false
	print("¡El diálogo terminó, el juego comienza!")
