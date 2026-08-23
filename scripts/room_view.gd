extends Node2D

@onready var level_generator: LevelGenerator = $LevelGenerator

func _ready():
	var current_data: LevelData = GameState.get_current_level()
	level_generator.order = current_data.order
	level_generator.generate_level()

func _on_finish_level_pressed() -> void:
	_evaluate_level()
	
	if GameState.is_last_level():
		# mit spiel beendet screen ersetzen?
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	else:
		GameState.advance_level()
		get_tree().change_scene_to_file("res://scenes/boss_room.tscn") # beim neuladen wird die level-data aktualisiert mit dem nächsten level

func _evaluate_level():
	# hier bitte die score logik einbinden
	pass
