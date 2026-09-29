extends TileMapLayer

var pesca_game = preload("res://pesca/pesca_main.tscn")
var buceo_game = preload("res://buceo/buceo.tscn")
var confirm_popup = preload("res://navegacion/confirm.tscn")

@onready var boat = %barco
@onready var fog = %SmokeOnTheWater
@onready var nav = get_parent()
@onready var tree = get_tree()
@onready var navMenu = %NavMenu

# Update with blessings and/or other perks
var tile_cost = 2

var tile_type

var painted_tiles = []

var hovered_cell = Vector2i(99, 99)
var unhovered_cell = Vector2i(99, 99)
var oldTracer = Line2D.new()

var path_to_target = []

var moving = false
var standby = false # Is this even needed at this point?
var move_action = false

# Should replace with Data Layers later
const invalid_tiles = {
	Vector2i(-1, -1): "Borde",
	Vector2i(0, 1): "Mar Profundo",
	Vector2i(0, 0): "Roca", 
	Vector2i(1, 0): "Rocas",
	Vector2i(2, 0): "Arena"
}

const valid_tiles = {
	Vector2i(0, 2): "Mar Medio",
	Vector2i(2, 1): "Mar Alto",
	Vector2i(2, 2): "Mar Bajo"
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
	
func _unhandled_input(ev: InputEvent) -> void:
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
							nav.energy-= tile_cost
							boat.target = map_to_local(tile)
							fog.clear_cells(tile)
							# make this based on the time needed to move
							await get_tree().create_timer(0.45).timeout 
						boat.cur_coords = target_coords
						for neighbor in get_surrounding_cells(target_coords):
							if invalid_tiles.get(get_cell_atlas_coords(neighbor)) == "Roca":
								nav.junto_roca = true
								break
							else:
								nav.junto_roca = false
						moving = false
						path_to_target = [] 
					elif dist > nav.energy:
						boat.label.text = "Energia insuficiente"
					else:
						boat.label.text = "Invalido"
	elif ev is InputEventKey and ev.is_pressed():
		if ev.keycode == KEY_1:
			navegar()
			var navigationButton = navMenu.navBtn
			navigationButton.button_pressed = !(navigationButton.button_pressed)
		if ev.keycode == KEY_2:
			nav.menu_psc()
			var pescaButton = navMenu.pescaBtn
			pescaButton.button_pressed = !(pescaButton.button_pressed)
		if ev.keycode == KEY_3:
			nav.menu_bco()
			var buceoButton = navMenu.buceoBtn
			buceoButton.button_pressed = !(buceoButton.button_pressed)

func pause_nav():
	standby = true
	nav.visible = false
	navMenu.visible = false
	tree.paused = true
	boat.camara.enabled = false

func resume_nav():
	standby = false
	nav.visible = true
	navMenu.visible = true
	tree.paused = false
	boat.camara.enabled = true

func add_fish(total_fish):
	resume_nav()
	nav.pescado += total_fish
	navMenu.update_fish(nav.pescado)
	
func add_mullu(total_mullu):
	resume_nav()
	nav.mullu += total_mullu
	navMenu.update_mullu(nav.mullu)

# ------ Button functions -------
func navegar():
	move_action = !move_action
	boat.label.text = ""
	remove_child(oldTracer)
	unhovered_cell = hovered_cell

func pescar(fish_info):
	if (boat.cur_coords in nav.fished_tiles):
		return
	nav.fished_tiles.append(boat.cur_coords)
	navMenu.pescaBtn.disabled = true
	#print(nav.fished_tiles)
	nav.energy -= 4
	var pesca = pesca_game.instantiate()
	pause_nav()
	pesca.fish_name = fish_info[0]
	pesca.fish_size_percentage = fish_info[1]
	pesca.connect("resultado_pesca", add_fish)
	nav.add_sibling(pesca)

func bucear(mullu_list):
	nav.energy -= 4
	var buceo = buceo_game.instantiate()
	buceo.deep_spawn = mullu_list[0]
	buceo.mid_spawn = mullu_list[1]
	pause_nav()
	buceo.connect("resultado_buceo", add_mullu)
	nav.add_sibling(buceo)

func get_profundidad() -> String:
	var prof = valid_tiles.get(self.get_cell_atlas_coords(boat.cur_coords))
	if prof:
		return prof
	return ""
			
			
func _physics_process(_delta: float) -> void:
	if (move_action):
		hovered_cell = self.local_to_map(get_global_mouse_position())
		var msg = ""
		if(standby or moving or fog.get_cell_source_id(hovered_cell) != -1):
			remove_child(oldTracer) # Careful of all the debugging errors woops
			boat.label.text = msg
			unhovered_cell = hovered_cell
			return
		var cell_atlas = self.get_cell_atlas_coords(hovered_cell)
		if(!moving and path_to_target == []):
			# Finding the path ahead of time to get the navigated distance
			if cell_atlas in invalid_tiles:
				msg = (str(invalid_tiles.get(cell_atlas))
				+ "\nInvalido")
				return
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
		if(boat.cur_coords in nav.fished_tiles):
			navMenu.pescaBtn.disabled = true
		else:
			navMenu.pescaBtn.disabled = false
	else:
		pass
