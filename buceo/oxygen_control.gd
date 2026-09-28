extends Control

var max_oxygen = 60
var oxygen = max_oxygen
@onready var oxygen_bar = %OxygenBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oxygen_bar.value = oxygen
	oxygen = max_oxygen
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_oxygen_timer_timeout() -> void:
	oxygen -= 1
	oxygen_bar.value = oxygen
	if oxygen <= max_oxygen/3:
		oxygen_bar.get_theme_stylebox("fill").bg_color = Color(0.716, 0.0, 0.0, 1.0)
