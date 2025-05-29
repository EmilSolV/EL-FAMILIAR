extends Node

@onready var room_holder = $RoomHolder
@onready var camera = $Camera2D
@onready var center_area_2d: Area2D = $CenterArea2D

@export var initialRoom: PackedScene
@export var inventory_scene: PackedScene

@export var camera_limit_position := Vector2(435, 400)
@export var camera_limit_size := Vector2(2950, 1300)

@export var camera_return_speed := 2.0
@export var camera_speed := 0.10
@export var camera_hover_divisor := 1.5
@export var camera_follow_delay := 0.3

var temporarily_disable_follow := false
var inventory_instance: Node = null
var current_room: Node2D = null
var camera_limits := Rect2(camera_limit_position, camera_limit_size)
var follow_mouse := true

var target_camera_position: Vector2
var hover_camera_target: Vector2 = Vector2.ZERO
var is_hovering_object := false

func _ready():
	_initialize_first_room()
	_connect_signals()
	add_to_group("Main")

func _process(delta):
	_update_camera_position(delta)
	_clamp_camera_within_limits()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		_show_inventory()
	else:
		_hide_inventory()

func _input(event):
	pass

func _initialize_first_room():
	var initial_room = initialRoom.instantiate()
	_change_room(initial_room)

func _connect_signals():
	center_area_2d.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	center_area_2d.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _update_camera_position(delta):
	var center = get_viewport().size / 2.0

	if is_hovering_object:
		target_camera_position = hover_camera_target
	elif follow_mouse:
		var mouse_pos = get_viewport().get_mouse_position()
		var offset = mouse_pos - center
		target_camera_position = camera.position + offset / camera_hover_divisor
	else:
		target_camera_position = center

	camera.position = camera.position.lerp(target_camera_position, delta * camera_return_speed)

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
	
	_connect_transition_signals(current_room)
	
	# Centrar cámara al cargar la escena
	var center = get_viewport().size / 2.0
	camera.position = center
	follow_mouse = false
	temporarily_disable_follow = true

	# Esperar el delay de cámara
	await get_tree().create_timer(camera_follow_delay).timeout

	# Esperar a que el mouse se mueva (mínimo 2px)
	var initial_mouse_pos := get_viewport().get_mouse_position()
	while get_viewport().get_mouse_position().distance_to(initial_mouse_pos) < 2:
		await get_tree().process_frame

	# Rehabilitar el seguimiento
	follow_mouse = true
	temporarily_disable_follow = false


func _connect_transition_signals(node: Node):
	for child in node.get_children():
		if child is Area2D and child.has_signal("room_requested"):
			child.connect("room_requested", Callable(self, "_on_room_requested"))
		elif child.get_child_count() > 0:
			_connect_transition_signals(child)

func _on_room_requested(new_scene: PackedScene):
	if new_scene:
		_change_room(new_scene.instantiate())

func _on_mouse_entered():
	follow_mouse = false

func _on_mouse_exited():
	follow_mouse = true

func _show_inventory():
	if inventory_instance == null:
		inventory_instance = inventory_scene.instantiate()
		add_child(inventory_instance)

func _hide_inventory():
	if inventory_instance != null:
		inventory_instance.queue_free()
		inventory_instance = null

func focus_camera_on(position: Vector2):
	is_hovering_object = true
	hover_camera_target = position

func clear_camera_focus():
	is_hovering_object = false
