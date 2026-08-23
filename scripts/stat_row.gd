class_name StatRow
extends HBoxContainer

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var value_label: Label = $VBoxContainer/ValueLabel

func set_stat(stat_type: GameEnums.PersonalityStat, value: float):
	name_label.text = GameEnums.PersonalityStat.keys()[stat_type]
	bar.value = value
	value_label.text = "%d" % int(round(value))
