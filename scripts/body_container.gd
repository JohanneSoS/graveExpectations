class_name DropSocket
extends StaticBody2D

var occupied_part: BodyPart_Node = null
const NORMAL_COLOR := Color(Color.CRIMSON, 0.5)
const HIGHLIGHT_COLOR := Color(Color.BROWN, 1.0)
const OCCUPIED_COLOR := Color(Color.GRAY, 0.35)

func _ready():
	modulate = Color(Color.AQUA, 0.5)

func _process(_delta):
	visible = StateManager.is_dragging

func assign_part(part: BodyPart_Node):
	occupied_part = part
	set_highlight(false)

func clear_part():
	occupied_part = null
	set_highlight(false)

func set_highlight(active):
	if occupied_part != null:
		modulate = OCCUPIED_COLOR
	elif active:
		modulate = HIGHLIGHT_COLOR
	else:
		modulate = NORMAL_COLOR
	
