extends CanvasLayer

var mullu_scene = preload("res://buceo/spondylus.tscn")

@onready var blur = $AaronBlur
@onready var snipSnap = $AaronBlur/SnipGame
@onready var buceador = %Buceador
@onready var camara = %CamaraBuceo
@onready var area_profunda = $Ocean/Fondo
@onready var area_media = $Ocean/Medio

signal resultado_buceo(mullu)

var last_mullu

var mullus = 0

func _ready() -> void:
	populate_mullu(area_profunda)
	# if tile has rocks around (use neighbor call)
	#populate_mullu(area_media)
	
func populate_mullu(area):
	var size = area.shape.size
	print(size)
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
	last_mullu.queue_free()
	blur.visible = false
	buceador.playing = false
