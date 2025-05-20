extends Node2D

#@export var room_right_path: String
#@export var room_left_path: String
#@export var room_up_path: String
#@export var room_down_path: String
#
#var room_right: PackedScene = null
#var room_left: PackedScene = null
#var room_up: PackedScene = null
#var room_down: PackedScene = null
#
#func get_connected_room(direction: String) -> PackedScene:
	#match direction:
		#"up":
			#if room_up == null and room_up_path != "":
				#room_up = load(room_up_path)
			#return room_up
		#"down":
			#if room_down == null and room_down_path != "":
				#room_down = load(room_down_path)
			#return room_down
		#"left":
			#if room_left == null and room_left_path != "":
				#room_left = load(room_left_path)
			#return room_left
		#"right":
			#if room_right == null and room_right_path != "":
				#room_right = load(room_right_path)
			#return room_right
		#_:
			#print("Dirección no válida:", direction)
			#return null
