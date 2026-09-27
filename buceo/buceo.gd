extends CanvasLayer

@onready var blur = $AaronBlur
@onready var snipSnap = $AaronBlur/SnipGame
@onready var buceador = %Buceador
@onready var camara = %CamaraBuceo

signal resultado_buceo(mullu)

func _ready() -> void:
	pass
	
func _input(ev: InputEvent) -> void:
	if ev is InputEventKey:
		if ev.is_pressed() and ev.keycode == KEY_SPACE:
			blur.visible = true
			snipSnap.global_position = get_viewport().get_camera_2d().get_screen_center_position()
			buceador.playing = true
			snipSnap.start()
		elif ev.is_pressed() and ev.keycode == KEY_ESCAPE:
			resultado_buceo.emit(0)
			queue_free()
			
func end_snip(result = false):
	print(result)
	blur.visible = false
	buceador.playing = false
