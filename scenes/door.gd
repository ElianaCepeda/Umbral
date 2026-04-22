extends Node2D

signal door_pressed

@onready var anim = $AnimatedSprite2D
@onready var button = $DoorBtn

func _ready() -> void:
	anim.stop()
	anim.frame = 0

func _on_door_btn_mouse_entered() -> void:
	anim.play("open")

func _on_door_btn_mouse_exited() -> void:
	anim.play_backwards("open")

func _on_door_btn_pressed() -> void:
	door_pressed.emit()
