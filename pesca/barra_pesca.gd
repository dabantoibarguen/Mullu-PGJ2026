extends ColorRect

@onready var player = $Player
@onready var green = $GoodArea
@onready var timer = $AreaVerde

var lowest_point = position.y + self.size.y
var highest_point = position.y
@export var grav = 0.3
@export var green_time = 1

var score = 0

var player_h
var player_y

var green_h
var green_top
var green_bottom

func _ready() -> void:
	timer.wait_time = 1
	timer.start()
	player_h = player.size.y
	green_h = green.size.y


func _on_timer_timeout() -> void:
	move_green()

func _input(ev: InputEvent) -> void:
	if ev is InputEventKey and ev.is_pressed():
		if ev.keycode == KEY_SPACE:
			if player.position.y - 7 > highest_point:
				player.position.y -= 7
			else:
				player.position.y = highest_point

func move_green():
	var rand_targ = randf_range(highest_point, lowest_point-green_h)
	var target = min(green.position.y - rand_targ, size.y/2)
	var time = 10*green_time
	for i in range(time):
		green.position.y -= (target)/(time)
		await get_tree().create_timer(0.08).timeout 
	await get_tree().create_timer(0.2).timeout 
	

func _physics_process(delta: float) -> void:
	green_top = green.position.y
	green_bottom = green_top+green_h
	player_y = player.position.y
	if green_top < (player_y + player_h) and player_y < green_bottom:
		player.color = Color(32.902, 0.0, 16.728, 1.0)
		score += delta # Number of seconds in the green area
	else:
		player.color = Color(255, 255, 255)
	
	if (player_y + player_h) < lowest_point:
		player.position.y += grav * delta * 100
	else:
		player.position.y = lowest_point - player_h
	print(score)
	
	
