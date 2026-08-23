extends Control

func _on_start_button_pressed():
	GameState.current_level_index = 0
	# get_tree().change_scene_to_file("res://scenes/boss_room.tscn")
	get_tree().change_scene_to_file("res://scenes/boss_room.tscn")
