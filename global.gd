extends Node

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
	# "nombre": [RNG Requerido, puntos]
	"Princeps Adulto": [95, 3],
	
	"Princeps Regular": [85, 2],
	
	"Princeps Bebe": [85, 2],
	
	"Calcifer Bebe": [70, 1],
	
	"Calcifer Rojizo": [50, 1],
	
	"Calcifer Morado": [50, 1],
	
	"Calcifer Regular": [25, 3]
}

var total_fish = 0
var total_mullu = 0

var blessings = {
	"Night Vision" : {
		"label" : "Vision Nocturna",
		"description" : "Bendición de Shi. Incrementa la visibilidad en la oscuridad.",
		"enabled" : false,
		"cost" : 1
	},
	"Sacred Sea" : {
		"label" : "Mar Sagrado",
		"description" : "Bendición de Shi. El mar será más abundante.",
		"enabled" : false,
		"cost" : 1
	},
	"Second Wind" : {
		"label" : 	"Segundo Aliento",
		"description" : "Bendición de Tacaynamo. Te hace más fácil capturar peces.",
		"enabled" : false,
		"cost" : 1
	}
}
