extends Node2D

@onready var level_generator: LevelGenerator = $LevelGenerator

func _ready():
	var current_data: LevelData = GameState.get_current_level()
	level_generator.order = current_data.order
	GameStatManager.reset_level_stats()
	GameStatManager.current_order = current_data.order
	level_generator.generate_level()
	AudioManager.on_location_switch(GameEnums.ActiveScreens.Work)

func _on_finish_level_pressed() -> void:
	var required_parts = 5
	var placed_parts :int = GameStatManager.current_body_parts.size()
	
	if placed_parts < required_parts:
		print("Cannot finish level: ", placed_parts, "/", required_parts, " body parts placed.")
		return
	GameStatManager.deliver_body()
	
	if GameState.is_last_level():
		# mit spiel beendet screen ersetzen?
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
	else:
		GameState.advance_level()
		get_tree().change_scene_to_file("res://scenes/evaluation.tscn")

func _evaluate_level():
	# hier bitte die score logik einbinden
	pass


func _on_help_buton_pressed() -> void:
	var current_data: LevelData = GameState.get_current_level()
	DialogueManager.show_dialogue_balloon(current_data.brief, "start")


func _on_tutorial_button_pressed() -> void:
	var resource = load("res://dialouge/tutorial_dialogue.dialogue")
	DialogueManager.show_dialogue_balloon(resource)
