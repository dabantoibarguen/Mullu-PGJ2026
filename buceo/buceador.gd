extends CharacterBody2D

@onready var soga = %Soga
@onready var sprite = $Sprite2D
var playing = false

var pull_back = false

var speed = 175

func _ready() -> void:
	if Global.blessings.get("Nado").get("enabled") == true:
		speed = 225
	soga.add_point(Vector2(0, -200))
	soga.add_point(to_local(global_position))
	soga.add_point(global_position)
	
	
func _physics_process(delta: float) -> void:
	# If oxygen runs out or the player escapes safely
	if pull_back:
		var pos = global_position
		velocity = pos.direction_to(Vector2(0, -200)) * delta * pos.distance_to(Vector2(0, -200))*1.5
		for i in range(1, soga.points.size()-2):
			soga.remove_point(i)
		soga.add_point(soga.to_local(global_position))
		move_and_collide(velocity)
		return
	elif playing or Global.tutorial_index == 5:
		return
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Mouse/mobile controls
	var mouse_pos = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and global_position.distance_to(mouse_pos) > 3:
		direction = global_position.direction_to(mouse_pos)
	
	
	
	if(direction[0]>0):
		sprite.flip_h = true
	elif(direction[0]<0):
		sprite.flip_h = false

	# Slows down closer to the bottom
	if global_position.y < 450:
		velocity = direction * speed * delta * 1.2
	else:
		velocity = direction * speed * delta
	
	if soga.points.size() > 20:
		for i in range(1, 19, 2):
			if i < soga.points.size()-1:
				soga.remove_point(i)
	
	move_and_collide(velocity)
	soga.add_point(soga.to_local(global_position))
	
