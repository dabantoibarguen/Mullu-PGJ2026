extends Control

var blessings = Global.blessings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




#extends Node
#
#var fish_dictionary = {
	## "nombre": [[profundidad(es)], [temperatura(s)], tamaño min, tamaño max,
	##             dificultad, [hora, marea (opcional), capturado?]
	#"anchoveta": [["Mar bajo", "Mar Aeropuerto"], ["Frio"], 12, 20,
					#1, ["Mañana"], false],
					#
	#"tiburón toyo": [["Mar medio", "Mar Profundo"], ["Frio"], 60, 120,
					#4, ["Noche"], false], # Crear Madrugada?
#
	#"mantarraya": [["Mar bajo"], ["Temperada", "Caliente"], 100, 220,
					#5, ["Mediodía"], false],
#
	#"chita": [["Mar bajo"], ["Frio", "Temperada"], 20, 40,
					#3, ["Mañana"], false],
#
	#"pez diablo": [["Mar medio"], ["Temperada"], 12, 27,
					#4, ["Tarde"], false],
#
	#"cangrejo": [["Mar bajo"], ["Frio", "Temperado"], 6, 10,
					#2, ["Mañana", "Marea baja"], false],
#
	#"pez globo": [["Mar profundo"], ["Temperado", "Caliente"], 18, 44,
					#3, ["Mañana", "Marea baja"], false],
	#
#}
#
#var mullu_dictionary = {
	#
#}
#
#var total_fish = 0
#var total_mullu = 0
#
#var blessings = {
	#"Night Vision" : {
		#"label" : "Vision Nocturna",
		#"description" : "Bendición de Shi. Incrementa la visibilidad en la oscuridad.",
		#"enabled" : false,
		#"price" : 1
	#},
	#"Sacred Sea" : {
		#"label" : "Mar Sagrado",
		#"description" : "Bendición de Shi. El mar será más abundante.",
		#"enabled" : false,
		#"price" : 1
	#} 
#}

func _on_button_pressed(child, data) -> void:
	if Global.total_mullu >= data.get("cost"):
		Global.total_mullu -= data.get("cost")
		Global.blessings.get(child.name)["enabled"] = true
		child.disabled = true
	
func _on_mouse_entered(child) -> void:
	child.get_node("Label").visible=true
	
func _on_mouse_exited(child) -> void:
	child.get_node("Label").visible=false


func _on_exit_pressed() -> void:
	get_parent().get_parent().blur.visible = false
