extends Node
class_name BossFightController

@export var minion_scenes: Array[PackedScene] = []
var boss_node: Node2D = null
var minions_spawned: bool = false

# Señal para avisarle al LevelState que el combate terminó
signal boss_defeated

func _ready():
	# Esperamos un momento a que el Spawner haga su trabajo
	await get_tree().create_timer(0.5).timeout
	_identify_boss()

func _identify_boss():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		boss_node = e
		boss_node.add_to_group("boss")
		
		# Configuramos las stats del jefe
		boss_node.health = 5000
		boss_node.speed = 60
		boss_node.comportamiento = 3 # Random
		break
		
	if boss_node:
		await get_tree().create_timer(2.0).timeout
		_spawn_minions()

func _spawn_minions():
	if minion_scenes.size() < 4: return
		
	var minions = []
	for scene in minion_scenes:
		var minion = scene.instantiate()
		var offset = Vector2(randf_range(-60, 60), randf_range(-60, 60))
		minion.global_position = boss_node.global_position + offset
		
		get_parent().call_deferred("add_child", minion)
		minions.append(minion)
		
	await get_tree().process_frame
	_assign_roles(minions)
	minions_spawned = true

func _assign_roles(minions: Array):
	# SÍNTOMA 1: EL PROTECTOR
	var protector = minions[0]
	protector.player = boss_node # Engañamos a su IA: Su "jugador" a perseguir es el jefee
	protector.comportamiento = 0 # Heurística (Constructor)
	protector.target_distance = 80.0
	
	# SÍNTOMA 2: EL AGRESOR
	var agresor = minions[1]
	agresor.comportamiento = 1 # Cazador (Embestidas)
	agresor.charge_probability = 0.8 # Súper agresivo
	agresor.speed = 150
	
	# SÍNTOMA 3: EL ACOSADOR
	var acosador = minions[2]
	acosador.comportamiento = 0 # Heurística
	acosador.target_distance = 180.0 # Se mantiene lejos del jugador real
	acosador.turn_penalty = 0.0 # Gira ágilmente para rodearte
	
	# SÍNTOMA 4: APOYA CON SU MOVIMIENTO POR DEFECTO

# Evaluamos la victoria del jefe localmente
func _process(_delta):
	if not minions_spawned: return
	
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	var boss_alive = false
	var minions_alive = 0
	
	for enemy in all_enemies:
		if enemy.is_in_group("boss"): boss_alive = true
		else: minions_alive += 1
			
	if not boss_alive or minions_alive == 0:
		set_process(false) # Apagamos este ciclo
		if boss_alive and is_instance_valid(boss_node):
			if boss_node.has_method("take_damage"):
				boss_node.take_damage(999999)
				
		# ¡EMITIMOS LA SEÑAL! El controlador ya hizo su trabajo.
		boss_defeated.emit()
