extends TileMapLayer

@onready var boat = %barco
@onready var fog = %SmokeOnTheWater

var source_id = 0 # hard-coded. Keep up to date
var hovered_cell = Vector2i(-1, -1)
var unhovered_cell = Vector2i(-1, -1)
var path_to_target = []
var painted_tiles

var moving = false

# Should replace with Data Layers later
const invalid_tiles = {
	Vector2i(-1, -1): false, 
	Vector2i(4, 0): false,
	Vector2i(6, 2): false
}

func _ready() -> void:
	painted_tiles = get_used_cells()
	fog.populate_map(painted_tiles)
	fog.clear_cells(boat.cur_coords, boat.vision_range)
	
func find_path(start, target: Vector2i) -> Array[Vector2i]:
	if(moving):
		return []
	moving = true
	var queue = [start]
	var came_from = {start: null}
	var i = 0
	var current
	
	while i < queue.size():
		current = queue[i]
		i += 1

		if current == target:
			break

		for next in get_surrounding_cells(current):
			if (get_cell_atlas_coords(next) in invalid_tiles) or (next in came_from):
				continue

			came_from[next] = current
			queue.append(next)

	if not came_from.has(target):
		#moving = false
		return []

	var path: Array[Vector2i] = []
	current = target

	while current != null:
		path.push_front(current)
		current = came_from[current]
	
	start = target
	return path
	
func _input(ev: InputEvent) -> void:
	if ev is InputEventMouse:
		if ev.is_pressed() and ev.button_index == 1:
			var target_coords = local_to_map(get_global_mouse_position())	
			# Ensure clicked cell is valid
			if get_cell_atlas_coords(target_coords) not in invalid_tiles:
				var path = find_path(boat.cur_coords, target_coords)
				if(path != []):
					for tile in path:
						boat.target = map_to_local(tile) # Center of the hex rather than top
						fog.clear_cells(tile, boat.vision_range)
						await get_tree().create_timer(0.33).timeout # make this based on the time needed to move
					moving = false
					boat.cur_coords = target_coords
				#%barco.global_position = map_to_local(coords) + Vector2(0, 7)  # Teleportation, deprecated
		else:
			pass
			
func _physics_process(_delta: float) -> void:
	hovered_cell = local_to_map(get_global_mouse_position())
	var cell_atlas = get_cell_atlas_coords(hovered_cell)
	if(cell_atlas not in invalid_tiles and hovered_cell != boat.cur_coords):
		#print(get_cell_alternative_tile(hovered_cell))
		set_cell(hovered_cell, 0, cell_atlas, 1)

	if hovered_cell != unhovered_cell or hovered_cell == boat.cur_coords:
		set_cell(unhovered_cell, 0, get_cell_atlas_coords(unhovered_cell), 0)
	unhovered_cell = hovered_cell
		
	
	
			
			
