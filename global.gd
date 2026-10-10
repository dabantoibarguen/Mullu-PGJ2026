extends Node

var dialogo = preload("res://dialogo.tscn")
var navegar_scn = preload("res://navegacion/navegacion.tscn")

var tutorial = true
var tutorial_index = 0:
	set(i):
		tutorial_index = i
		match i:
			1: get_tree().change_scene_to_packed(navegar_scn)
		
var fish_quota = 250

var total_fish = 0
var total_mullu = 0
	
var fish_dictionary = {
	# "nombre": [[profundidad(es)], [temperatura(s)], tamaño min, tamaño max,
	#             dificultad, [hora], punto min, punto max capturado?]
	"anchoveta": [["Mar Bajo", "Mar Medio"], ["Frio", "Temperado"], 12, 20,
					0, ["Mañana"], 10, 30, false],

	"tiburón toyo": [["Mar Medio", "Mar Alto"], ["Frio"], 60, 120,
					5, ["Noche"], 200, 600, false], # Crear Madrugada?

	"mantarraya": [["Mar Bajo"], ["Temperada", "Caliente"], 100, 220,
					4, ["Mediodía"], 140, 480, false],

	"chita": [["Mar Bajo"], ["Temperado"], 20, 40,
					3, ["Mañana"], 80, 240, false],

	"pez diablo": [["Mar Medio"], ["Temperado"], 12, 27,
					4, ["Tarde"], 140, 480, false],

	"cangrejo": [["Mar Bajo"], ["Frio", "Temperado"], 6, 10,
					1, ["Mañana"], 20, 50, false],

	"pez globo": [["Mar Alto"], ["Temperado", "Caliente"], 18, 44,
					2, ["Mañana"], 40, 110, false]
}

var mullu_dictionary = {
	# "nombre": [RNG Requerido, puntos, img, #hex, scale]
	"Princeps Adulto": [96, 2, "7A1F3D", "res://buceo/assets/spondulus princeps.png", Vector2(1.4, 1.4)],
	
	"Princeps Regular": [86, 2, "ffffff","res://buceo/assets/spondulus princeps.png", Vector2(1, 1)],
	
	"Princeps Bebe": [86, 2, "F07A7F", "res://buceo/assets/spondulus princeps.png", Vector2(0.7, 0.7)],
	
	"Calcifer Bebe": [73, 1, "F2A65A", "res://buceo/assets/spondulus calcifer.png", Vector2(0.7, 0.7)],
	
	"Calcifer Rojizo": [53, 1, "B84A3A", "res://buceo/assets/spondulus calcifer.png", Vector2(1, 1)],
	
	"Calcifer Morado": [53, 1, "744A8C", "res://buceo/assets/spondulus calcifer.png", Vector2(1.4, 1.4)],
	
	"Calcifer Regular": [27, 1, "ffffff", "res://buceo/assets/spondulus calcifer.png", Vector2(1, 1)]
}

var skilltree = {
	"Anzuelo 1": {
		"label" : "Anzuelo de cobre",
		"description" : "Un anzuelo ligeramente mejorado hecho a partir de cobre. Casi no se oxida",
		"enabled" : false,
		"cost" : 500
	},
 "Anzuelo 2" : {
		"label" : "Anzuelo platinado",
		"description" : "Un anzuelo hecho de plata, me pregunto cómo habrá llegado aquí",
		"enabled" : false,
		"cost" : 1000
},
"Anzuelo 3" : {
		"label" : "Anzuelo de oro",
		"description" : "Este anzuelo es casi tan bonito que usarlo se siente como un crimen",
		"enabled" : false,
		"cost" : 1500
},
"Remo mejorado" : {
		"label" : "Remo de algarrobo",
		"description" : "Este remo ha sido esculpido por los mejores artesanos. No se trata solo de moverse más rápido, sino de hacerlo con estilo",
		"enabled" : false,
		"cost" : 2000
}
}

var blessings = {
	"Night Vision" : {
		"label" : "Vision Nocturna",
		"description" : "Bendición de Shi, diosa de la luna. Mejora la visibilidad en las profundidades.",
		"enabled" : false,
		"cost" : 3
	},
	"Sacred Sea" : {
		"label" : "Mar Sagrado",
		"description" : "Bendición de Shi, diosa de la luna. El mar será más abundante.",
		"enabled" : false,
		"cost" : 3
	},
	"Second Wind" : {
		"label" :     "Instinto Pescador",
		"description" : "Bendición de Tacaynamo, el fundador. Te hace más fácil capturar peces.",
		"enabled" : false,
		"cost" : 3
	},
	"Vigor" : {
		"label" :     "Cuerpo Vigoroso",
		"description" : "Bendición de Tacaynamo, el fundador. Aumenta tu energia al navegar.",
		"enabled" : false,
		"cost" : 3
	},
	"Pico" : {
		"label" :     "Pico de Pelícano",
		"description" : "Bendicion del Pelícano, el ave rey. Te da la oportunidad de atrapar más peces.",
		"enabled" : false,
		"cost" : 3
	},
	"Nado" : {
		"label" : "Buceo Sagrado",
		"description" : "Bendición del Pelícano, el ave rey. Te ayudara a explorar las aguas profundas.",
		"enabled" : false,
		"cost" : 3
	}
}
