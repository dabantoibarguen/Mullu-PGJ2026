extends Node

var fish_dictionary = {
	# "nombre": [[profundidad(es)], [temperatura(s)], tamaño min, tamaño max,
	#             dificultad, [hora, marea (opcional), capturado?]
	"anchoveta": [["Mar bajo", "Mar Aeropuerto"], ["Frio"], 12, 20,
					1, ["Mañana"], false],
					
	"tiburón toyo": [["Mar medio", "Mar Profundo"], ["Frio"], 60, 120,
					4, ["Noche"], false], # Crear Madrugada?

	"mantarraya": [["Mar bajo"], ["Temperada", "Caliente"], 100, 220,
					5, ["Mediodía"], false],

	"chita": [["Mar bajo"], ["Frio", "Temperada"], 20, 40,
					3, ["Mañana"], false],

	"pez diablo": [["Mar medio"], ["Temperada"], 12, 27,
					4, ["Tarde"], false],

	"cangrejo": [["Mar bajo"], ["Frio", "Temperado"], 6, 10,
					2, ["Mañana", "Marea baja"], false],

	"pez globo": [["Mar profundo"], ["Temperado", "Caliente"], 18, 44,
					3, ["Mañana", "Marea baja"], false],
	
}

var mullu_dictionary = {
	
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
