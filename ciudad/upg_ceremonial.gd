extends Control

@onready var mullu_counter = $CounterMullus/Label
var blessings = Global.blessings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mullu_counter.text = str(Global.total_mullu)
	var children = self.get_children()
	for child in children:
		if child.name not in blessings:
			continue
		var data = blessings.get(child.name)
		child.text = data.get("label")
		if data.get("enabled") == true:
			child.disabled  = true
		child.get_node("Label").text = data.get("description") + "\nCosto: " + str(data.get("cost"))
		child.pressed.connect(_on_button_pressed.bind(child, data))
		child.mouse_entered.connect(_on_mouse_entered.bind(child))
		child.mouse_exited.connect(_on_mouse_exited.bind(child))



func _on_button_pressed(child, data) -> void:
	if Global.total_mullu >= data.get("cost"):
		Global.total_mullu -= data.get("cost")
		mullu_counter.text = str(Global.total_mullu)
		Global.blessings.get(child.name)["enabled"] = true
		child.disabled = true
	
func _on_mouse_entered(child) -> void:
	child.get_node("Label").visible=true
	
func _on_mouse_exited(child) -> void:
	child.get_node("Label").visible=false


func _on_exit_pressed() -> void:
	get_parent().get_parent().blur.visible = false
