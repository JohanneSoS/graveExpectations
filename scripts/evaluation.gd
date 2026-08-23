extends Control

@onready var score_label: Label = $UI/VBoxContainer/ScoreLabel
@onready var accuracy_label: Label = $UI/VBoxContainer/AccuracyLabel
@onready var continue_button: Button = $UI/VBoxContainer/ContinueButton

const RESULT_DIALOGUES := {
	"very_good": "res://dialouge/very_good_result.dialogue",
	"good": "res://dialouge/good_result.dialogue",
	"bad": "res://dialouge/bad_result.dialogue",
}

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
	var path: String
	if final_score >= 80.0:
		path = RESULT_DIALOGUES["very_good"]
	elif final_score >= 60.0:
		path = RESULT_DIALOGUES["good"]
	else:
		path = RESULT_DIALOGUES["bad"]

	var resource: DialogueResource = load(path)
	DialogueManager.show_dialogue_balloon(resource, "start")

func _on_continue_button_pressed() -> void:
	if GameState.is_last_level():
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	else:
		GameState.advance_level()
		get_tree().change_scene_to_file("res://scenes/boss_room.tscn")
