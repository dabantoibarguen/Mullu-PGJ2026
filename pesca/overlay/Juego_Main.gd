extends Control

@onready var main = %BarraPesca

func start(origin, green_freq, win_time):
	main.start_fishing(origin, green_freq, win_time)

func exit_fishing():
	main.exit_juego_fishing()
