class_name BodyPartTooltip
extends PanelContainer

@onready var type_label: Label = $MarginContainer/VBoxContainer/TypeLabel
@onready var stats_container: VBoxContainer = $MarginContainer/VBoxContainer/StatsContainer

func show_body_part(part: BodyPart) -> void:
	_clear_stats()
	type_label.text = _get_body_part_type_name(part.body_part_type)
	
	for stat in part.stats:
		var label := Label.new()
		label.text = "%s    %.0f" % [
			_get_stat_name(stat.stat),
			stat.value
		]
		stats_container.add_child(label)
	show()
	
	global_position = get_viewport().get_mouse_position() + Vector2(16, 16)
	
func _clear_stats() -> void:
	for child in stats_container.get_children():
		child.queue_free()
		
func _get_body_part_type_name(type: GameEnums.BodyPartType) -> String:
	return GameEnums.BodyPartType.keys()[type]
	
func _get_stat_name(stat: GameEnums.PersonalityStat) -> String:
	return GameEnums.PersonalityStat.keys()[stat]
