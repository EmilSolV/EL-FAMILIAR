@tool
extends Node

signal item_equipped(item)

var items := []
var equipped_item: Dictionary = {}
var item_data := {} # Optional: mapa de item_id -> Dictionary si necesitás más info

func add_item(item_data: Dictionary):
	items.append(item_data)

func equip_item(item: Dictionary):
	equipped_item = item
	emit_signal("item_equipped", item)

func get_items():
	return items
