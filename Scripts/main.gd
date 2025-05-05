extends Node

@onready var room_holder = $RoomHolder
@onready var camera = $Camera2D
@onready var center_area_2d: Area2D = $CenterArea2D
@onready var inventory_label: Label = $Camera2D/CanvasLayer/InventoryLabel

@export var initialRoom: PackedScene
@export var camera_limit_position := Vector2(435, 400)
@export var camera_limit_size := Vector2(2950, 1300)


var current_room: Node2D = null
var camera_limits := Rect2(camera_limit_position, camera_limit_size)
var follow_mouse := true
var camera_return_speed := 5.0
var camera_speed := 0.05 # aumentar con la locura

func _ready():
	_initialize_first_room()
	_connect_signals()

func _process(delta):
	_update_camera_position(delta)
	_clamp_camera_within_limits()
	
	# momentaneo para probar el inventario
	var items = Inventory.get_items()
	inventory_label.text = "Inventario:\n" + "\n".join(items)

func _input(event):
	if event.is_action_pressed("ui_up"):
		_try_move_to("up")
	elif event.is_action_pressed("ui_down"):
		_try_move_to("down")
	elif event.is_action_pressed("ui_left"):
		_try_move_to("left")
	elif event.is_action_pressed("ui_right"):
		_try_move_to("right")

func _initialize_first_room():
	var initial_room = initialRoom.instantiate()
	_change_room(initial_room)

func _connect_signals():
	center_area_2d.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	center_area_2d.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _update_camera_position(delta):
	if follow_mouse:
		var mouse_offset = get_viewport().get_mouse_position() - get_viewport().size / 2.0
		camera.position += mouse_offset * camera_speed
	else:
		# lleva la cámara al centro. Se podría deshabilitar con la locura
		var center = get_viewport().size / 2.0
		camera.position = camera.position.lerp(center, delta * camera_return_speed)

func _clamp_camera_within_limits():
	var vp_size = get_viewport().size
	var limits = Rect2(camera_limit_position, camera_limit_size)
	camera.position.x = clamp(camera.position.x, limits.position.x, limits.end.x - vp_size.x)
	camera.position.y = clamp(camera.position.y, limits.position.y, limits.end.y - vp_size.y)

func _try_move_to(direction: String):
	if current_room == null:
		return

	var target_scene = current_room.get_connected_room(direction)
	if target_scene != null:
		_change_room(target_scene.instantiate())

func _change_room(new_room: Node2D):
	if current_room:
		current_room.queue_free()
	current_room = new_room
	room_holder.add_child(current_room)
	current_room.global_position = Vector2.ZERO

func _on_mouse_entered():
	follow_mouse = false

func _on_mouse_exited():
	follow_mouse = true
