extends Control

@onready var nav = get_parent().get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%EnergyBar.value = nav.energy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%EnergyBar.value = nav.energy
