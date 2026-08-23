class_name BodyPart_Node
extends Node2D

var current_socket:DropSocket = null
var draggable = false
var is_hovered = false
var is_dragging = false
var is_inside_dropable = false
var body_ref
var initial_pos: Vector2
var initial_rot: float
var drag_offset: Vector2

var candidate_sockets: Array[DropSocket] = []

const COLLISION_MARGIN = 8.0

@export var body_part_data: BodyPart
@onready var sprite = $Sprite2D
@onready var collision_shape = $Area2D/CollisionShape2D
@export var part_scale = 0.5


# Gameplay Bahaviour
func _ready():
	update_collision_shape()
	
func _process(_delta):
	if not is_dragging:
		if StateManager.is_dragging:
			return

		if not draggable:
			return

		if Input.is_action_just_pressed("click"):
			_start_drag()

		return
	
	if Input.is_action_just_released("click"):
		_finish_drag()
		return

	if Input.is_action_pressed("click"):
		global_position = get_global_mouse_position() - drag_offset
		
func _start_drag():
	if StateManager.is_dragging:
		return

	StateManager.is_dragging = true
	is_dragging = true

	initial_pos = global_position
	initial_rot = global_rotation
	drag_offset = get_global_mouse_position() - global_position

	if current_socket:
		current_socket.clear_part()
		current_socket = null

		if GameStatManager.current_body_parts.has(body_part_data):
			GameStatManager.current_body_parts.erase(body_part_data)
			GameStatManager.update_current_body_stats()
	
	AudioManager.play_pitch_randomized_OneShot(AudioManager.drag_bodypart)


func _finish_drag():
	is_dragging = false
	StateManager.is_dragging = false

	var socket := _get_best_socket()

	if socket != null and socket.occupied_part == null:
		_drop_into_socket(socket)
		return

	if _is_over_spawn_area():
		_return_to_spawn_area()
		return

	_return_to_previous_position()

func _drop_into_socket(socket: DropSocket):
	current_socket = socket
	socket.assign_part(self)

	var tween := get_tree().create_tween()
	tween.set_parallel(false)

	tween.tween_property(
		self,
		"global_position",
		socket.global_position,
		0.2
	).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"global_rotation",
		socket.global_rotation,
		0.2
	).set_ease(Tween.EASE_OUT)

	if not GameStatManager.current_body_parts.has(body_part_data):
		GameStatManager.current_body_parts.append(body_part_data)

		print("ADDED BODY PART: ", body_part_data)
		print("TOTAL BODY PARTS: ", GameStatManager.current_body_parts.size())

	AudioManager.play_pitch_randomized_OneShot(AudioManager.drop_bodypoart)
	GameStatManager.update_current_body_stats()
		

	GameStatManager.update_current_body_stats()


func _return_to_previous_position():
	var tween := get_tree().create_tween()

	tween.tween_property(
		self,
		"global_position",
		initial_pos,
		0.2
	).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"global_rotation",
		initial_rot,
		0.2
	).set_ease(Tween.EASE_OUT)


func _return_to_spawn_area():
	current_socket = null

	var spawn_area := _get_spawn_area()

	if spawn_area == null:
		_return_to_previous_position()
		return

	var target = spawn_area.get_random_free_position()

	var tween := get_tree().create_tween()

	tween.tween_property(
		self,
		"global_position",
		target,
		0.2
	).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"global_rotation",
		0.0,
		0.2
	).set_ease(Tween.EASE_OUT)


func _get_best_socket() -> DropSocket:
	var best_socket: DropSocket = null
	var best_distance := INF

	for socket in candidate_sockets:
		if not is_instance_valid(socket):
			continue

		if socket.occupied_part != null:
			continue

		var distance := global_position.distance_to(socket.global_position)

		if distance < best_distance:
			best_distance = distance
			best_socket = socket

	return best_socket
	
func _on_area_2d_mouse_entered():
	if StateManager.is_dragging:
		return

	draggable = true
	is_hovered = true
	_set_hover_visual(true)

	if body_part_data == null:
		return

	var tooltip = get_tree().get_first_node_in_group("body_part_tooltip")
	if tooltip:
		tooltip.show_body_part(body_part_data)


func _on_area_2d_mouse_exited():
	draggable = false
	is_hovered = false
	_set_hover_visual(false)

	var tooltip = get_tree().get_first_node_in_group("body_part_tooltip")
	if tooltip:
		tooltip.hide()


func _set_hover_visual(active: bool):
	if active:
		scale = Vector2.ONE * part_scale * 1.05
	else:
		scale = Vector2.ONE * part_scale



func _on_area_2d_body_entered(body: Node2D):
	if body is DropSocket:
		if body.occupied_part != null:
			return
			
		if not candidate_sockets.has(body):
			candidate_sockets.append(body)
			
		_update_socket_highlights()

func _on_area_2d_body_exited(body: Node2D):
	if body is DropSocket:
		candidate_sockets.erase(body)
		_update_socket_highlights()

func _update_socket_highlights():
	var best_socket := _get_best_socket()

	for socket in candidate_sockets:
		if is_instance_valid(socket):
			socket.set_highlight(socket == best_socket)
			
func update_collision_shape():
	if sprite.texture == null:
		return

	var texture_size = sprite.texture.get_size()
	# var sprite_size = texture_size * sprite.scale

	var shape := RectangleShape2D.new()
	shape.size = texture_size + Vector2( COLLISION_MARGIN * 2.0, COLLISION_MARGIN * 2.0)
	
	collision_shape.shape = shape

func _get_spawn_area() -> SpawnArea:
	var parent := get_parent()

	if parent is SpawnArea:
		return parent
	return null


func _is_over_spawn_area() -> bool:
	var spawn_area := _get_spawn_area()

	if spawn_area == null:
		return false

	var local_pos := spawn_area.to_local(global_position)
	var half := spawn_area.area_size / 2.0

	return Rect2(-half, spawn_area.area_size).has_point(local_pos)
