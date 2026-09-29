extends Node2D

@onready var main = %OceanMap
@onready var menu = %NavMenu
@onready var mLight = $MorningLight
@onready var aLight = $AfternoonLight
@onready var nLight = $NightLight

@onready var map_temprano = %"Mapa Temprano"
@onready var map_tarde = %"Mapa Tarde"
@onready var map_noche = %"Mapa Noche"

var pescado = 0
var mullu = 0

var fished_tiles = []
var dived_tiles = []

var temperatura = "Frio" # Mantener actualizado
var hora = "Mañana" 
var profundidad # Sacar esto del tile del barco
var junto_roca = false

var max_energy = 150

var energy = max_energy:
	set(e):
		energy = e
		menu.update_energy(max(e, 0))
		# Hacer ciclico, cambiar basado en inicial
		if(energy <= (float(1)/3*max_energy) and hora == "Tarde"):
			cambio_noche()
		elif(energy <= (float(2)/3*max_energy) and hora == "Mañana"):
			cambio_tarde()

func _ready() -> void:
	if (Global.blessings.get("Vigor").get("enabled")==true):
		max_energy+=30
		energy = max_energy
	var tween = create_tween()
	tween.tween_property($BGM_Nav, "volume_db", 0.0, 0.5)
	if Global.tutorial:
		var dialogue = Global.dialogo.instantiate()
		add_child(dialogue)
		dialogue.new_text([
	[["Ninan"], "¡Hermano! Finalmente estamos en el mar. ¿Qué hacemos?"],
	[["Rumi"], "Lo primero es movernos. ¡Ayúdame con el remo!"],
	[[], "Instrucciones:\n- Haz clic en el boton \"Navegar\" o presiona la Tecla \"1\" para iniciar el modo de navegación.\n\n	Podras ver las casillas navegables conectadas con una línea verde. Haz clic a la casilla a la cual desees moverte ¡pero recuerda que cada casilla te costara energía!"]
		])
		menu.navBtn.disabled = false
		menu.pescaBtn.disabled = true
		menu.buceoBtn.disabled = true
	menu.update_energy(energy)
	

func cambio_tarde():
	hora = "Tarde"
	var tween5 = create_tween()
	tween5.tween_property($BGM_Nav, "volume_db", -80.0, 0.5)
	
	var tween6 = create_tween()
	tween5.tween_property($BGM_NavTarde, "volume_db", -8.0, 0.5)
	
	
	main.tile_map_data = map_tarde.tile_map_data
	var tween = create_tween()
	tween.tween_property(mLight, "energy", 0.0, 2)
	
	aLight.visible = true
	var tween2 = create_tween()
	tween2.tween_property(aLight, "energy", 1.3, 4)
	await tween.finished
	mLight.visible = false
	#nLight.visible = false
	
func cambio_noche():
	main.tile_map_data = map_noche.tile_map_data
	hora = "Noche"
	if (Global.blessings.get("Night Vision").get("enabled")==false):
		main.boat.vision_range = 1
	mLight.visible = false
	
	var tween = create_tween()
	tween.tween_property(aLight, "energy", 0.0, 2)
	
	nLight.visible = true
	var tween2 = create_tween().set_parallel(true)
	tween2.tween_property(nLight, "energy", 2.1, 4)
	
	await tween.finished
	aLight.visible = false
	

func menu_nav():
	main.navegar()

func menu_psc():
	# Calcular que tipo de pescado basado en: tile atlas (profundidad), hora, temp, y modificadores
	profundidad = main.get_profundidad()
	var fish = randomize_fish()
	main.pescar(fish)

func menu_bco():
	# Calcular que tipo de mullu basado en: tile atlas (profundidad), hora, temp, roca in neighbors?
	profundidad = main.get_profundidad()
	var mullu = randomize_mullu()
	main.bucear(mullu)


# ------ randomizing functions for pesca/buceo -------
func randomize_fish():
	var possible_fish = {}
	var total_odds = 0
	var the_fish = ""
	var size = 0
	var fishes = Global.fish_dictionary.keys()
	for name in fishes:
		var met = 0
		var criteria = Global.fish_dictionary[name]
		if profundidad in criteria[0]:
			met += 1
		if temperatura in criteria[1]:
			met += 1
		if hora in criteria[5]:
			met += 1
		if met >= 1:
			total_odds += (6 - criteria[4]) * (met/2)
			possible_fish[name] = [total_odds, met]
	var rand = randf_range(0, total_odds)
	for fish in possible_fish.keys():
		if rand < possible_fish[fish][0]:
			the_fish = fish
			break
	size += randi_range(0, 40) + (15*possible_fish[the_fish][1]) + 15 
	# met * 15 + 15 allows for 20% chance per condition met, funny.
	return [the_fish, size]
		
func randomize_mullu():
	var mullus = Global.mullu_dictionary
	var deep_mullus = [] # max 4
	var mid_mullus = [] # max 7
	var deep_qty = 3
	var mid_qty = 5
	var max_num = 45
	if temperatura == "Caliente":
		max_num += 5
	elif temperatura == "Frio":
		max_num -= 5
	if profundidad == "Mar Medio":
		max_num += 20
		deep_qty += 1
		mid_qty += 1
	elif profundidad == "Mar Alto":
		max_num += 40
		deep_qty += 2
		mid_qty += 2
	if junto_roca:
		max_num += 10
		for i in range(0, mid_qty):
			var rand = randf_range(0, max_num)

			for mul in mullus:
				if rand > mullus[mul][0]:
					mid_mullus.append(mul)

					break


	for i in range(deep_qty):
		var rand = randf_range(0, max_num)

		for mul in mullus:
				if rand > mullus[mul][0]:

					deep_mullus.append(mul)
					break
	return [deep_mullus, mid_mullus]
