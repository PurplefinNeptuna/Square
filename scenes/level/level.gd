class_name Level

extends TileMap

signal data_loaded(data: Array[PackedInt32Array])

enum SymmetryType {
	ASYMMETRIC,
	VERTICAL_MIRROR,
	HORIZONTAL_MIRROR,
	CIRCULAR
}

@export var symmetry:SymmetryType

var path_bit: Array[PackedInt32Array]

@onready var map_rect: Rect2i = self.get_used_rect()

func _ready()-> void:
	process_priority = 10
	print(map_rect)
	path_bit.resize(map_rect.size.x)
	for x in range(map_rect.size.x):
		path_bit[x] = PackedInt32Array()
		path_bit[x].resize(map_rect.size.y)
		path_bit[x].fill(0)

	for map_layer in range(self.get_layers_count()):
		for pos in self.get_used_cells(map_layer):
			var cell:TileData = self.get_cell_tile_data(map_layer, pos)
			var cell_pos:Vector2i = pos - map_rect.position
			var cell_data:int
			if cell == null:
				cell_data = -1
			else:
				cell_data = cell.get_custom_data_by_layer_id(0)
			path_bit[cell_pos.x][cell_pos.y] = cell_data

	print_path()
	symmetry_check()
	data_loaded.emit(path_bit)


func print_path()-> void:
	var result:String = ""
	for y: int in range(map_rect.size.y):
		for x: int in range(map_rect.size.x):
			result += "%02d " % path_bit[x][y]
		result += "\n"
	print(result)


func symmetry_check()-> void:
	print("Symmetry check:\n")

	if symmetry == SymmetryType.ASYMMETRIC:
		print("Asymmetric\n")
		return

	var is_symmetric:bool = true
	for x in range(map_rect.size.x):
		for y in range(map_rect.size.y):
			var mirror_x:int = x if symmetry == SymmetryType.HORIZONTAL_MIRROR \
					else map_rect.size.x - x - 1
			var mirror_y:int = y if symmetry == SymmetryType.VERTICAL_MIRROR \
					else map_rect.size.y - y - 1

			if path_bit[x][y] != path_bit[mirror_x][mirror_y]:
				is_symmetric = false
				printerr("Asymmetry found at [%d, %d] and [%d, %d]\n" \
						%[x, y, mirror_x, mirror_y])

	print(SymmetryType.keys()[symmetry] + ": ")
	if is_symmetric:
		print("true\n")
	else:
		print("false\n")
