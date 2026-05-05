extends LevelState
class_name BookProtectiveBaseState


var page_data: Dictionary = {}
var exit_button: TextureButton
var book_sprite: AnimatedSprite2D
var book_content: Control

var description_labels: Array[Label] = []
var title_labels: Array[Label] = []
var image_rects: Array[TextureRect] = []

func enter() -> void:
	print("Entrando al libro: " + level_name)

	if preloaded_scene:
		scene_instance = preloaded_scene.instantiate()
		add_child(scene_instance)
	else:
		push_error("CRÍTICO: No hay escena precargada en " + level_name)
		return

	_get_book_nodes()
	exit_button.pressed.connect(_on_exit_pressed)

	book_content.hide()

	book_sprite.play("pass")
	await book_sprite.animation_finished

	update_page_content()
	book_content.show()

func _on_exit_pressed() -> void:
	GameManager.advance_campaign_flow()
	
func _get_book_nodes() -> void:
	book_sprite = scene_instance.get_node("Control/CenterContainer/Bookholder/AnimatedSprite2D")
	book_content = scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent")

	description_labels = [
		scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent/Left/VBoxContainer/Desc1/MarginContainer/Description1"),
		scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent/Left/VBoxContainer/Desc2/MarginContainer/Description2"),
		scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent/Left/VBoxContainer/Desc3/MarginContainer/Description3")
	]

	title_labels = [
		scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent/Right/VBoxContainer/Cond1/Control/NinePatchRect/Conducta1"),
		scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent/Right/VBoxContainer/Cond2/Control/NinePatchRect/Conducta2"),
		scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent/Right/VBoxContainer/Cond3/Control/NinePatchRect/Conducta3")
	]

	image_rects = [
		scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent/Right/VBoxContainer/Cond1/Img1"),
		scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent/Right/VBoxContainer/Cond2/Img2"),
		scene_instance.get_node("Control/CenterContainer/Bookholder/BookContent/Right/VBoxContainer/Cond3/Img3")
	]


func update_page_content() -> void:
	if page_data.is_empty():
		push_error("No se configuró page_data en " + level_name)
		return

	for i in range(3):
		description_labels[i].text = page_data["descriptions"][i]
		title_labels[i].text = page_data["titles"][i]
		image_rects[i].texture = page_data["images"][i]


func exit() -> void:
	super.exit()
