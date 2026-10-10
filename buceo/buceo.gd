extends CanvasLayer

var mullu_scene = preload("res://buceo/spondylus.tscn")

@onready var blur = $AaronBlur
@onready var snipSnap = $AaronBlur/SnipGame
@onready var buceador = %Buceador
@onready var camara = %CamaraBuceo
@onready var area_profunda = $Ocean/Fondo
@onready var area_media = $Ocean/Medio
@onready var m_click = $CanvasLayer/Click
@onready var m_label = $CanvasLayer/MulluL

var can_escape = false

signal resultado_buceo(mullu)

var deep_spawn
var mid_spawn

var last_mullu

var mullus = 0:
	set(m):
		mullus = m
		m_label.text = str(m)
		

func _ready() -> void:
	if (Global.blessings.get("Night Vision").get("enabled")==true):
		$Ocean/Buceador/BetterLight.visible = true
	if Global.tutorial and deep_spawn.size() < 2:
		deep_spawn.append("Calcifer Regular")
	#deep_spawn = Global.mullu_dictionary.keys() # FOR TESTING ALL POSSIBLE MULLU
	print(deep_spawn)
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
		spondylus.mullu_name = mid_mul
		spondylus.global_position = (area_media.global_position + Vector2(x, y))
		add_child(spondylus)
		spondylus.update_pic(mullu_data[mid_mul][3], mullu_data[mid_mul][2], mullu_data[mid_mul][1])
	for deep_mul in deep_spawn:
		var x = randf_range(-size_deep.x / 2, size_deep.x / 2)
		var y = randf_range(-size_deep.y / 2, size_deep.y / 2)
		var spondylus = mullu_scene.instantiate()
		spondylus.player = buceador
		spondylus.scale = Global.mullu_dictionary[deep_mul][4]
		spondylus.mullu_name = deep_mul
		spondylus.global_position = (area_profunda.global_position + Vector2(x, y))
		add_child(spondylus)
		spondylus.update_pic(mullu_data[deep_mul][3], mullu_data[deep_mul][2], mullu_data[deep_mul][1])
			
func start_snip(tipo_mullu):
	last_mullu = tipo_mullu
	tipo_mullu.playing = true
	m_click.visible = false
	snipSnap.update_ind(last_mullu.img_s, last_mullu.hex_s)
	blur.visible = true
	snipSnap.global_position = camara.get_screen_center_position() + Vector2(0, 50)
	buceador.playing = true
	snipSnap.start(self, tipo_mullu.mullu_name)
			
func end_snip(result = false):
	if result:
		mullus += last_mullu.points
	# print(mullus)
	m_click.visible = false
	last_mullu.queue_free()
	blur.visible = false
	buceador.playing = false
	
	
func update_escape():
	if buceador.global_position.distance_to(Vector2(0, -150)) < 225:
		can_escape = true
	else:
		can_escape = false

func end_buceo():
	$Border/Top.set_deferred("disabled", true)
	buceador.pull_back = true
	await get_tree().create_timer(1.5).timeout
	resultado_buceo.emit(mullus)
	queue_free()

func pass_out():
	if buceador.pull_back:
		return
	blur.visible = false # Must happen first to interrupt the game
	can_escape = false
	buceador.sprite.flip_v = true
	mullus = 0
	end_buceo()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_TAB:
			display_controls()
			
func display_controls():
	var dialogue = Global.dialogo.instantiate()
	dialogue.type = "Resumen"
	add_child(dialogue)
	dialogue.new_text([
		[[],
		"Controles de Buceo (Exploración): \n
WASD = Movimiento para el buceador \n
Mouse 1 = \n- Seleccionar Mullu (a distancia apropiada) 
\n - Presionar Escapar (a distancia apropiada)
\n\n Siguiente pagina para los controles de recorte"],
[[],
		"Controles de Buceo (Recorte): \n
A / Flecha Izquierda = Rotar mano hacia la izquierda \n
D / Flecha Derecha = Rotar mano hacia la derecha \n
W / Flecha Arriba = Avanzar mano en la dirección apuntada \n
S / Flecha Abajo = Retroceder mano en la dirección opuesta"]
		])
