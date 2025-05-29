extends Area2D

@export var interaction_type: String = "message" # "message" o "inspect"
@export var message_text: String = "Algo pasa cuando tocás este objeto..."
@export var inspect_scene: PackedScene
@export var interaction_flags_required: Array[String] = []
@export var sprite_texture: Texture2D:
	set(value):
		sprite_texture = value
		if sprite:
			sprite.texture = value

@onready var sprite: Sprite2D = $Sprite2D
@onready var label := $Label

func _ready():
	sprite.texture = sprite_texture
	label.text = "" 
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if interaction_type == "inspect" and inspect_scene:
			_show_inspect_scene()
		elif interaction_type == "message":
			#_show_message(message_text)
			pass

func _show_inspect_scene():
	var scene_instance = inspect_scene.instantiate()
	get_tree().root.add_child(scene_instance) 
	scene_instance.global_position = get_global_mouse_position() 

#func _show_message(text):
	#mostrar mensaje

func _on_mouse_entered():
	get_tree().get_first_node_in_group("Main").focus_camera_on(global_position)

func _on_mouse_exited():
	get_tree().get_first_node_in_group("Main").clear_camera_focus()
