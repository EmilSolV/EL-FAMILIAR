extends CanvasLayer

@onready var equipped_sprite := $Sprite2D

func _process(delta):
	if Inventory.equipped_item.has("sprite_equipped"):
		equipped_sprite.texture = Inventory.equipped_item["sprite_equipped"]
	else:
		equipped_sprite.texture = null

func _ready():
	Inventory.connect("item_equipped", Callable(self, "_on_item_equipped"))

func _on_item_equipped(item):
	$Sprite2D.texture = item["sprite_equipped"]
