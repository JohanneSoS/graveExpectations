extends Node2D

func _ready():
	var current_data: LevelData = GameState.get_current_level()
	print("current_data: ", current_data)
	print("dialogue_resource: ", current_data.dialogue)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.show_dialogue_balloon(current_data.dialogue, "start")
	AudioManager.on_location_switch(GameEnums.ActiveScreens.Office)
	
func _on_dialogue_ended(_resource: DialogueResource):
	print("dialoue ended trigegred")
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	get_tree().change_scene_to_file("res://scenes/work_room.tscn")
