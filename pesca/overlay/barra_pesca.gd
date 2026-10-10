extends Control

@onready var player = $Player
@onready var green = $GoodArea
@onready var timer = $AreaVerde
@onready var gameTimer = $Pescando
@onready var req = $Required
@onready var actuales = $Actual

var controlPesca

var lowest_point = position.y + size.y
var highest_point = position.y
var half

var grav = 2.5
var green_time = 1
var game_time = 17
var minimum_time = 4
var active = true

var move_lock = false

var score = 0:
	set(s):
		if active:
			score = s
			if s <= 0.5 * minimum_time:
				actuales.add_theme_color_override("font_color", Color(0.716, 0.0, 0.0, 1.0))
			elif s < minimum_time:
				actuales.add_theme_color_override("font_color",  Color(0.627, 0.549, 0.0, 1.0))
			else:
				actuales.add_theme_color_override("font_color",  Color("008300ff"))
				exit_juego_fishing()
			actuales.text = str(snapped(s, 0.01))

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
	half = ((lowest_point-(green_h))/2)

func start_fishing(origin, freq = green_time, min_t = minimum_time):
	active = true
	player.position.y = lowest_point - player_h
	controlPesca = origin
	score = 0
	gameTimer.wait_time = game_time
	gameTimer.start()
	green.position = green_starting
	green_time = freq
	timer.wait_time = freq
	minimum_time = snapped(min_t, 0.01)
	req.text = "Requerido: " + str(minimum_time)
	timer.start()
	
func _on_pescando_timeout() -> void:
	exit_juego_fishing()

func exit_juego_fishing():
	active = false
	timer.stop()
	gameTimer.stop()
	controlPesca.end_fishing(score)


func _on_timer_timeout() -> void:
	move_green()

func move_player():
	if player.position.y - green_h > highest_point:
		player.position.y -= green_h
	else:
		player.position.y = highest_point
	move_lock = true

func _input(ev: InputEvent) -> void:
	if active and ev.is_pressed() and !move_lock:
		if ev is InputEventMouse:
			if ev.button_mask == MOUSE_BUTTON_LEFT:
				move_player()
		if ev is InputEventKey:
			if ev.keycode == KEY_SPACE:
				move_player()
		await get_tree().create_timer(0.12).timeout
		move_lock = false

func move_green():
	var rand_targ = randf_range(highest_point, lowest_point-(green_h))
	rand_targ = clamp(rand_targ, green.position.y - half, green.position.y + half)
	#var target = min(green.position.y - rand_targ, size.y/2)
	var time = green_time*10
	for i in range(time):
		green.position.y += float(rand_targ - green.position.y)/(time)
		green.position.y = clamp(green.position.y, highest_point, lowest_point - green_h)
		await get_tree().create_timer(0.06).timeout 
	#await get_tree().create_timer(0.2).timeout 
	

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
	
	
