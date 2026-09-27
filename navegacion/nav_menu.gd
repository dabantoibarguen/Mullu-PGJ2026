extends CanvasLayer

@onready var navBtn = $Nav
@onready var pescaBtn = $Psc
@onready var buceoBtn = $Bco
@onready var energyText = $EnergyL
@onready var fishLabel = $PescaoL
@onready var mulluLabel = $MulluL

func _ready() -> void:
	pass
 
func _on_nav_pressed() -> void:
	get_tree().current_scene.menu_nav()

func _on_psc_pressed() -> void:
	get_tree().current_scene.menu_psc()


func _on_bco_pressed() -> void:
	get_tree().current_scene.menu_bco()

func time_change(time):
	print(time)

func update_energy(energy):
	energyText.text = str(energy)
	
func update_fish(fish):
		fishLabel.text = str(fish)
		
func update_mullu(mullu):
		mulluLabel.text = str(mullu)
