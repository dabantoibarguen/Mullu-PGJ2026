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

var deep_spawn
var mid_spawn

var last_mullu

var mullus = 0

func _ready() -> void:
	#print(deep_spawn, mid_spawn)
	populate_mullu()
	
func populate_mullu():
	var mullu_data = Global.mullu_dictionary
	var size_mid = area_media.shape.size
	var size_deep = area_profunda.shape.size
	for mid_mul in mid_spawn:
		#print(mid_mul)
		var x = randf_range(-size_mid.x / 2, size_mid.x / 2)
		var y = randf_range(-size_mid.y / 2, size_mid.y / 2)
		var spondylus = mullu_scene.instantiate()
		spondylus.player = buceador
		spondylus.scale = mullu_data[mid_mul][4]
		spondylus.global_position = (area_media.global_position + Vector2(x, y))
		add_child(spondylus)
		spondylus.update_pic(mullu_data[mid_mul][3], mullu_data[mid_mul][2], mid_mul[1])
	for deep_mul in deep_spawn:
		var x = randf_range(-size_deep.x / 2, size_deep.x / 2)
		var y = randf_range(-size_deep.y / 2, size_deep.y / 2)
		var spondylus = mullu_scene.instantiate()
		spondylus.player = buceador
		spondylus.scale = Global.mullu_dictionary[deep_mul][4]
		spondylus.global_position = (area_profunda.global_position + Vector2(x, y))
		add_child(spondylus)
		spondylus.update_pic(mullu_data[deep_mul][3], mullu_data[deep_mul][2], mullu_data[deep_mul][1])
			
func start_snip(tipo_mullu):
	last_mullu = tipo_mullu
	snipSnap.update_ind(last_mullu.img_s, last_mullu.hex_s)
	blur.visible = true
	snipSnap.global_position = camara.get_screen_center_position() + Vector2(0, 50)
	buceador.playing = true
	snipSnap.start(self)
			
func end_snip(result = false):
	if result:
		mullus += last_mullu.points
	#print(mullus)
	last_mullu.queue_free()
	blur.visible = false
	buceador.playing = false
	
func update_escape():
	if buceador.global_position.distance_to(Vector2(0, -150)) < 225:
		can_escape = true
	else:
		can_escape = false

func escape_safely():
	$Border/Top.set_deferred("disabled", true)
	buceador.pull_back = true
	await get_tree().create_timer(1.2).timeout
	resultado_buceo.emit(mullus)
	queue_free()

func pass_out():
	blur.visible = false
	buceador.sprite.flip_v = true
	$Border/Top.set_deferred("disabled", true)
	buceador.pull_back = true
	await get_tree().create_timer(1.6).timeout
	resultado_buceo.emit(0)
	queue_free()
