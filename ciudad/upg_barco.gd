extends Control

@onready var fish_counter = $CounterPescados/Label
var upgrades = Global.skilltree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fish_counter.text = str(Global.total_mullu)
	var children = self.get_children()
	for child in children:
		if child.name not in upgrades:
			continue
		var data = upgrades.get(child.name)
		child.text = data.get("label")
		if data.get("enabled") == true:
			child.disabled  = true
		child.get_node("Label").text = data.get("description") + "\nCosto: " + str(data.get("cost"))
		child.pressed.connect(_on_button_pressed.bind(child, data))
		child.mouse_entered.connect(_on_mouse_entered.bind(child))
		child.mouse_exited.connect(_on_mouse_exited.bind(child))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed(child, data) -> void:
	if Global.total_fish >= data.get("cost"):
		Global.total_fish -= data.get("cost")
		fish_counter.text = str(Global.total_mullu)
		Global.skilltree.get(child.name)["enabled"] = true
		child.disabled = true
	
func _on_mouse_entered(child) -> void:
	child.get_node("Label").visible=true
	
func _on_mouse_exited(child) -> void:
	child.get_node("Label").visible=false


func _on_exit_pressed() -> void:
	get_parent().get_parent().blur.visible = false




	
		
