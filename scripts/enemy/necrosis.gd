extends EnemyBase

@export var poison_scene: PackedScene = preload("res://scenes/attacks/veneno.tscn")
@onready var poison_timer: Timer = $PoisonTimer

@export var drop_time: float = 3.0
@export var wait_time: float = 2.0

func _ready():
	# Definimos atributos específicos
	speed = 120
	health = 5
	points = 10
	collision_damage = 1
	damage_color = Color.GREEN
	
	super._ready() # Inicializa la lógica base
	
	if poison_timer:
		poison_timer.timeout.connect(leave_trail)
		start_poison_cycle()

func start_poison_cycle():
	poison_timer.start(0.005) 
	
	await get_tree().create_timer(drop_time).timeout
	poison_timer.stop()
	
	await get_tree().create_timer(wait_time).timeout
	start_poison_cycle()

func leave_trail():
	if poison_scene:
		var new_poison = poison_scene.instantiate()
		new_poison.global_position = global_position
		get_parent().call_deferred("add_child", new_poison)
