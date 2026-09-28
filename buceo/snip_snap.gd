extends Node2D

@onready var game = %Hand

func _ready() -> void:
	pass
	
func start(origin):
	game.integrity = 100
	game.start_game(origin)
