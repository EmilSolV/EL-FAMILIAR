extends Area2D

@export var direction: String

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var main = get_tree().get_root().get_node("Main")
		main._try_move_to(direction)
