extends Control

@onready var back_button = $Backbutton

@onready var alcohol_panel = $BookArea/BookHolder/BookContent/LeftPage/AlcoholPanel
@onready var tobacco_panel = $BookArea/BookHolder/BookContent/LeftPage/TobaccoPanel
@onready var marijuana_panel = $BookArea/BookHolder/BookContent/RightPage/MarijuanaPanel
@onready var cocaine_panel = $BookArea/BookHolder/BookContent/RightPage/CocainePanel

@onready var alcohol_color = $ColorAlcohol
@onready var marihuana_color = $ColorMarihuana
@onready var tabaco_color = $ColorTabaco
@onready var cocaina_color = $ColorCocaina

var alcohol_unlocked := true
var tobacco_unlocked := true
var marijuana_unlocked := false
var cocaine_unlocked := true


func _ready() -> void:
	_config_back_button()
	_config_panel(alcohol_color, alcohol_panel, alcohol_unlocked)
	_config_panel(tabaco_color, tobacco_panel, tobacco_unlocked)
	_config_panel(marihuana_color, marijuana_panel, marijuana_unlocked)
	_config_panel(cocaina_color, cocaine_panel, cocaine_unlocked)
	


func _config_back_button() -> void:
	back_button.pressed.connect(_go_to_main_menu)
	back_button.mouse_entered.connect(func(): _hover_back_on())
	back_button.mouse_exited.connect(func(): _hover_back_off())


func _hover_back_on() -> void:
	back_button.get_node("NinePatchRect").modulate = Color(1.15, 1.10, 0.85)
	back_button.scale = Vector2(1.03, 1.03)


func _hover_back_off() -> void:
	back_button.get_node("NinePatchRect").modulate = Color.WHITE
	back_button.scale = Vector2.ONE

func _set_panel_color(color_panel: Control, unlocked: bool) -> void:
	if unlocked:
		color_panel.show()
		color_panel.modulate.a = 0.0
	else:
		color_panel.show()
		color_panel.modulate.a = 1.0

func _config_panel( color:Control, panel: Control, unlocked: bool) -> void:
	var f1 = panel.get_node("BtnRow/F1")
	var f2 = panel.get_node("BtnRow/F2")
	var f3 = panel.get_node("BtnRow/F3")
	var play_button = panel.get_node("IconsRow/Button")
	play_button.mouse_entered.connect(func(): _hover_play_on(play_button))
	play_button.mouse_exited.connect(func(): _hover_play_off(play_button))
	var pad = panel.get_node("IconsRow/Pad")
	_set_panel_color(color, unlocked)
	

	_config_phase_button(f1, Color("#D8C08A")) # hueso
	_config_phase_button(f2, Color("#56C67F")) # verde
	_config_phase_button(f3, Color("#B84A4A")) # rojo

	if unlocked:
		pad.hide()
		play_button.show()
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


func _hover_button(btn: Button, color: Color) -> void:
	btn.get_node("NinePatch").modulate = color

func _hover_play_on(btn: Button) -> void:
	btn.scale = Vector2(1.05, 1.05)
	btn.get_node("Label").modulate = Color("#56C67F")


func _hover_play_off(btn: Button) -> void:
	btn.scale = Vector2.ONE
	btn.get_node("Label").modulate = Color.WHITE

func _go_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
