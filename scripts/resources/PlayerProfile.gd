# res://scripts/resources/PlayerProfile.gd
extends Resource
class_name PlayerProfile

@export var current_consciousness: int = 100
@export var max_consciousness: int = 100

# Tu nueva estructura de conductas protectoras
@export var attack_points: int = 0
@export var defense1_unlocked: bool = false
@export var defense2_unlocked: bool = false

# Los 4 niveles principales. Guardamos cuáles están desbloqueados.
@export var unlocked_levels: Array[String] = ["alcohol"] 

func reset_to_default() -> void:
	current_consciousness = 100
	max_consciousness = 100
	attack_points = 0
	defense1_unlocked = false
	defense2_unlocked = false
