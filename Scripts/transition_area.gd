extends Area2D

@export var target_scene_path: String

signal room_requested(new_room_scene: PackedScene)

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if target_scene_path != "":
			var scene_res = ResourceLoader.exists(target_scene_path)
			if scene_res:
				var new_scene = load(target_scene_path) as PackedScene
				emit_signal("room_requested", new_scene)
			else:
				print("La ruta de la escena no es válida: ", target_scene_path)
		else:
			print("No se asignó ninguna escena destino.")
