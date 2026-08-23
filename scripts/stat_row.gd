class_name StatRow
extends HBoxContainer

@onready var name_label: Label = $NameLabel
@onready var bar: ProgressBar = $ProgressBar
@onready var value_label: Label = $ValueLabel

func set_stat(stat_type: GameEnums.PersonalityStat, value: float):
	name_label.text = GameEnums.PersonalityStat.keys()[stat_type]
	bar.value = value
	value_label.text = "%d" % int(round(value))
