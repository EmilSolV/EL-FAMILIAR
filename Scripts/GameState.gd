extends Node

var flags := {}

func set_flag(flag_name: String, value: bool):
	flags[flag_name] = value

func get_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)
