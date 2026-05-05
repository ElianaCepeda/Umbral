extends StaticBody2D
class_name DestructibleObject

@export var health: int = 1
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


var is_destroyed: bool = false

func take_damage(amount: int) -> void:
	if is_destroyed:
		return
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	is_destroyed = true
	collision_shape.disabled = true
	animated_sprite.play("destroy")
	await animated_sprite.animation_finished
	queue_free()
