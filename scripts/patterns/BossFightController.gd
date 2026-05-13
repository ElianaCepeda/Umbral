extends Node
class_name BossFightController
var spawn_timer: Timer
# --- CONFIGURACIÓN DE SÍNTOMAS ---
@export_group("Protector (Rodea al jefe)")
@export var protector_scene: PackedScene
@export var protector_amount: int = 1

@export_group("Aggressor (Embestidas)")
@export var aggressor_scene: PackedScene
@export var aggressor_amount: int = 1

@export_group("Stalker (Rodea al jugador)")
@export var stalker_scene: PackedScene
@export var stalker_amount: int = 1

@export_group("Support (Expansivo)")
@export var support_scene: PackedScene
@export var support_amount: int = 1

var boss_node: Node2D = null
var minions_spawned: bool = false

signal boss_defeated

func _ready():
	call_deferred("_setup_boss")

func _setup_boss():
	print("Esperando aparición del boss...")

	while not boss_node:
		_identify_boss()

		if not boss_node:
			await get_tree().process_frame

	print("Boss encontrado correctamente")

	spawn_timer = Timer.new()
	spawn_timer.wait_time = 15.0
	spawn_timer.autostart = false
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	add_child(spawn_timer)

	print("Spawneando minions")

	_spawn_minions()

	minions_spawned = true

	spawn_timer.start()

	print("Sistema del boss iniciado")

func _on_spawn_timer_timeout():
	if not is_instance_valid(boss_node):
		spawn_timer.stop()
		return
	
	print("Spawneando nueva oleada")
	
	_spawn_minions()
func _identify_boss():
	var enemies = get_tree().get_nodes_in_group("enemy")

	print("Enemigos encontrados: ", enemies.size())

	if enemies.is_empty():
		return

	boss_node = enemies[0]

	boss_node.add_to_group("boss")

	boss_node.health = 350
	boss_node.speed = 60
	boss_node.comportamiento = 3
	boss_node.z_index = 10

	print("Boss configurado")

func _spawn_minions():
	# Llamamos a nuestra nueva función por cada rol
	_spawn_and_assign(protector_scene, protector_amount, "protector")
	_spawn_and_assign(aggressor_scene, aggressor_amount, "aggressor")
	_spawn_and_assign(stalker_scene, stalker_amount, "stalker")
	_spawn_and_assign(support_scene, support_amount, "support")
	
	minions_spawned = true
	spawn_timer.start()

# NUEVA FUNCIÓN: Instancia la cantidad solicitada y les inyecta su rol
func _spawn_and_assign(scene: PackedScene, amount: int, role: String):
	if not scene or amount <= 0: 
		return
	
	for i in range(amount):
		var minion = scene.instantiate()
		var offset = Vector2(randf_range(-100, 100), randf_range(-100, 100))
		minion.global_position = boss_node.global_position + offset
		
		get_parent().add_child(minion)
		
		match role:
			"protector":
				minion.player = boss_node 
				minion.comportamiento = 0 
				minion.target_distance = 80.0
			"aggressor":
				minion.comportamiento = 1 
				minion.charge_probability = 0.8 
				minion.speed = 150
			"stalker":
				minion.comportamiento = 0 
				minion.target_distance = 180.0 
				minion.turn_penalty = 0.0 
			"support":
				pass

func _process(_delta):
	if not minions_spawned: return
	
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	var boss_alive = false
	var minions_alive = 0
	
	for enemy in all_enemies:
		if enemy.is_in_group("boss"): boss_alive = true
		else: minions_alive += 1
			
	if not boss_alive:
		set_process(false) 
		if boss_alive and is_instance_valid(boss_node):
			if boss_node.has_method("take_damage"):
				boss_node.take_damage(999999)
		
		for enemy in all_enemies:
			if is_instance_valid(enemy):
				if enemy.has_method("die"):
					enemy.die()
				else:
					enemy.queue_free()
		boss_defeated.emit()
