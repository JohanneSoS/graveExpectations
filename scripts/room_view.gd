extends Node2D

@onready var level_generator: LevelGenerator = $LevelGenerator

func _ready():
	var current_data: LevelData = GameState.get_current_level()
	level_generator.order = current_data.order
	level_generator.generate_level()
