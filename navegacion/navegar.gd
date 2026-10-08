extends TileMapLayer

var pesca_game = preload("res://pesca/pesca_main.tscn")
var buceo_game = preload("res://buceo/buceo.tscn")
var confirm_popup = preload("res://navegacion/confirm.tscn")

@onready var boat = %barco
@onready var fog = %SmokeOnTheWater
@onready var nav = get_parent()
@onready var tree = get_tree()
@onready var navMenu = %NavMenu

@onready var hot = $CorrienteC
@onready var cold = $CorrienteF
@onready var temper = $Ideal

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
	update_temperatura()
	
	
func update_temperatura():
	if boat in temper.get_overlapping_bodies():
		nav.temperatura = "Temperado"
		navMenu.tempBall.modulate = Color("#ffffff")
		navMenu.tempBall.tooltip_text = "Temperatura: Temperado"
	elif boat in hot.get_overlapping_bodies():
		nav.temperatura = "Caliente"
		navMenu.tempBall.modulate = Color("#ff6600")
		navMenu.tempBall.tooltip_text = "Temperatura: Caliente"
	elif boat in cold.get_overlapping_bodies():
		nav.temperatura = "Frio"
		navMenu.tempBall.modulate = Color("#00bfff")
		navMenu.tempBall.tooltip_text = "Temperatura: Frío"
	else:
		nav.temperatura = "Temperado"
		if navMenu.tempBall:
			navMenu.tempBall.modulate = Color("#ffffff")
	
	
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
					if(0 < dist and dist <= boat.vision_range and dist <=nav.energy and move_path.size() * tile_cost <= nav.energy):
						moving = true
						if oldTracer:
							remove_child(oldTracer)
						for tile in move_path:
							nav.energy-= tile_cost
							boat.target = map_to_local(tile)
							fog.clear_cells(tile)
							# make this based on the time needed to move
							await get_tree().create_timer(0.55).timeout 
						boat.cur_coords = target_coords
						for neighbor in get_surrounding_cells(target_coords):
							if invalid_tiles.get(get_cell_atlas_coords(neighbor)) == "Roca":
								nav.junto_roca = true
								break
							else:
								nav.junto_roca = false
						moving = false
						path_to_target = [] 
						update_temperatura()
						if Global.tutorial:
							check_tutorial()
						else:
							if(nav.energy <=0):
								end_navigation()
								
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
		if ev.keycode == KEY_SHIFT:
			display_summary()
		if ev.keycode == KEY_TAB:
			display_controls()

func end_navigation():
	move_action = false
	var dialogue = Global.dialogo.instantiate()
	if nav.pescado > Global.fish_quota:
		Global.total_fish += nav.pescado - Global.fish_quota
		Global.total_mullu += nav.mullu
		dialogue.type = "Resumen Final"
		add_child(dialogue)
		dialogue.new_text([
			[[], "RESULTADOS DEL DÍA
			\nPuntaje de Pesca: " + str(nav.pescado) +
		"\nPuntos de Pesca Requeridos: " + str(Global.fish_quota) +
		"\nTotal Extra: " + str(Global.total_fish) +
		"\n\nPuntaje de Mullu: " + str(nav.mullu) +
		"\n\n¡Buen trabajo!"]
		])
		return
	
	if nav.pescado < Global.fish_quota:
		if nav.energy > 0:
			dialogue.type = "Resumen"
			add_child(dialogue)
			dialogue.new_text([
				[[], "RESULTADOS ACTUALES
				\nPuntaje de Pesca: " + str(nav.pescado) +
			"\nPuntos de Pesca Requeridos: " + str(Global.fish_quota) +
			"\nPuntaje de Mullu: " + str(nav.mullu) +
			"\n\nAun necesitas: " + str(Global.fish_quota - nav.pescado) + " puntos de pesca."+
			"\n¡No te rindas!"]
			])
		else:
			dialogue.type = "Game Over"
			add_child(dialogue)
			dialogue.new_text([
			[[], "RESULTADOS DEL DÍA
			\nPuntaje de Pesca: " + str(nav.pescado) +
			"\nPuntos de Pesca Requeridos: " + str(Global.fish_quota) +
			"\nTotal Extra: " + "0" +
			"\n\nPuntaje de Mullu: " + str(nav.mullu) +
			"\n\nNo capturaste suficiente..."]
			])
	
func display_controls():
	var dialogue = Global.dialogo.instantiate()
	dialogue.type = "Resumen"
	add_child(dialogue)
	dialogue.new_text([
		[[],
		"Controles de Navegación: \n
SHIFT = Abrir el menú de puntuación requerida
TAB = Abrir el menú de controles (funciona durante Pesca y Buceo) \n
Mouse 1 = Seleccionar botones / Seleccionar casillas
Tecla 1 = Opcion de Navegar
Tecla 2 = Opcion de Pescar (invalida durante \'Navegar\')
Tecla 3 = Opcion de Buceo (invalida durante \'Navegar\')"]
		])

func display_summary():
	var dialogue = Global.dialogo.instantiate()
	dialogue.type = "Resumen"
	add_child(dialogue)
	Global.total_fish += nav.pescado - Global.fish_quota
	Global.total_mullu += nav.mullu
	dialogue.new_text([
		[[], "RESUMEN ACTUAL" +
		"\nPuntos Requeridos: " + str(Global.fish_quota) +
		"\n\nPuntaje de Pesca: " + str(nav.pescado) +

		"\n\nPuntaje de Mullu: " + str(nav.mullu) +
		"\n\n¡Tu puedes!"]
	])

func pause_nav():
	standby = true
	visible = false
	navMenu.visible = false
	tree.paused = true
	boat.camara.enabled = false

func resume_nav():
	standby = false
	visible = true
	navMenu.visible = true
	tree.paused = false
	boat.camara.enabled = true

func add_fish(total_fish):
	resume_nav()
	if (Global.blessings.get("Sacred Sea").get("enabled")==true):
		total_fish = total_fish*1.10
	nav.pescado += total_fish
	
	navMenu.update_fish(nav.pescado)
	if nav.energy <= 0:
		end_navigation()
	if Global.tutorial:
		check_tutorial()
	
func add_mullu(total_mullu):
	resume_nav()
	
	# Audio
	var sfx_stream = load("res://navegacion/assets/Sonidos de mar para navegar.mp3")
	nav.sfx.stream = sfx_stream
	nav.sfx.play()
	
	# Mullu score update
	nav.mullu += total_mullu
	navMenu.update_mullu(nav.mullu)
	if nav.energy <= 0:
		end_navigation()
	if Global.tutorial:
		check_tutorial()

# ------ Button functions -------
func navegar():
	if Global.tutorial and Global.tutorial_index in [3, 4, 5]:
		return
	move_action = !move_action
	if oldTracer:
		remove_child(oldTracer)
	unhovered_cell = hovered_cell
	if move_action or (Global.tutorial and Global.tutorial_index < 3):
		navMenu.pescaBtn.disabled = true
		navMenu.buceoBtn.disabled = true
	else:
		navMenu.pescaBtn.disabled = false
		navMenu.buceoBtn.disabled = false
		

func pescar(fish_info):
	if nav.energy < 4 or move_action or (Global.tutorial and Global.tutorial_index in [2, 4, 5]):
		return
	if (boat.cur_coords in nav.fished_tiles):
		print("Tell the player you cannot fish here")
		return
	nav.fished_tiles.append(boat.cur_coords)
	navMenu.pescaBtn.disabled = true
	nav.energy -= 4
	var pesca = pesca_game.instantiate()
	pause_nav()
	pesca.fish_name = fish_info[0]
	pesca.fish_size_percentage = fish_info[1]
	pesca.connect("resultado_pesca", add_fish)
	nav.add_sibling(pesca)
	check_tutorial()

func bucear(mullu_list):
	if nav.energy < 4 or move_action or (Global.tutorial and Global.tutorial_index in [2, 3, 4]):
		return
	if (boat.cur_coords in nav.dived_tiles):
		print("Tell the player you cannot fish here")
		return
	nav.dived_tiles.append(boat.cur_coords)
	navMenu.buceoBtn.disabled = true
	nav.energy -= 4
	
	# Audio
	var sfx_stream = load("res://buceo/assets/Mar Buseo.mp3")
	nav.sfx.stream = sfx_stream
	nav.sfx.play()
	
	# Diving scene instance
	var buceo = buceo_game.instantiate()
	buceo.deep_spawn = mullu_list[0]
	buceo.mid_spawn = mullu_list[1]
	pause_nav()
	buceo.connect("resultado_buceo", add_mullu)
	nav.add_sibling(buceo)
	check_tutorial()

func get_profundidad() -> String:
	var prof = valid_tiles.get(self.get_cell_atlas_coords(boat.cur_coords))
	if prof:
		return prof
	return ""
			
			
# ------- TUTORIAL-----------

func check_tutorial():
	if !Global.tutorial:
		return
	move_action = false
	var dialogue = Global.dialogo.instantiate()
	add_child(dialogue)
	if Global.tutorial_index == 2:
		navMenu.navBtn.button_pressed = false
		navMenu.navBtn.disabled = true
		navMenu.pescaBtn.disabled = false
		navMenu.buceoBtn.disabled = true
		dialogue.new_text([
   	[["Laia"], "¡Ahí! Me parece que vi un pez"],
	
  	[["Mitso"], "¡Silencio! Si haces mucho ruido lo vas a espantar…"],
	
	[[], "Instrucciones:\n- Haz clic en el boton \"Pescar\" o presiona la Tecla \"2\" para iniciar el minijuego de pesca. No podrás pescar en una misma casilla hasta que cambie la hora, ni cuando estes en modo de navegación.\n\n	¡Pescar también te costará energía, pero es importante para ayudar a tu pueblo!"]
	])
	elif Global.tutorial_index == 3:
		dialogue.new_text([
  [["Mitso"], "¡Yo me encargo de esto!"],

  [[], "Instrucciones de Pesca:
	Usa las flechas o las teclas WASD para mover el indicador. Puedes acabar el juego antes con la tecla \"Escape\". Mantén el indicador encima de un objetivo al menos un segundo para lanzar la soga
	\nInstrucciones de Captura:
	Cuando tu soga alcance a tu objetivo, empezará un minijuego de precisión.
	Usa la barra espaciadora para elevar la linea blanca y mantenla en el espacio azul la mayor cantidad de tiempo posible ¡Buena suerte!"]
	])
	elif Global.tutorial_index == 4:
		navMenu.navBtn.disabled = true
		navMenu.pescaBtn.disabled = true
		navMenu.buceoBtn.disabled = false
		var txt = [
  	[["Mitso"], "Dejemos este lugar por ahora. El abuelo nos advirtió sobre respetar el balance. También sería bueno explorar un poco…"],
	
  	[["Laia"], "¡Espera! Amarra esa soga a mi cintura primero. Quiero intentar algo antes de irnos."],
	
  	[[], "Instrucciones:\nHaz clic en el botón \"Bucear\" o presiona la tecla \"3\" para iniciar el minijuego de buceo.\n\nBucear te costará energía, pero podrás recolectar el precioso Mullu en las profundidades."]
		]
		if nav.pescado > 0:
			txt.push_front([["Mitso"], "¡Excelente!"])
		else:
			txt.push_front([["Mitso"], "Eso pudo salir mejor."])
		dialogue.new_text(txt)
	elif Global.tutorial_index == 5:
		dialogue.new_text([
  [["Laia"], "¡Es mi turno!"],

  [[], "Instrucciones de Buceo:
	Usa las flechas o las teclas WASD para mover a Laia. 
	Puedes acabar el juego haciendo click al botón de \"Escapar\" cuando estés cerca al barco. Si te quedas sin oxígeno volveras con las manos vacías. 
	\nTrata de hallar el Mullu en las profundidades y hazle clic cuando este suficientemente cerca."],
	
  [[], "Instrucciones de Recorte:
	Usa las flechas izquierda/derecha o las teclas A/D para girar la mano.
	Usa las flechas arriba/abajo o las teclas W/S para mover la mano hacia adelante o atrás.
	¡Si te alejas mucho de la linea se empezará a romper el mullu!"]
	])
	elif Global.tutorial_index == 6:
		Global.tutorial = false
		remove_child(dialogue)
		navMenu.navBtn.disabled = false
		navMenu.pescaBtn.disabled = true
		navMenu.buceoBtn.disabled = false
			
func _physics_process(_delta: float) -> void:
	if (move_action):
		hovered_cell = self.local_to_map(get_global_mouse_position())
		var msg = ""
		if(standby or moving or fog.get_cell_source_id(hovered_cell) != -1) and oldTracer:
			remove_child(oldTracer) # Careful of all the debugging errors woops
			#boat.label.text = msg
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
				if oldTracer:
					remove_child(oldTracer)
				if (hovered_cell != boat.cur_coords):
					var tracer = Line2D.new()
					tracer.width = 1.5                    
					tracer.add_point(map_to_local(boat.cur_coords))
					for cell in path_to_target:
						tracer.add_point(map_to_local(cell))
					if path_to_target.size() <= boat.vision_range and path_to_target.size() * tile_cost <= nav.energy:
						tracer.default_color = Color.GREEN
					else:
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
		if(nav.energy < 4 or boat.cur_coords in nav.fished_tiles):
			navMenu.pescaBtn.disabled = true
		if(nav.energy < 4 or boat.cur_coords in nav.dived_tiles):
			navMenu.buceoBtn.disabled = true
