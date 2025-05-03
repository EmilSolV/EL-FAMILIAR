extends Node

var items := []

func add_item(item_name: String) -> void:
	if not item_name in Inventory.items:
		Inventory.items.append(item_name)

func get_items() -> Array:
	return items
