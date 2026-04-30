extends LevelState
class_name LevelMenuState

var back_button: Button
var book_animation: AnimatedSprite2D
var book_content: Control

var alcohol_panel: Control
var tobacco_panel: Control
var marijuana_panel: Control
var cocaine_panel: Control

var alcohol_color: Control
var tabaco_color: Control
var marihuana_color: Control
var cocaina_color: Control

var color_panels: Array = []

var play_alcohol = Button
var play_tabaco = Button
var play_marihuana = Button
var play_cocaina = Button 


# TODO traerlo desde la persistencia de datos 
var alcohol_unlocked : bool 
var tobacco_unlocked : bool
var marijuana_unlocked : bool
var cocaine_unlocked : bool


func _init() -> void:
	level_name = "LevelMenu"
	scene_path = "res://scenes/level_menu/level_menu.tscn"
	alcohol_unlocked = SaveManager.is_unlocked("alcohol")
	tobacco_unlocked = SaveManager.is_unlocked("tabaco")
	marijuana_unlocked = SaveManager.is_unlocked("marihuana")
	cocaine_unlocked = SaveManager.is_unlocked("cocaina")
	

func enter() -> void:
	print("Entrando al menú de selección de nivel...")

	if preloaded_scene:
		scene_instance = preloaded_scene.instantiate()
		add_child(scene_instance)
	else:
		push_error("CRÍTICO: No hay escena precargada en LevelMenuState")
		return

	back_button = scene_instance.get_node("Backbutton")
	book_animation = scene_instance.get_node("BookArea/BookHolder/AnimatedSprite2D")
	book_content = scene_instance.get_node("BookArea/BookHolder/BookContent")

	alcohol_panel = scene_instance.get_node("BookArea/BookHolder/BookContent/LeftPage/AlcoholPanel")
	tobacco_panel = scene_instance.get_node("BookArea/BookHolder/BookContent/LeftPage/TobaccoPanel")
	marijuana_panel = scene_instance.get_node("BookArea/BookHolder/BookContent/RightPage/MarijuanaPanel")
	cocaine_panel = scene_instance.get_node("BookArea/BookHolder/BookContent/RightPage/CocainePanel")

	alcohol_color = scene_instance.get_node("ColorAlcohol")
	tabaco_color = scene_instance.get_node("ColorTabaco")
	marihuana_color = scene_instance.get_node("ColorMarihuana")
	cocaina_color = scene_instance.get_node("ColorCocaina")
	
	play_alcohol = scene_instance.get_node("BookArea/BookHolder/BookContent/LeftPage/AlcoholPanel/IconsRow/Button")
	play_tabaco = scene_instance.get_node("BookArea/BookHolder/BookContent/LeftPage/TobaccoPanel/IconsRow/Button")
	play_cocaina = scene_instance.get_node("BookArea/BookHolder/BookContent/RightPage/CocainePanel/IconsRow/Button")
	play_marihuana = scene_instance.get_node("BookArea/BookHolder/BookContent/RightPage/MarijuanaPanel/IconsRow/Button")

	color_panels = [
		alcohol_color,
		tabaco_color,
		marihuana_color,
		cocaina_color
	]

	_ocultar_contenido_inicial()

	await _abrir_libro_y_mostrar_contenido()

	_config_buttons()
	_config_panel(alcohol_color, alcohol_panel, alcohol_unlocked)
	_config_panel(tabaco_color, tobacco_panel, tobacco_unlocked)
	_config_panel(marihuana_color, marijuana_panel, marijuana_unlocked)
	_config_panel(cocaina_color, cocaine_panel, cocaine_unlocked)


func _ocultar_contenido_inicial() -> void:
	book_content.hide()
	book_content.modulate.a = 0.0

	for color_panel in color_panels:
		color_panel.hide()
		color_panel.modulate.a = 0.0


func _abrir_libro_y_mostrar_contenido() -> void:
	book_animation.play("open")
	await book_animation.animation_finished

	book_content.show()

	for color_panel in color_panels:
		color_panel.show()

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(book_content, "modulate:a", 1.0, 0.25)

	for color_panel in color_panels:
		tween.tween_property(color_panel, "modulate:a", 1.0, 0.25)

	await tween.finished


func _config_buttons() -> void:
	back_button.pressed.connect(_go_to_main_menu)
	back_button.mouse_entered.connect(_hover_back_on)
	back_button.mouse_exited.connect(_hover_back_off)
	play_alcohol.pressed.connect(_go_to_Alcohol)
	play_alcohol.mouse_entered.connect(_hover_back_on)
	play_alcohol.mouse_exited.connect(_hover_back_off)
	play_tabaco.pressed.connect(_go_to_Tabaco)
	play_tabaco.mouse_entered.connect(_hover_back_on)
	play_tabaco.mouse_exited.connect(_hover_back_off)
	play_cocaina.pressed.connect(_go_to_Cocaina)
	play_cocaina.mouse_entered.connect(_hover_back_on)
	play_cocaina.mouse_exited.connect(_hover_back_off)
	play_marihuana.pressed.connect(_go_to_Marihuana)
	play_marihuana.mouse_entered.connect(_hover_back_on)
	play_marihuana.mouse_exited.connect(_hover_back_off)
	


func _hover_back_on() -> void:
	print("hover back on")
	back_button.get_node("NinePatchRect").modulate = Color(1.15, 1.10, 0.85)
	back_button.scale = Vector2(1.03, 1.03)

func _hover_back_off() -> void:
	back_button.get_node("NinePatchRect").modulate = Color.WHITE
	back_button.scale = Vector2.ONE


func _set_panel_color(color_panel: Control, unlocked: bool) -> void:
	color_panel.show()

	if unlocked:
		color_panel.modulate.a = 0.0
	else:
		color_panel.modulate.a = 1.0


func _config_panel(color_panel: Control, panel: Control, unlocked: bool) -> void:
	var f1 = panel.get_node("BtnRow/F1")
	var f2 = panel.get_node("BtnRow/F2")
	var f3 = panel.get_node("BtnRow/F3")
	var play_button = panel.get_node("IconsRow/Button")
	var pad = panel.get_node("IconsRow/Pad")

	_set_panel_color(color_panel, unlocked)

	_config_phase_button(f1, Color("#D8C08A"))
	_config_phase_button(f2, Color("#56C67F"))
	_config_phase_button(f3, Color("#B84A4A"))

	#play_button.mouse_entered.connect(func(): _hover_play_on(play_button))
	#play_button.mouse_exited.connect(func(): _hover_play_off(play_button))

	if unlocked:
		pad.hide()
		play_button.show()
		f1.disabled = false
		f2.disabled = false
		f3.disabled = false
	else:
		pad.show()
		play_button.hide()
		f1.disabled = true
		f2.disabled = true
		f3.disabled = true


func _config_phase_button(btn: Button, hover_color: Color) -> void:
	btn.mouse_entered.connect(func(): _hover_phase_on(btn, hover_color))
	btn.mouse_exited.connect(func(): _hover_phase_off(btn))


func _hover_phase_on(btn: Button, hover_color: Color) -> void:
	if btn.disabled:
		return

	btn.get_node("NinePatch").modulate = hover_color
	btn.scale = Vector2(1.04, 1.04)


func _hover_phase_off(btn: Button) -> void:
	btn.get_node("NinePatch").modulate = Color.WHITE
	btn.scale = Vector2.ONE


func _hover_play_on(btn: Button) -> void:
	btn.scale = Vector2(1.05, 1.05)
	btn.get_node("Label").modulate = Color("#56C67F")


func _hover_play_off(btn: Button) -> void:
	btn.scale = Vector2.ONE
	btn.get_node("Label").modulate = Color.WHITE



func _go_to_main_menu() -> void:
	GameManager.force_exit_to_main_menu()
	
func _go_to_Alcohol () -> void:
	GameManager.start_campaign("alcohol")
	
func _go_to_Tabaco () -> void:
	GameManager.start_campaign("tabaco")
	
func _go_to_Cocaina () -> void:
	GameManager.start_campaign("cocaina")

func _go_to_Marihuana () -> void:
	GameManager.start_campaign("marihuana")
