extends CharacterBody2D

@onready var soga = %Soga
var playing = false

var speed = 175

func _ready() -> void:
	soga.add_point(Vector2(0, -20))
	soga.add_point(to_local(global_position))
	soga.add_point(global_position)
	
	
func _physics_process(delta: float) -> void:
	if playing:
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = direction * speed * delta
	
	if soga.points.size() > 20:
		for i in range(1, 19, 2):
			soga.remove_point(i)
	
	move_and_collide(velocity)
	soga.add_point(soga.to_local(global_position))
	
