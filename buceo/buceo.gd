extends CanvasLayer

var mullu_scene = preload("res://buceo/spondylus.tscn")

@onready var blur = $AaronBlur
@onready var snipSnap = $AaronBlur/SnipGame
@onready var buceador = %Buceador
@onready var camara = %CamaraBuceo
@onready var area_profunda = $Ocean/Fondo
@onready var area_media = $Ocean/Medio

var can_escape = false

signal resultado_buceo(mullu)

var last_mullu

var mullus = 0

func _ready() -> void:
	populate_mullu(area_profunda)
	# if tile has rocks around (use neighbor call)
	#populate_mullu(area_media)
	
func populate_mullu(area):
	var size = area.shape.size
	for i in range(5):
		var x = randf_range(-size.x / 2, size.x / 2)
		var y = randf_range(-size.y / 2, size.y / 2)
		var spondylus = mullu_scene.instantiate()
		spondylus.player = buceador
		spondylus.global_position = (area.global_position + Vector2(x, y))
		add_child(spondylus)
			
func start_snip(tipo_mullu):
	last_mullu = tipo_mullu
	blur.visible = true
	snipSnap.global_position = camara.get_screen_center_position() + Vector2(0, 50)
	buceador.playing = true
	snipSnap.start(self)
			
func end_snip(result = false):
	if result:
		mullus += 1
	last_mullu.queue_free()
	blur.visible = false
	buceador.playing = false
	
func update_escape():
	if buceador.global_position.distance_to(Vector2(0, -150)) < 225:
		can_escape = true
	else:
		can_escape = false

func escape_safely():
	buceador.pull_back = true
	await get_tree().create_timer(1.0).timeout
	resultado_buceo.emit(mullus)
	queue_free()

func pass_out():
	blur.visible = false
	buceador.sprite.flip_v = true
	buceador.pull_back = true
	await get_tree().create_timer(1.5).timeout
	resultado_buceo.emit(0)
	queue_free()
	
