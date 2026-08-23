@tool
class_name SpawnArea
extends Node2D

@export var body_part_type: GameEnums.BodyPartType
@export var body_part_scene: PackedScene
@export var slot_count: int = 1
@export var spawn_count: int = 4
@export var area_size: Vector2 = Vector2(300, 200):
	set(value):
		area_size = value
		queue_redraw()

@export var min_distance: float = 80.0
@export var max_tilt_degrees: float = 15.0
@export var max_attempts: int = 30

const BODY_PART_TEXTURE_ROOT = "res://art/bodyparts"
var _texture_cache = {}

func _ready():
	if Engine.is_editor_hint():
		return

# nur damit wir die spawn areas im editor sehen können
func _draw():
	if not Engine.is_editor_hint():
		return
	var half = area_size / 2.0
	draw_rect(Rect2(-half, area_size), Color(1, 1, 0, 0.15), true)
	draw_rect(Rect2(-half, area_size), Color(1, 1, 0, 0.6), false, 2.0)

func spawn_with_guaranteed_solutions(solution_parts: Array[BodyPart]):
	var pool: Array[BodyPart] = solution_parts.duplicate()
	while pool.size() < spawn_count:
		pool.append(_generate_random_part())
	pool.shuffle()

	var placed_positions: Array[Vector2] = []
	for part in pool:
		var pos = _get_valid_local_position(placed_positions)
		placed_positions.append(pos)
		_spawn_instance(part, pos)

func _spawn_instance(part: BodyPart, local_pos: Vector2):
	var instance: BodyPart_Node = body_part_scene.instantiate()
	add_child(instance)
	instance.position = local_pos
	instance.rotation = deg_to_rad(randf_range(-max_tilt_degrees, max_tilt_degrees))
	instance.body_part_data = part

	var texture = _get_random_texture()
	if texture:
		var sprite = instance.get_node("Sprite2D")
		sprite.texture = texture
		instance.update_collision_shape()

func _get_random_texture() -> Texture2D:
	var folder := _get_texture_folder()
	if folder.is_empty():
		return null

	if not _texture_cache.has(folder):
		_texture_cache[folder] = _load_textures_from_folder(folder)
	var textures: Array[Texture2D] = _texture_cache[folder]
	if textures.is_empty():
		return null
	return textures.pick_random()

# haben wir links und rechts texturen?
func _get_texture_folder() -> String:
	match body_part_type:
		GameEnums.BodyPartType.LEFT_ARM:
			return BODY_PART_TEXTURE_ROOT + "/arms"
		GameEnums.BodyPartType.RIGHT_ARM:
			return BODY_PART_TEXTURE_ROOT + "/arms"
		GameEnums.BodyPartType.LEFT_LEG:
			return BODY_PART_TEXTURE_ROOT + "/legs"
		GameEnums.BodyPartType.RIGHT_LEG:
			return BODY_PART_TEXTURE_ROOT + "/legs"
		GameEnums.BodyPartType.TORSO:
			return BODY_PART_TEXTURE_ROOT + "/torsos"
		GameEnums.BodyPartType.HEAD:
			return BODY_PART_TEXTURE_ROOT + "/heads"
		_:
			return ""
	
func _load_textures_from_folder(folder: String) -> Array[Texture2D]:
	var textures: Array[Texture2D] = []
	var dir := DirAccess.open(folder)

	if dir == null:
		push_warning("invalid body part folder: " + folder)
		return textures

	dir.list_dir_begin()

	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			var extension := file_name.get_extension().to_lower()
			if extension in ["png"]:
				var path := folder + "/" + file_name
				var texture := ResourceLoader.load(path, "Texture2D") as Texture2D
				
				if texture:
					textures.append(texture)
					
		file_name = dir.get_next()
	dir.list_dir_end()
	return textures
	
func _generate_random_part() -> BodyPart:
	var part := BodyPart.new()
	part.body_part_type = body_part_type
	
	var target_stat_count := randi_range(1, 4)
	var stat_array: Array[Stat] = []
	for i in target_stat_count:
		var s := Stat.new()
		s.stat = GameEnums.PersonalityStat.values().pick_random()
		s.value = randf_range(0.0, 100.0)
		stat_array.append(s)
	part.stats = stat_array
	return part
	
func _get_valid_local_position(existing: Array[Vector2]) -> Vector2:
	var half = area_size / 2.0
	var candidate = Vector2.ZERO
	for attempt in max_attempts:
		candidate = Vector2(
			randf_range(-half.x, half.x),
			randf_range(-half.y, half.y)
		)
		var valid = true
		for pos in existing:
			if candidate.distance_to(pos) < min_distance:
				valid = false
				break
		if valid:
			return candidate
	return candidate
