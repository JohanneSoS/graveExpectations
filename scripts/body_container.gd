extends StaticBody2D

func _ready():
	modulate = Color(Color.AQUA, 0.5)
	
func _process(delta):
	if StateManager.is_dragging:
		visible = true
	else:
		visible = false
