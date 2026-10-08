extends CanvasLayer

var indicador_pesca = preload("res://pesca/indicadores_pesca.tscn")
@onready var fish_area = %FishingArea
@onready var anzuelo = %Anzuelo
@onready var blur = $AaronBlur
@onready var juegoPesca = $AaronBlur/JuegoPesca
@onready var durLabel = $Durabilidad
@onready var fish_line = %Line
@onready var fish_pic = %Silhouette
@onready var spawner = $Spawn
signal resultado_pesca(pescado)


var caught_indicator

var pescados = 0

var fish_name
var fish_size_percentage
var puntos
var max_catch = 6

# Para mini juego de barra
var freq
var min_time

var fish_imgs = {
	"anchoveta": "res://pesca/assets/anchoveta.png",
					
	"tiburón toyo":"res://pesca/assets/toyo.png" ,

	"mantarraya": "res://pesca/assets/mantarraya epica.png",

	"chita": "res://pesca/assets/chita.png",

	"pez diablo":"res://pesca/assets/pez demoño.png" ,

	"cangrejo": "res://pesca/assets/cangareijo.png", # PENDING: Reemplazar

	"pez globo": "res://pesca/assets/pez globo.png"
}

var difficulty_ranges = {
	0: [0.0, 0.3],
	1: [0.1, 0.5] ,
	2: [0.3, 0.8],
	3: [0.5,1.0],
	4: [0.7, 1.2], 
	5: [1.0, 1.5]
}

var durabilidad = 5:
	set(dur):
		durabilidad = max(0 ,dur)
		durLabel.text = str(durabilidad)
		if durabilidad <= 0:
			pescados = int(pescados)
			resultado_pesca.emit(pescados)
			await get_tree().create_timer(1.0).timeout
			queue_free()

# Limited area polygon calculations
var triangles = []
var triangle_cumulative_weights = []
var total_area = 0.0

func _ready() -> void:
	fish_pic.texture = load(fish_imgs[fish_name])
	var fish_data = Global.fish_dictionary[fish_name]
	max_catch -= fish_data[4]
	if !fish_data[-1]:
		fish_pic.self_modulate = Color(0, 0, 0, 1)
	else:
		fish_pic.self_modulate = Color(1, 1, 1, 1)
	var size_float = float(fish_size_percentage)/100
	puntos = lerp(fish_data[6], fish_data[7], size_float)
	durLabel.text = str(durabilidad)
	var diff_r = difficulty_ranges[fish_data[4]]
	var x = lerp(diff_r[0], diff_r[1], size_float)
	freq = 2 - x
	min_time = 5 + 6*x
	#print(freq)
	#print(min_time)
	triangulate_fish_area()

func update_fishing_line(p_start: Vector2, p_end: Vector2, sag_amount: float = 50.0):
	var curve = Curve2D.new()
	p_end = fish_line.to_local(p_end)

	var mid_point = (p_start + p_end) / 2.0
	mid_point.y -= sag_amount

	curve.add_point(p_start)
	curve.add_point(mid_point)
	curve.add_point(p_end)

	curve.bake_interval = 15
	var baked_points = curve.get_baked_points()
	%Swoosh.play()
	for point in baked_points:
		fish_line.add_point(point)
		await get_tree().create_timer(0.01).timeout
	blur.visible = true
	if !%BGM_Pescar.playing:
		%BGM_Pescar.play()
	juegoPesca.start(self, freq, min_time)


func go_fish(origin):
	spawner.stop()
	update_fishing_line(Vector2(560, 650), origin.global_position)
	caught_indicator = origin
	anzuelo.speed = 0
	
func end_fishing(score):
	spawner.start()
	fish_line.clear_points()
	if score < min_time:
		%Bad.play()
		durabilidad -= 2
		fish_pic.scale = Vector2(0.2, 0.2)
	else:
		%Good.play()
		max_catch -= 1
		var fish_data = Global.fish_dictionary[fish_name]
		if !fish_data[-1]:
			fish_pic.self_modulate = Color(1, 1, 1, 1)
			fish_data[-1] = true
		fish_pic.scale = Vector2(1.3, 1.3)
		pescados += puntos # Dependiendo del pescado, asi funca??
		if (Global.blessings.get("Pico").get("enabled")==true):
			if(randi_range(1, 10)==10):
				pescados += puntos
		durabilidad -= 1
	await get_tree().create_timer(1.5).timeout
	blur.visible = false
	fish_pic.scale = Vector2(0.7, 0.7)
	if max_catch == 0:
		pescados = int(pescados)
		resultado_pesca.emit(pescados)
		queue_free()
	caught_indicator.queue_free()
	anzuelo.speed = 400
	

func _on_spawn_timeout() -> void:
	if Global.tutorial_index == 3:
		return
	var pos = fish_area.to_global(get_random_point())
	var indicador = indicador_pesca.instantiate()
	indicador.player = anzuelo
	indicador.global_position = pos
	add_child(indicador)

func triangulate_fish_area() -> void:
	var vertices = fish_area.polygon
	if vertices.size() < 3:
		return
		
	var indices = Geometry2D.triangulate_polygon(vertices)
	
	for i in range(0, indices.size(), 3):
		var p1 = vertices[indices[i]]
		var p2 = vertices[indices[i+1]]
		var p3 = vertices[indices[i+2]]
		
		var area = 0.5 * abs(p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y))
		
		total_area += area
		triangles.append([p1, p2, p3])
		triangle_cumulative_weights.append(total_area)
	
func get_random_point() -> Vector2:
	if triangles.is_empty():
		return Vector2.ZERO
		
	var roll = randf() * total_area
	var chosen_triangle: Array
	
	for i in range(triangle_cumulative_weights.size()):
		if roll <= triangle_cumulative_weights[i]:
			chosen_triangle = triangles[i]
			break
			
	var p1: Vector2 = chosen_triangle[0]
	var p2: Vector2 = chosen_triangle[1]
	var p3: Vector2 = chosen_triangle[2]
	
	var r1 = randf()
	var r2 = randf()
	if r1 + r2 > 1.0:
		r1 = 1.0 - r1
		r2 = 1.0 - r2
		
	return p1 + r1 * (p2 - p1) + r2 * (p3 - p1)
	
func _unhandled_input(ev: InputEvent) -> void:
	if ev is InputEventKey and ev.is_pressed():
		if ev.keycode == KEY_ESCAPE and !Global.tutorial_index == 3:
			pescados = int(pescados)
			resultado_pesca.emit(pescados)
			get_viewport().set_input_as_handled()
			queue_free()
		if ev.keycode == KEY_TAB:
			display_controls()
			
func display_controls():
	var dialogue = Global.dialogo.instantiate()
	dialogue.type = "Resumen"
	add_child(dialogue)
	dialogue.new_text([
		[[],
		"Controles de Pesca: \n
Esc = Volver a Navegación/terminar el juego \n
WASD = Movimiento para el indicador de anzuelo \n
Espacio = Subir la barra del jugador (durante modo de captura)"]
		])

func _physics_process(_delta: float) -> void:
	pass
