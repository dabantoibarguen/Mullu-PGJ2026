extends Node2D

@onready var game = %Hand

func _ready() -> void:
	pass
	
func start():
	game.integrity = 100
	game.start_game()
