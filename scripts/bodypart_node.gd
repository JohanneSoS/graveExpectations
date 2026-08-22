class_name BodyPart_Node
extends Node2D

var draggable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var initialRot: float


@export var body_part_data: BodyPart

# Gameplay Bahaviour

func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			initialRot = global_rotation
			offset = get_global_mouse_position() - global_position
			StateManager.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			StateManager.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				tween.tween_property(self, "global_position", body_ref.global_position,0.2).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "global_rotation", body_ref.global_rotation,0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self,"global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
				tween.tween_property(self,"global_rotation", initialRot, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered():
	if not StateManager.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	if not StateManager.is_dragging:
		draggable = false
		scale = Vector2(1, 1)


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
