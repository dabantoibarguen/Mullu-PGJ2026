extends TileMapLayer

var pesca_game = preload("res://pesca/pesca_main.tscn")
var buceo_game = preload("res://buceo/buceo.tscn")
var confirm_popup = preload("res://navegacion/confirm.tscn")

@onready var boat = %barco
@onready var fog = %SmokeOnTheWater
@onready var nav = get_parent()

var painted_tiles = []

var source_id = 2 # hard-coded. Keep up to date
var hovered_cell = Vector2i(99, 99)
var unhovered_cell = Vector2i(99, 99)
var oldTracer = Line2D.new()

var path_to_target = []
var moving = false
var standby = false

var move_action = false

# Should replace with Data Layers later
const invalid_tiles = {
	Vector2i(-1, -1): "Borde",
	Vector2i(0, 0): "Roca", 
	Vector2i(1, 0): "Rocas",
	Vector2i(2, 0): "Arena"
}

const valid_tiles = {
	Vector2i(0, 1): "Mar Profundo",
	Vector2i(0, 2): "Mar Aeropuerto",
	Vector2i(2, 1): "Marea Alta",
	Vector2i(2, 2): "Marea Baja"
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
	if standby:
		return
	if ev is InputEventMouse:
		if ev.is_pressed() and ev.button_index == 1:
			# A lot of this "could" be obtained from the hovered tiles
			# But a fast mouse movement would break it all. Playing it safe.
			if move_action and !moving:
				var target_coords = local_to_map(get_global_mouse_position())
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
					elif dist > nav.energy:
						boat.label.text = "Energia insuficiente"
					else:
						boat.label.text = "Invalido"
				
	elif ev is InputEventKey and ev.is_pressed() and not ev.is_echo():
		if ev.keycode == KEY_SPACE:
			move_action = !move_action
			boat.label.text = ""
			remove_child(oldTracer)
			unhovered_cell = hovered_cell
		elif ev.keycode == KEY_P:
			var pescar = pesca_game.instantiate()
			pescar.connect("resultado_pesca", add_fish)
			standby = true
			#visible = false
			%PescaContainer.add_child(pescar)
		elif ev.keycode == KEY_B:
			var buceo = buceo_game.instantiate()

func add_fish(total_fish):
	print(total_fish)

			
func _physics_process(_delta: float) -> void:
	if (move_action):
		hovered_cell = local_to_map(get_global_mouse_position())
		var msg = ""
		if(standby or moving or fog.get_cell_source_id(hovered_cell) != -1):
			remove_child(oldTracer)
			boat.label.text = msg
			unhovered_cell = hovered_cell
			return
		var cell_atlas = get_cell_atlas_coords(hovered_cell)
		if(!moving and path_to_target == []):
			print("test\n" + str(cell_atlas))
			# Finding the path ahead of time to get the navigated distance
			if cell_atlas in invalid_tiles:
				return
				msg = (str(invalid_tiles.get(cell_atlas))
				+ "\nInvalido")
				#boat.label.text = msg
			else:
				path_to_target = find_path(boat.cur_coords, hovered_cell)
				remove_child(oldTracer)
				if (hovered_cell != boat.cur_coords):
					var tracer = Line2D.new()
					tracer.width = 1.5                    
					tracer.add_point(map_to_local(boat.cur_coords))
					for cell in path_to_target:
						tracer.add_point(map_to_local(cell))
					if path_to_target.size() <= boat.vision_range:
						tracer.default_color = Color.GREEN
						msg = (str(valid_tiles.get(cell_atlas)) 
						+ "\nMovimiento: " + str(path_to_target.size()))
					else:
						msg = (str(valid_tiles.get(cell_atlas))
						+ "\nMuy lejos")
						tracer.default_color = Color.RED
					add_child(tracer)
					oldTracer = tracer
					boat.label.text = msg
		if hovered_cell != unhovered_cell:
			boat.label.text = msg
			remove_child(oldTracer)
			path_to_target = []
		unhovered_cell = hovered_cell
	else:
		pass
