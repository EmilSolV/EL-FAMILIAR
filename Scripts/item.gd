extends Area2D

@export var item_name := "Objeto misterioso"
@onready var label := $Label

func _ready():
	if item_name in Inventory.items:
		queue_free()
		return

	label.text = item_name
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		Inventory.add_item(item_name)
		queue_free()
