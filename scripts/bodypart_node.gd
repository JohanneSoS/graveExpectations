class_name BodyPart_Node
extends Node2D

var current_socket:DropSocket = null
var draggable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var initialRot: float
const COLLISION_MARGIN = 8.0

@export var body_part_data: BodyPart
@onready var sprite = $Sprite2D
@onready var collision_shape = $Area2D/CollisionShape2D


# Gameplay Bahaviour
func _ready():
	update_collision_shape()
	
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			initialRot = global_rotation
			offset = get_global_mouse_position() - global_position
			StateManager.is_dragging = true
			
			if current_socket:
				current_socket.clear_part()
				GameStatManager.current_body_parts.erase(body_part_data)
				GameStatManager.update_current_body_stats()
				current_socket = null
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			StateManager.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				tween.tween_property(self, "global_position", body_ref.global_position,0.2).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "global_rotation", body_ref.global_rotation,0.2).set_ease(Tween.EASE_OUT)
				
				current_socket = body_ref
				current_socket.assign_part(self)
				GameStatManager.current_body_parts.append(body_part_data)
				GameStatManager.update_current_body_stats()
			else:
				tween.tween_property(self,"global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
				tween.tween_property(self,"global_rotation", initialRot, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered():
	if not StateManager.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)
		
		if body_part_data == null:
			return
		
		var tooltip = get_tree().get_first_node_in_group("body_part_tooltip")
		if tooltip:
			tooltip.show_body_part(body_part_data)

func _on_area_2d_mouse_exited():
	if not StateManager.is_dragging:
		draggable = false
		scale = Vector2(1, 1)
	
	var tooltip = get_tree().get_first_node_in_group("body_part_tooltip")
	if tooltip:
		tooltip.hide()


func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body.modulate = Color(Color.MEDIUM_AQUAMARINE, 1)
		body_ref = body


func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group('dropable'):
		is_inside_dropable = false
		body.modulate = Color(Color.AQUA, 0.5)
		body_ref = body

func update_collision_shape():
	if sprite.texture == null:
		return

	var texture_size = sprite.texture.get_size()
	var sprite_size = texture_size * sprite.scale

	var shape := RectangleShape2D.new()
	shape.size = sprite_size + Vector2( COLLISION_MARGIN * 2.0, COLLISION_MARGIN * 2.0)
	
	collision_shape.shape = shape
	
