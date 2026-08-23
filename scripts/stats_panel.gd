class_name StatsPanel
extends Control

@export var stat_row_scene: PackedScene
@onready var container: VBoxContainer = $VBoxContainer

var rows: Dictionary = {}

func _ready():
	GameStatManager.stats_updated.connect(_on_stats_updated)
	_build_rows()
	_on_stats_updated(GameStatManager.current_average_stats)
	
func _build_rows():
	for stat_type in GameEnums.PersonalityStat.values():
		var row: StatRow = stat_row_scene.instantiate()
		container.add_child(row)
		rows[stat_type] = row
		
func _on_stats_updated(stats: Array[Stat]):
	for s in stats:
		if rows.has(s.stat):
			rows[s.stat].set_stat(s.stat, s.value)
