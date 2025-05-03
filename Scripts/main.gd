extends Node

@onready var room_holder = $RoomHolder
@onready var camera = $Camera2D

@export var initialRoom: PackedScene

var current_room: Node2D = null
var left: bool = false
var right: bool = false
var camera_limits := Rect2(Vector2(0, 0), Vector2(3000, 2000))

func _ready():
	var initial_room = initialRoom.instantiate()
	change_room(initial_room)

func _process(_delta):
	var mouse_move = get_viewport().get_mouse_position() - Vector2(get_viewport().size) / 2.0
	var camera_speed := 0.07

	camera.position += mouse_move * camera_speed
	camera.position.x = clamp(camera.position.x, camera_limits.position.x, camera_limits.position.x + camera_limits.size.x - get_viewport().size.x)
	camera.position.y = clamp(camera.position.y, camera_limits.position.y, camera_limits.position.y + camera_limits.size.y - get_viewport().size.y)

func _input(event):
	if event.is_action_pressed("ui_up"):
		try_move_to("up")
	elif event.is_action_pressed("ui_down"):
		try_move_to("down")
	elif event.is_action_pressed("ui_left"):
		try_move_to("left")
	elif event.is_action_pressed("ui_right"):
		try_move_to("right")

func try_move_to(direction: String):
	if current_room == null:
		print("No hay habitación actual.")
		return

	print("Intentando moverme hacia: ", direction)

	var target_scene = current_room.get_connected_room(direction)

	if target_scene != null:
		print("Escena encontrada para ", direction, ": ", target_scene.resource_path)
		change_room(target_scene.instantiate())
	else:
		print("No hay escena conectada hacia ", direction)

func change_room(new_room: Node2D):
	if current_room:
		print("Eliminando habitación actual: ", current_room.name)
		current_room.queue_free()
	
	current_room = new_room
	room_holder.add_child(current_room)
	current_room.global_position = Vector2.ZERO

	print("Nueva habitación agregada: ", current_room.name)
