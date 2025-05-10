extends CanvasLayer

@onready var inventory_label: Label = $InventoryLabel
@onready var item_holder = $ItemHolder

func _ready():
	update_inventory()

func update_inventory():	
	var items = Inventory.get_items()
	inventory_label.text = "Inventario:\n" + "\n".join(items.map(func(item): return item["name"]))
	for child in item_holder.get_children():
		child.queue_free()

	for item in items:
		var area = Area2D.new()
		var sprite = Sprite2D.new()
		sprite.texture = item["sprite_in_inventory"]
		area.add_child(sprite)

		var shape = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.extents = sprite.texture.get_size() / 2
		shape.shape = rect
		area.add_child(shape)

		area.position = slot_positions.get(item["regazo_slot"], Vector2.ZERO)
		$ItemHolder.add_child(area)

		area.input_event.connect(func(viewport, event, shape_idx):
			if event is InputEventMouseButton and event.pressed:
				Inventory.equip_item(item)
				self.hide()
		)

func get_item_position(name: String) -> Vector2:
	match name:
		"Llave Roja":
			return Vector2(100, 300)
		"Piedra Brillante":
			return Vector2(200, 250)
		_:
			return Vector2(50, 50)

var slot_positions = {
	0: Vector2(640, 430),
	1: Vector2(1200, 430),
	2: Vector2(1200, 780),
	3: Vector2(640, 780)
}
