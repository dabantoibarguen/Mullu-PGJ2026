extends TileMapLayer

@onready var ocean = %OceanMap

func _ready() -> void:
	pass
	
	
func populate_map(tiles):
	for tile in tiles:
		set_cell(tile, 2, Vector2i(1,1))


func clear_cells(pos):
	var radius = %barco.vision_range
	# This chunk could be moved to "get_cells_in_radius" for navegar.gd
	var cells_to_clear = []
	
	var visited: Dictionary = {}
	var distances: Dictionary = {}

	var queue: Array[Vector2i] = []

	queue.append(pos)
	visited[pos] = true
	distances[pos] = 0

	var queue_index := 0

	while queue_index < queue.size():
		var current: Vector2i = queue[queue_index]
		var atlas = %OceanMap.get_cell_atlas_coords(current)
		queue_index += 1
		
		var tile_distance = %OceanMap.find_path(pos, current).size()
		
		var distance: int = distances[current]
		if distance > radius or tile_distance > radius:
			continue
		else:
			cells_to_clear.append(current)
		
		for neighbor in get_surrounding_cells(current):
			if visited.has(neighbor):
				continue


			visited[neighbor] = true
			distances[neighbor] = distance + 1
			queue.append(neighbor)
	# Up to here it's just obtaining the cells
	
	for cell in cells_to_clear:
		erase_cell(cell)
