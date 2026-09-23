extends CharacterBody2D

@onready var buceador = %Buceador

var speed = 250

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "", "")
	
	velocity = direction * speed * delta
	
	if move_and_collide(velocity) == null:
		buceador.move_and_collide(velocity)
