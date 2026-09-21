extends TileMapLayer

@onready var ocean = %OceanMap

func _ready() -> void:
	pass
	
	
func populate_map(tiles):
	for tile in tiles:
		set_cell(tile, 2, Vector2i(1,1))

func clear_cells(pos, radius):
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
		queue_index += 1

		var distance: int = distances[current]

		if distance > radius:
			continue
		else:
			cells_to_clear.append(current)
		
		for neighbor in get_surrounding_cells(current):
			if visited.has(neighbor):
				continue


			visited[neighbor] = true
			distances[neighbor] = distance + 1
			queue.append(neighbor)
	
	for cell in cells_to_clear:
		erase_cell(cell)
