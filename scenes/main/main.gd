class_name Main

extends Node

var level_data: Array[PackedInt32Array]
var actor_data: Array[PackedInt32Array]

func _enter_tree() -> void:
	var level = get_node("Level") as Level
	level.data_loaded.connect(_on_level_data_loaded)

func _ready() -> void:
	pass

func _on_level_data_loaded(data):
	level_data = data as Array[PackedInt32Array]
