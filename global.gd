extends Node

var dialogo = preload("res://dialogo.tscn")

var tutorial = true
var tutorial_index = 0:
	set(i):
		tutorial_index = i
		match i:
			1: get_tree().change_scene_to_file("res://navegacion/navegacion.tscn")
			2: print("oh my ga")
				
		
var fish_dictionary = {
	# "nombre": [[profundidad(es)], [temperatura(s)], tamaño min, tamaño max,
	#             dificultad, [hora], punto min, punto max capturado?]
	"anchoveta": [["Mar Bajo", "Mar Medio"], ["Frio", "Temperado"], 12, 20,
					0, ["Mañana"], 10, 30, false],
					
	"tiburón toyo": [["Mar Medio", "Mar Alto"], ["Frio"], 60, 120,
					5, ["Noche"], 120, 320, false], # Crear Madrugada?

	"mantarraya": [["Mar Bajo"], ["Temperada", "Caliente"], 100, 220,
					4, ["Mediodía"], 100, 220, false],

	"chita": [["Mar Bajo"], ["Temperado"], 20, 40,
					3, ["Mañana"], 80, 190, false],

	"pez diablo": [["Mar Medio"], ["Temperado"], 12, 27,
					4, ["Tarde"], 100, 270, false],

	"cangrejo": [["Mar Bajo"], ["Frio", "Temperado"], 6, 10,
					1, ["Mañana"], 20, 80, false],

	"pez globo": [["Mar Alto"], ["Temperado", "Caliente"], 18, 44,
					2, ["Mañana"], 60, 160, false]
}

var mullu_dictionary = {
	# "nombre": [RNG Requerido, puntos, img, #hex, scale]
	"Princeps Adulto": [96, 2, "7A1F3D", "res://buceo/assets/spondulus princeps.png", Vector2(1.4, 1.4)],
	
	"Princeps Regular": [87, 2, "ffffff","res://buceo/assets/spondulus princeps.png", Vector2(1, 1)],
	
	"Princeps Bebe": [87, 2, "F07A7F", "res://buceo/assets/spondulus princeps.png", Vector2(0.7, 0.7)],
	
	"Calcifer Bebe": [74, 1, "F2A65A", "res://buceo/assets/spondulus calcifer.png", Vector2(0.7, 0.7)],
	
	"Calcifer Rojizo": [55, 1, "B84A3A", "res://buceo/assets/spondulus calcifer.png", Vector2(1, 1)],
	
	"Calcifer Morado": [55, 1, "744A8C", "res://buceo/assets/spondulus calcifer.png", Vector2(1.4, 1.4)],
	
	"Calcifer Regular": [30, 1, "ffffff", "res://buceo/assets/spondulus calcifer.png", Vector2(1, 1)]
}

var total_fish = 0
var total_mullu = 0

var blessings = {
	"Night Vision" : {
		"label" : "Vision Nocturna",
		"description" : "Bendición de Shi. Mejora la visibilidad en las profundidades.",
		"enabled" : false,
		"cost" : 1
	},
	"Sacred Sea" : {
		"label" : "Mar Sagrado",
		"description" : "Bendición de Shi. El mar será más abundante en algunos lugares.",
		"enabled" : false,
		"cost" : 1
	},
	"Second Wind" : {
		"label" : 	"Segundo Aliento",
		"description" : "Bendición de Tacaynamo. Te hace más fácil capturar peces.",
		"enabled" : false,
		"cost" : 1
	},
	"Vigor" : {
		"label" : 	"Cuerpo Vigoroso",
		"description" : "Bendición de Tacaynamo. Amuenta tu energia al navegar.",
		"enabled" : false,
		"cost" : 1
	},
	"Pico" : {
		"label" : 	"Pico de Pelícano",
		"description" : "Bendicion de Pelícano. Te da la oportunidad de atrapar más peces.",
		"enabled" : false,
		"cost" : 1
	},
	"Nado" : {
		"label" : 	"Segundo Aliento",
		"description" : "Bendición de Pelícano. Te ayudara a explorar las aguas profundas.",
		"enabled" : false,
		"cost" : 1
	}
}
