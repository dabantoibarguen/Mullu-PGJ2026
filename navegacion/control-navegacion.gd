extends Node2D

@onready var main = %OceanMap
@onready var menu = %NavMenu
@onready var mLight = $MorningLight
@onready var aLight = $AfternoonLight
@onready var nLight = $NightLight

var pescado = 0
var mullu = 0

var temperatura = "Frio" # Mantener actualizado
var hora = "Mañana" 
var profundidad # Sacar esto del tile del barco
var junto_roca = false

var energy: int = 120:
	set(e):
		energy = e
		menu.update_energy(e)
		# Hacer ciclico, cambiar basado en inicial
		if(energy <= 40 and hora == "Tarde"):
			cambio_noche()
		elif(energy <= 80 and hora == "Mañana"):
			cambio_tarde()
# 80-120 mañana
# 40-79 tarde
# 0-39 noche

func _ready() -> void:
	menu.update_energy(energy)

func cambio_tarde():
	hora = "Tarde"
	var tween = create_tween()
	tween.tween_property(mLight, "energy", 0.0, 2)
	
	await tween.finished
	mLight.visible = false
	aLight.visible = true
		
	var tween2 = create_tween()
	tween2.tween_property(aLight, "energy", 1.0, 4)
	
	nLight.visible = false
	
func cambio_noche():
	hora = "Noche"
	mLight.visible = false
	
	var tween = create_tween()
	tween.tween_property(aLight, "energy", 0.0, 3)
	await tween.finished
	nLight.visible = true
	var tween2 = create_tween().set_parallel(true)
	tween2.tween_property(nLight, "energy", 0.8, 4)
	

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
	main.bucear()


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
	var mullus = Global.mullu_dictionary.keys()
	var deep_mullus = [] # max 4
	var side_mullus = [] # max 7
	var max_num = 50
	if profundidad == "Mar Medio":
		max_num += 20
	elif profundidad == "Mar Alto":
		max_num += 40
	if junto_roca:
		max_num += 10
		print("Dwayne Johnson")
		for i in range(0, 7):
			var rand = randf_range(0, max_num)
			print(rand)
	for i in range(4):
		var rand = randf_range(0, max_num)
		print(rand)
	
	return ""
