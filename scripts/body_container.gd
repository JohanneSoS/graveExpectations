class_name DropSocket
extends StaticBody2D

var occupied_part: BodyPart_Node = null

func _ready():
	modulate = Color(Color.AQUA, 0.5)

func _process(_delta):
	if StateManager.is_dragging:
		visible = true
	else:
		visible = false

func assign_part(part: BodyPart_Node):
	occupied_part = part

func clear_part():
	occupied_part = null
