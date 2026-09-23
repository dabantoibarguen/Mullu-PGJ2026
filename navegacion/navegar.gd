extends TileMapLayer

@onready var boat = %barco
@onready var fog = %SmokeOnTheWater
@onready var nav = get_parent()

var painted_tiles = []

var source_id = 0 # hard-coded. Keep up to date
var hovered_cell = Vector2i(99, 99)
var unhovered_cell = Vector2i(99, 99)


var path_to_target = []
var moving = false

# Should replace with Data Layers later
const invalid_tiles = {
	Vector2i(-1, -1): "Borde", 
	Vector2i(4, 0): "Roca",
	Vector2i(6, 2): "Arena"
}

const valid_tiles = {
	Vector2i(6, 0): "Mar alto",
	Vector2i(4, 2): "Mar bajo"
}

func _ready() -> void:
	painted_tiles = get_used_cells()
	fog.populate_map(painted_tiles)
	fog.clear_cells(boat.cur_coords)
	
func find_path(start, target: Vector2i) -> Array[Vector2i]:
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
		return []

	var path: Array[Vector2i] = []
	current = target

	while current != null and current != start:
		path.push_front(current)
		current = came_from[current]
	
	start = target
	return path
	
func _input(ev: InputEvent) -> void:
	if ev is InputEventMouse and !moving:
		if ev.is_pressed() and ev.button_index == 1:
			# A lot of this "could" be obtained from the hovered tiles
			# But a fast mouse movement would break it all. Playing it safe.
			var target_coords = local_to_map(get_global_mouse_position())
			# Ensure clicked cell is valid
			if get_cell_atlas_coords(target_coords) not in invalid_tiles:
				var move_path = find_path(boat.cur_coords, target_coords)
				var dist = move_path.size()
				if(0 < dist and dist <= boat.vision_range and dist <=nav.energy):
					moving = true
					for tile in move_path:
						nav.energy-=1	
						boat.target = map_to_local(tile)
						fog.clear_cells(tile)
						# make this based on the time needed to move
						await get_tree().create_timer(0.33).timeout 
					boat.cur_coords = target_coords
					moving = false
				elif dist > nav.energy:
					boat.label.text = "Energia insuficiente"
				else:
					boat.label.text = "Invalido"
				
		else:
			pass

			
func _physics_process(_delta: float) -> void:
	hovered_cell = local_to_map(get_global_mouse_position())
	if(moving or fog.get_cell_source_id(hovered_cell) != -1):
		set_cell(unhovered_cell, 0, get_cell_atlas_coords(unhovered_cell), 0)
		boat.label.text = ""
		unhovered_cell = hovered_cell
		return
	var cell_atlas = get_cell_atlas_coords(hovered_cell)
	if(!moving and path_to_target == []):
		# Finding the path ahead of time to get the navigated distance
		if cell_atlas in invalid_tiles:
			boat.label.text = (str(invalid_tiles.get(cell_atlas))
			+ "\nInvalido")
			return
		path_to_target = find_path(boat.cur_coords, hovered_cell)
		if (hovered_cell != boat.cur_coords):
			if path_to_target.size() <= boat.vision_range:
				set_cell(hovered_cell, 0, cell_atlas, 1)
				boat.label.text = (str(valid_tiles.get(cell_atlas)) 
				+ "\nMovimiento: " + str(path_to_target.size()))
		
			else:
				boat.label.text = (str(valid_tiles.get(cell_atlas))
				+ "\nMuy lejos")
				set_cell(hovered_cell, 0, cell_atlas, 2)
		

	if hovered_cell != unhovered_cell:
		set_cell(unhovered_cell, 0, get_cell_atlas_coords(unhovered_cell), 0)
		path_to_target = []
	unhovered_cell = hovered_cell
			
			
