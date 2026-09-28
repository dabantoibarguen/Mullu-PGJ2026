extends CharacterBody2D

@onready var soga = %Soga
@onready var sprite = $Sprite2D
var playing = false

var pull_back = false

var speed = 175

func _ready() -> void:
	soga.add_point(Vector2(0, -20))
	soga.add_point(to_local(global_position))
	soga.add_point(global_position)
	
	
func _physics_process(delta: float) -> void:
	if pull_back:
		var pos = global_position
		velocity = pos.direction_to(Vector2(0, -150)) * delta * pos.distance_to(Vector2(0, -150))*1.5
		for i in range(1, soga.points.size()-2):
			soga.remove_point(i)
		soga.add_point(soga.to_local(global_position))
		move_and_collide(velocity)
		return
	elif playing:
		return
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if(direction[0]>0):
		sprite.flip_h = true
	elif(direction[0]<0):
		sprite.flip_h = false

	
	velocity = direction * speed * delta
	
	if soga.points.size() > 20:
		for i in range(1, 19, 2):
			if i < soga.points.size()-1:
				soga.remove_point(i)
	
	move_and_collide(velocity)
	soga.add_point(soga.to_local(global_position))
	
