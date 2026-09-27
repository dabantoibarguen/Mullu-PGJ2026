extends Node2D

@onready var main = %OceanMap
@onready var menu = %NavMenu
@onready var mLight = $MorningLight
@onready var aLight = $AfternoonLight
@onready var nLight = $NightLight

var pescado = 0
var mullu = 0

var temperatura = 0
var hora = "Mañana"
var profundidad # Sacar esto del tile del barco

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
	main.pescar()

func menu_bco():
	# Calcular que tipo de mullu basado en: tile atlas (profundidad), hora, temp, roca in neighbors?
	main.bucear()
