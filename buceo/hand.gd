extends CharacterBody2D


@onready var trail = %PlayerTrail
@onready var target = %Shape
@onready var integrity_bar = %Integrity
@onready var indicator = %Indicator

var helper
var indicator_size

var move_speed = 150.0
var rotation_speed = 4.0

const MAX_STRAY = 10.0
const CORNER_RADIUS = 9.0

var next_vertex_index = 1
var seg_start
var seg_end

var damage_rate = 30.0
var integrity = 0

var target_points

var oldPos = position

var selected = false
var mouse_offset = Vector2.ZERO

var origin_scene

var spondylus_shapes = {
	"Princeps Adulto": PackedVector2Array([
		Vector2(-2.0, -40.0),    # central top

		Vector2(3.0, -33.0),
		Vector2(7.0, -36.0),     # upper-right spine
		Vector2(8.0, -28.0),
		Vector2(14.0, -32.0),    # upper-right long spine
		Vector2(13.0, -22.0),
		Vector2(18.0, -25.0),    # outer-right spine
		Vector2(15.0, -15.0),
		Vector2(18.0, -11.0),    # outer-right spine
		Vector2(12.0, -4.0),
		Vector2(9.0, 3.0),
		Vector2(4.0, 9.0),       # narrow base

		Vector2(-6.0, 9.0),
		Vector2(-11.0, 3.0),
		Vector2(-15.0, -4.0),
		Vector2(-22.0, -11.0),   # outer-left spine
		Vector2(-18.0, -15.0),
		Vector2(-21.0, -25.0),   # outer-left spine
		Vector2(-13.0, -22.0),
		Vector2(-14.0, -32.0),   # upper-left long spine
		Vector2(-9.0, -28.0),
		Vector2(-8.0, -36.0),    # upper-left spine
		Vector2(-4.0, -33.0)
	]),
	
	"Princeps Regular": PackedVector2Array([
		Vector2(0.0, -30.0),    # central top

		Vector2(4.0, -24.0),
		Vector2(8.0, -27.0),    # upper-right spike
		Vector2(10.0, -19.0),
		Vector2(15.0, -17.0),   # major right spike
		Vector2(12.0, -9.0),
		Vector2(14.0, -5.0),    # lower-right spike
		Vector2(8.0, 1.0),
		Vector2(5.0, 4.0),      # narrow base

		Vector2(-5.0, 4.0),
		Vector2(-8.0, 1.0),
		Vector2(-14.0, -5.0),   # lower-left spike
		Vector2(-12.0, -9.0),
		Vector2(-15.0, -17.0),  # major left spike
		Vector2(-10.0, -19.0),
		Vector2(-8.0, -27.0),   # upper-left spike
		Vector2(-4.0, -24.0)
	]),
	
	"Princeps Bebe": PackedVector2Array([
		Vector2(0.0, -23.0),    # central top

		Vector2(4.0, -19.0),
		Vector2(7.0, -21.0),    # upper-right spike
		Vector2(7.0, -15.0),
		Vector2(10.0, -13.0),   # right spike
		Vector2(8.0, -7.0),
		Vector2(9.0, -3.0),     # lower-right spike
		Vector2(5.0, 2.0),
		Vector2(3.0, 5.0),      # narrow base

		Vector2(-3.0, 5.0),
		Vector2(-5.0, 2.0),
		Vector2(-9.0, -3.0),    # lower-left spike
		Vector2(-8.0, -7.0),
		Vector2(-10.0, -13.0),  # left spike
		Vector2(-7.0, -15.0),
		Vector2(-7.0, -21.0),   # upper-left spike
		Vector2(-4.0, -19.0)
	]),
	
	"Calcifer Bebe": PackedVector2Array([
		Vector2(0.0, -22.0),
		Vector2(5.0, -19.0),
		Vector2(8.0, -13.0),
		Vector2(7.0, -7.0),
		Vector2(5.0, -2.0),
		Vector2(6.0, 3.0),
		Vector2(3.0, 5.0),

		Vector2(-3.0, 5.0),
		Vector2(-6.0, 3.0),
		Vector2(-5.0, -2.0),
		Vector2(-7.0, -7.0),
		Vector2(-8.0, -13.0),
		Vector2(-5.0, -19.0)
	]),

	"Calcifer Rojizo": PackedVector2Array([
		Vector2(0.0, -30.0),   
		Vector2(11.0, -23.0),
		Vector2(15.0, -10.0),
		Vector2(10.0, -3.0),
		Vector2(9.0, 2.0),
		
		Vector2(-9.0, 2.0),
		Vector2(-10.0, -3.0),
		Vector2(-15.0, -10.0),
		Vector2(-11.0, -23.0)
	]),

	"Calcifer Morado": PackedVector2Array([
		Vector2(0.0, -40.0),
		Vector2(14.0, -30.0),
		Vector2(18.0, -14.0),
		Vector2(12.0, 1.0),
		Vector2(10.0, 10.0),

		Vector2(-10.0, 10.0),
		Vector2(-12.0, 1.0),
		Vector2(-18.0, -14.0),
		Vector2(-14.0, -30.0)
	]),
	
	"Calcifer Regular": PackedVector2Array([
		Vector2(0.0, -30),
		Vector2(15, -10.0),
		Vector2(8, 2.0),
		Vector2(-8.0, 2.0),
		Vector2(-15, -10.0)
	])
}

func _ready():
	helper = Line2D.new()
	helper.default_color = Color("ffae00")
	helper.width = 1
	indicator_size = indicator.scale
	
func start_game(origin, tipo_mullu):
	# To end the game properly and pass the signal	
	origin_scene = origin
	
	# Picking the proper shape
	target_points = spondylus_shapes[tipo_mullu] 
	target.points = target_points
	
	indicator.scale = indicator_size
	
	# Resetting the necessary parameters to play a new round
	integrity_bar.value = integrity # SnipSnap sets this to 100 when starting a new one
	integrity_bar.get_theme_stylebox("fill").bg_color = Color("3b6125")
	helper.clear_points()
	trail.clear_points()
	rotation = 0
	next_vertex_index = 1
	
	global_position = target.to_global(target_points[0])
	trail.add_point(trail.to_local(global_position))
	helper.add_point(trail.to_local(global_position)) # This one will be deleted, deal with it
	helper.add_point(trail.to_local(global_position))
	update_segment()
	indicator.visible = true
	get_parent().add_child(helper)

func update_segment():
	target_points = target.points
	var total_points = target_points.size()
	if total_points >= 2:
		seg_start = target.to_global(target_points[(next_vertex_index - 1) % total_points])
		seg_end = target.to_global(target_points[(next_vertex_index) % total_points])
	indicator.global_position = seg_end
	helper.add_point(trail.to_local(seg_end))
	helper.remove_point(0)
		
func end_game(victory):
	await get_tree().create_timer(1).timeout 
	get_parent().remove_child(helper)
	origin_scene.end_snip(victory)
	# Add way to end the sub mini game with a unique node name



func _physics_process(delta: float) -> void:
	if integrity <= 0:
		return
	
	var mouse_pos = get_global_mouse_position()
	if selected and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		global_position = get_global_mouse_position()
		
	
	# Left and right inputs
	var rotation_dir = Input.get_axis("ui_left", "ui_right")
	global_rotation += rotation_dir * rotation_speed * delta
	
	# Forwards or backwards
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * move_speed * delta
	elif Input.is_action_pressed("ui_down"):
		velocity = Vector2.DOWN.rotated(rotation) * move_speed * delta
	else:
		velocity = Vector2.ZERO
	

	move_and_collide(velocity)
	
	# Keep the tracer and integrity detection going
	var closest_point = Geometry2D.get_closest_point_to_segment(global_position, seg_start, seg_end)
	var current_drift = global_position.distance_to(closest_point)
	trail.default_color = Color("008300ff")
	if current_drift > MAX_STRAY:
		trail.default_color = Color("9e000cff")
		integrity -= damage_rate * delta * (current_drift/MAX_STRAY)
		integrity_bar.value = integrity
		if integrity <= 0.0:
			%Bad.play()
			end_game(false)
			return
		elif integrity <= 33:
			integrity_bar.get_theme_stylebox("fill").bg_color = Color(0.716, 0.0, 0.0, 1.0)
		elif integrity <= 66:
			integrity_bar.get_theme_stylebox("fill").bg_color = Color(0.627, 0.549, 0.0, 1.0)
		

	if global_position.distance_to(seg_end) <= CORNER_RADIUS:
		if next_vertex_index < target_points.size():
			next_vertex_index += 1
			update_segment()
		else:
			indicator.position = Vector2.ZERO
			indicator.scale = Vector2(0.6, 0.6)
			integrity = 0 # SUPER IMPORTANT TO STOP THE GAME
			%Good.play()
			end_game(true)
	
	if global_position != oldPos:
		trail.add_point(trail.to_local(global_position))
		oldPos = global_position
			

func _on_detection_mouse_entered() -> void:
	selected = true


func _on_detection_mouse_exited() -> void:
	selected = false
