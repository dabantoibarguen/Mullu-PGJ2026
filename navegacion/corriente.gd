extends Area2D

@export var temperature = "Caliente"


func _on_body_entered(body: Node2D) -> void:
	print(temperature)
