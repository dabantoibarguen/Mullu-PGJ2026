extends Control

@onready var barra = $BarraPesca
@onready var player = $Player
@onready var green = $GoodArea
@onready var timer = $AreaVerde
@onready var gameTimer = $Pescando

var controlPesca

var lowest_point = position.y + size.y
var highest_point = position.y
var grav = 0.3
var green_time = 1
var game_time = 17
var minimum_time = 4

var score = 0

var player_h
var player_y

var green_starting
var green_h
var green_top
var green_bottom

func _ready() -> void:
	player_h = player.size.y
	if Global.blessings.get("Second Wind").get("enabled") == true:
		green.size.y = green.size.y * 1.2
	green_h = green.size.y
	green_starting = green.position

func start_fishing(origin, freq = green_time, min = minimum_time):
	controlPesca = origin
	score = 0
	gameTimer.wait_time = game_time
	gameTimer.start()
	green.position = green_starting
	green_time = 1
	timer.wait_time = freq
	minimum_time = min
	timer.start()
	
func _on_pescando_timeout() -> void:
	timer.stop()
	gameTimer.stop()
	controlPesca.end_fishing(score)


func _on_timer_timeout() -> void:
	move_green()

func _input(ev: InputEvent) -> void:
	if ev is InputEventKey and ev.is_pressed():
		if ev.keycode == KEY_SPACE:
			if player.position.y - 8 > highest_point:
				player.position.y -= 8
			else:
				player.position.y = highest_point

func move_green():
	var rand_targ = randf_range(highest_point, lowest_point-(green_h))
	var target = min(green.position.y - rand_targ, size.y/2)
	var time = int(game_time*green_time)
	for i in range(time):
		green.position.y = clamp(green.position.y - (target)/(time), highest_point, lowest_point-(green_h))
		await get_tree().create_timer(0.1).timeout 
	await get_tree().create_timer(0.3).timeout 
	

func _physics_process(delta: float) -> void:
	green_top = green.position.y
	green_bottom = green_top+green_h
	player_y = player.position.y
	if green_top < (player_y + player_h) and player_y < green_bottom:
		player.color = Color("ed9b3f")
		score += delta # Number of seconds in the green area
	else:
		player.color = Color("f5dad5")
	
	if (player_y + player_h) < lowest_point:
		player.position.y += grav * delta * 100
	else:
		player.position.y = lowest_point - player_h
	
	
