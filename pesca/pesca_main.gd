extends Control

var indicador_pesca = preload("res://pesca/indicadores_pesca.tscn")
@onready var fish_area = %FishingArea
@onready var timer = $Spawn
@onready var anzuelo = %Anzuelo
@onready var blur = $AaronBlur
@onready var juegoPesca = $AaronBlur/JuegoPesca

signal resultados_pesca(result)

var caught_indicator

var triangles: Array[Array] = []
var triangle_cumulative_weights: PackedFloat32Array = []
var total_area: float = 0.0

func _ready() -> void:
	print("FUck")
	timer.wait_time = 1
	timer.start()
	triangulate_fish_area()

func go_fish(origin):
	caught_indicator = origin
	anzuelo.speed = 0
	blur.visible = true
	juegoPesca.start()
	
func end_fishing(score = 0):
	print("Puntaje: " + str(score))
	blur.visible = false
	caught_indicator.queue_free()
	anzuelo.speed = 400
	

func _on_spawn_timeout() -> void:
	var pos = fish_area.to_global(get_random_point())
	
	var indicador = indicador_pesca.instantiate()
	indicador.global_position = pos
	get_tree().current_scene.add_child(indicador)

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

func _physics_process(_delta: float) -> void:
	pass
