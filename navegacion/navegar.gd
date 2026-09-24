extends TileMapLayer

var fishing_particles = preload("res://navegacion/particulas_pesca.tscn")
var diving_particles = preload("res://navegacion/particulas_buceo.tscn")
var confirm_popup = preload("res://navegacion/confirm.tscn")

@onready var boat = %barco
@onready var fog = %SmokeOnTheWater
@onready var nav = get_parent()

var painted_tiles = []
var fishing_tiles = []
var diving_tiles = []

var source_id = 0 # hard-coded. Keep up to date
var hovered_cell = Vector2i(99, 99)
var unhovered_cell = Vector2i(99, 99)
var oldTracer = Line2D.new()

var path_to_target = []
var moving = false
var standby = false

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
	for tile in painted_tiles:
		var atlas = valid_tiles.get(get_cell_atlas_coords(tile))
		if atlas == "Mar alto": # or atlas == "Mar bajo"
			var rand = randi_range(1, 20)
			if rand == 10:
				var f_parts = fishing_particles.instantiate()
				f_parts.global_position = map_to_local(tile)
				add_child(f_parts)
				fishing_tiles.append(tile)
			if rand == 5:
				var d_parts = diving_particles.instantiate()
				d_parts.global_position = map_to_local(tile)
				add_child(d_parts)
				diving_tiles.append(tile)
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
	if ev is InputEventMouse and !moving and !standby:
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
					remove_child(oldTracer)
					for tile in move_path:
						nav.energy-=1
						boat.energyText.text = str(nav.energy)	+ "/" + str(30)
						boat.target = map_to_local(tile)
						fog.clear_cells(tile)
						# make this based on the time needed to move
						await get_tree().create_timer(0.4).timeout 
					boat.cur_coords = target_coords
					moving = false
					path_to_target = [] 
					var pop = confirm_popup.instantiate()
					if target_coords in fishing_tiles:
						pop.action = "pescar"
						standby = true
						add_child(pop)
					if target_coords in diving_tiles:
						pop.action = "bucear"
						standby = true
						add_child(pop)
						#get_tree().change_scene_to_file("res://buceo/buceo.tscn")
				elif dist > nav.energy:
					boat.label.text = "Energia insuficiente"
				else:
					boat.label.text = "Invalido"
				
		else:
			pass

			
func _physics_process(_delta: float) -> void:
	hovered_cell = local_to_map(get_global_mouse_position())
	var msg = ""
	if(standby or moving or fog.get_cell_source_id(hovered_cell) != -1):
		set_cell(unhovered_cell, 0, get_cell_atlas_coords(unhovered_cell), 0)
		remove_child(oldTracer)
		boat.label.text = msg
		unhovered_cell = hovered_cell
		return
	var cell_atlas = get_cell_atlas_coords(hovered_cell)
	if(!moving and path_to_target == []):
		
		# Finding the path ahead of time to get the navigated distance
		if cell_atlas in invalid_tiles:
			msg += (str(invalid_tiles.get(cell_atlas))
			+ "\nInvalido")
			return
		path_to_target = find_path(boat.cur_coords, hovered_cell)
		remove_child(oldTracer)
		if (hovered_cell != boat.cur_coords):
			var tracer = Line2D.new()
			tracer.width = 1.5                    
			tracer.add_point(map_to_local(boat.cur_coords))
			for cell in path_to_target:
				tracer.add_point(map_to_local(cell))
			if path_to_target.size() <= boat.vision_range:
				set_cell(hovered_cell, 0, cell_atlas, 1)
				tracer.default_color = Color.GREEN
				msg += (str(valid_tiles.get(cell_atlas)) 
				+ "\nMovimiento: " + str(path_to_target.size()))
		
			else:
				boat.label.text = (str(valid_tiles.get(cell_atlas))
				+ "\nMuy lejos")
				set_cell(hovered_cell, 0, cell_atlas, 2)
				tracer.default_color = Color.RED
			add_child(tracer)
			oldTracer = tracer
			if hovered_cell in fishing_tiles:
				msg += "\nZona de Pesca"
			if hovered_cell in diving_tiles:
				msg += "\nZona de Buceo"
			boat.label.text = msg
	if hovered_cell != unhovered_cell:
		boat.label.text = msg
		remove_child(oldTracer)
		set_cell(unhovered_cell, 0, get_cell_atlas_coords(unhovered_cell), 0)
		path_to_target = []
	unhovered_cell = hovered_cell
