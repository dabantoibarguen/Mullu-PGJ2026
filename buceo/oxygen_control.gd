extends Control

var oxygen = 90
@onready var oxygen_bar = %OxygenBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oxygen_bar.value = oxygen
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_oxygen_timer_timeout() -> void:
	oxygen -= 1
	oxygen_bar.value = oxygen
