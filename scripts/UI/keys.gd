extends Control

var key_names := ["MouseClick", "1", "Number2", "W", "A", "S", "D", "space"]
var running := false

func _ready() -> void:
	enter()

func enter() -> void:
	if running:
		return
	running = true
	_repetir_animaciones()

func _repetir_animaciones() -> void:
	while running:
		for key_name in key_names:
			var key_node = _find_node_recursive(self, key_name)
			if key_node:
				var anim_sprite = _find_animated_sprite(key_node)
				if anim_sprite and anim_sprite.sprite_frames.has_animation(key_name):
					anim_sprite.play(key_name)

		await get_tree().create_timer(0.5).timeout


func _find_animated_sprite(node: Node) -> AnimatedSprite2D:
	for child in node.get_children():
		if child is AnimatedSprite2D:
			return child
		
		var result = _find_animated_sprite(child)
		if result:
			return result
	
	return null


func _find_node_recursive(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	
	for child in node.get_children():
		var result = _find_node_recursive(child, target_name)
		if result:
			return result
	
	return null
