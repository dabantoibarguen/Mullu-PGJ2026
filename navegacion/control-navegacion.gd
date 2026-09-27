extends Node2D

@onready var main = %OceanMap
@onready var menu = %NavMenu
@onready var mLight = $MorningLight
@onready var aLight = $AfternoonLight
@onready var nLight = $NightLight

var pescado = 0
var mullu = 0

var temperatura = 0
var hora = 0
var profundidad # Sacar esto del tile del barco

var energy: int = 120:
	set(e):
		energy = e
		menu.update_energy(e)
		if(energy <= 40 and hora == 1):
			hora = 2
			cambio_noche()
		elif(energy <= 80 and hora == 0):
			hora = 1
			cambio_tarde()
# 80-120 mañana
# 40-79 tarde
# 0-39 noche

func _ready() -> void:
	menu.update_energy(energy)

func cambio_tarde():
	hora = 1
	mLight.visible = false
	aLight.visible = true
	nLight.visible = false
	
func cambio_noche():
	hora = 2
	mLight.visible = false
	aLight.visible = false
	nLight.visible = true

func menu_nav():
	main.navegar()

func menu_psc():
	# Calcular que tipo de pescado basado en: tile atlas (profundidad), hora, temp, y modificadores
	main.pescar()

func menu_bco():
	# Calcular que tipo de mullu basado en: tile atlas (profundidad), hora, temp, roca in neighbors?
	main.bucear()
