# scripts/levels/LevelState.gd
extends Node
class_name LevelState

# Referencia al gestor para poder cambiar de nivel desde adentro del nivel
var level_manager: Node 

func enter():
	# Se llama cuando el nivel inicia
	pass

func exit():
	# Se llama justo antes de cambiar a otro nivel
	pass
	
func update(_delta: float):
	# Equivalente al _process o _physics_process
	pass
