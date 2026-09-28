extends Control

@onready var main = %BarraPesca

func start(origin, green_freq, win_time):
	main.start_fishing(origin, green_freq, win_time)
