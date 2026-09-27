extends Control

@onready var main = %BarraPesca

func start(origin):
	main.start_fishing(origin)
