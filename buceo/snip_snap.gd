extends Node2D

@onready var game = %Hand
@onready var indic = %Indicator

func _ready() -> void:
	pass
	
func start(origin, tipo_mullu):
	game.integrity = 100
	game.start_game(origin, tipo_mullu)

func update_ind(img, hex):
	indic.texture = load(img)
	indic.modulate = Color(hex)
