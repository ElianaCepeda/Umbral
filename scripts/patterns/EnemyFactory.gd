extends Node
class_name EnemyFactory

# Pre-cargamos las escenas de los enemigos usando tus rutas
const ENEMY_SCENES = {
	"gastritis": preload("res://scenes/enemys/gastritis.tscn"),
	"insomnia": preload("res://scenes/enemys/insomnia.tscn"),
	"taquicardia": preload("res://scenes/enemys/taquicardia.tscn"),
	"alcohol": preload("res://scenes/enemys/alcohol.tscn")
	
}

# Esta función estática crea el enemigo y lo devuelve
static func create_enemy(enemy_type: String, spawn_position: Vector2) -> Node2D:
	if ENEMY_SCENES.has(enemy_type):
		var enemy_instance = ENEMY_SCENES[enemy_type].instantiate()
		enemy_instance.position = spawn_position
		return enemy_instance
	else:
		push_error("El tipo de enemigo '" + enemy_type + "' no existe en el Factory.")
		return null
