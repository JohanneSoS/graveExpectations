extends Control

@onready var score_label: Label = $ScoreLabel
@onready var accuracy_label: Label = $AccuracyLabel
@onready var continue_button: Button = $ContinueButton

var good_dialogue = "res://dialouge/good_result.dialogue"

func _ready() -> void:
	var final_score := GameStatManager.last_final_score
	var stat_scores := GameStatManager.last_stat_scores
	_show_result(final_score, stat_scores)

func _show_result(final_score: float, stat_scores: Dictionary) -> void:
	score_label.text = "%d%%" % roundi(final_score)

	if final_score >= 80.0:
		accuracy_label.text = "Very Good!"
	elif final_score >= 60.0:
		accuracy_label.text = "Good!"
	else:
		accuracy_label.text = "Bad..."
		
	_play_result_dialogue(final_score)

func _play_result_dialogue(final_score: float) -> void:
	if final_score >= 80.0:
		# Very good dialogue
		DialogueManager.play_dialogue("very_good")
	elif final_score >= 60.0:
		pass
		# dialogue add
	else:
		pass
		# add dialogue

func _on_continue_button_pressed() -> void:
	if GameState.is_last_level():
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	else:
		GameState.advance_level()
		get_tree().change_scene_to_file("res://scenes/boss_room.tscn")
