extends Node
class_name EnemyFactory

# Pre-cargamos las escenas de los enemigos usando tus rutas
const ENEMY_SCENES = {
	"alcohol": preload("res://scenes/enemys/alcohol.tscn"),
	"ansiedad": preload("res://scenes/enemys/ansiedad.tscn"),
	"apetito": preload("res://scenes/enemys/apetito.tscn"),
	"asfixia": preload("res://scenes/enemys/asfixia.tscn"),
	"borroso": preload("res://scenes/enemys/borroso.tscn"),
	"cigarrillo": preload("res://scenes/enemys/cigarrillo.tscn"),
	"cirrosis": preload("res://scenes/enemys/cirrosis.tscn"),
	"cocaina": preload("res://scenes/enemys/cocaina.tscn"),
	"conjuntivitis": preload("res://scenes/enemys/conjuntivitis.tscn"),
	"convulsiones": preload("res://scenes/enemys/convulsiones.tscn"),
	"desbalance": preload("res://scenes/enemys/desbalance.tscn"),
	"euforia": preload("res://scenes/enemys/euforia.tscn"),
	"fatiga": preload ("res://scenes/enemys/fatiga.tscn"),
	"gastritis": preload ("res://scenes/enemys/gastritis.tscn"),
	"hipertension": preload ("res://scenes/enemys/hipertension.tscn"),
	"insomnio": preload ("res://scenes/enemys/insomnio.tscn"),
	"marihuana": preload ("res://scenes/enemys/marihuana.tscn"),
	"memoria": preload ("res://scenes/enemys/memoria.tscn"),
	"necrosis": preload ("res://scenes/enemys/necrosis.tscn"),
	"obstruccion": preload ("res://scenes/enemys/obstruccion.tscn"),
	"paranoide": preload("res://scenes/enemys/paranoide.tscn"),
	"taquicardia": preload ("res://scenes/enemys/taquicardia.tscn"),
	"tension": preload ("res://scenes/enemys/tension.tscn"),
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
