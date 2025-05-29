@tool
extends Area2D

@export var item_id := "generic_item"
@export var item_name := "Item genérico"
@export var description := "Un item común y corriente"
@export var usable := true
@export var usable_on := [] # ["objeto_interactuable_id"]
@export var required_flags: Array[String] = [] # ["timer_01_passed", "door_02_opened"]
@export var regazo_slot: int = 0
@export var sprite_in_inventory: Texture2D
@export var sprite_equipped: Texture2D
@export var sprite_in_world: Texture2D:
	set(value):
		sprite_in_world = value
		if sprite:
			sprite.texture = value

@onready var label := $Label
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.texture = sprite_in_world
	var items = Inventory.get_items()
	if item_id in items:
		queue_free()
		return

	label.text = item_name
	sprite.texture = sprite_in_world
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var item_data = {
			"name": item_name,
			"sprite_in_inventory": sprite_in_inventory,
			"sprite_equipped": sprite_equipped,
			"sprite_in_world": sprite_in_world,
			"usable": usable,
			"regazo_slot": regazo_slot
		}

		Inventory.add_item(item_data)
		queue_free()

func _on_mouse_entered():
	get_tree().get_first_node_in_group("Main").focus_camera_on(global_position)

func _on_mouse_exited():
	get_tree().get_first_node_in_group("Main").clear_camera_focus()
