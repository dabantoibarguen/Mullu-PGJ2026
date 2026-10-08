extends Area2D

var player
var catchable = false
var points
var img_s
var hex_s
var mullu_name

@onready var btn = $Foto

var playing = false

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var dist = global_position.distance_to(player.global_position)
	if(dist<90) and !playing:
		catchable = true
		get_parent().m_click.visible = true
	else:
		if catchable:
			get_parent().m_click.visible = false
		catchable = false

func _on_foto_pressed() -> void:
	if catchable:
		get_parent().start_snip(self)
		

func update_pic(img, hex, mul):
	var style = StyleBoxTexture.new()
	style.texture = load(img)
	points = mul
	hex_s = hex
	img_s = img
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", style)
	btn.add_theme_stylebox_override("pressed", style)
	btn.add_theme_stylebox_override("focus", style)
	btn.self_modulate = Color(hex)
