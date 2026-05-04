extends LevelState
class_name GameOverState

var bad_ending_timeline: String = ""
var _instance: CanvasLayer = null

const MESSAGES = {
	"alcohol":   "[shake]Andrés no pudo ver la realidad a tiempo...[/shake]",
	"tabaco":    "[shake]Sofía siguió cargando ese peso hasta el final...[/shake]",
	"marihuana": "[shake]Lucas nunca encontró ese momento perfecto...[/shake]",
	"cocaina":   "[shake]Mateo creyó que podía solo. No podía.[/shake]"
}

func _init(ending_timeline: String) -> void:
	level_name = "GameOver"
	scene_path = "res://scenes/level_menu/End_game.tscn"
	bad_ending_timeline = ending_timeline

func enter():
	if preloaded_scene:
		_instance = preloaded_scene.instantiate()
		add_child(_instance)
	else:
		push_error("CRÍTICO: No hay escena precargada en GameOverState")
		return

	var label = _instance.get_node_or_null("Background/CenterContainer/Label")
	if label:
		var campaign = GameManager.current_campaign
		label.text = MESSAGES.get(campaign, "[shake]La conciencia se apagó...[/shake]")

	var anim = _instance.get_node_or_null("AnimationPlayer")
	if anim:
		await anim.animation_finished

	await get_tree().create_timer(3.0).timeout
	GameManager.change_level(StoryState.new(bad_ending_timeline, true))

func exit():
	if _instance and is_instance_valid(_instance):
		_instance.queue_free()
		_instance = null
