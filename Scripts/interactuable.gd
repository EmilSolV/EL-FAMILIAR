extends Area2D

func _can_use_item(item_id: String) -> bool:
	if not Inventory.item_data.has(item_id):
		return false
	
	var required_flags = Inventory.item_data[item_id].get("required_flags", [])
	for flag in required_flags:
		if not GameState.get_flag(flag):
			return false

	return true
