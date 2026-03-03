extends Area2D

@onready var timer_desaparicion = $DesaparecerTimer
@onready var timer_danio = $DanioTimer
@export var danio = 1

func _ready():
	timer_desaparicion.timeout.connect(queue_free)
	timer_desaparicion.start(3.0)
	
	timer_danio.timeout.connect(_hacer_danio_periodico)
	timer_danio.start() 


func _hacer_danio_periodico():

	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("jugador"):
			if body.has_method("recibir_danio"):
				body.recibir_danio(danio)
