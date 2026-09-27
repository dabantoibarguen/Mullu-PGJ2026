extends Node

var fish_dictionary = {
	# "nombre": [[profundidad(es)], [temperatura(s)], tamaño min, tamaño max,
	#             dificultad, [hora, marea (opcional)]
	"anchoveta": [["Mar bajo", "Mar Aeropuerto"], ["Frio"], 12, 20,
					1, ["Mañana"]],
					
	"tiburón toyo": [["Mar medio", "Mar Profundo"], ["Frio"], 60, 120,
					4, ["Noche"]], # Crear Madrugada?

	"mantarraya": [["Mar bajo"], ["Temperada", "Caliente"], 100, 220,
					5, ["Mediodía"]],

	"chita": [["Mar bajo"], ["Frio", "Temperada"], 20, 40,
					3, ["Mañana"]],

	"pez diablo": [["Mar medio"], ["Temperada"], 12, 27,
					4, ["Tarde"]],

	"cangrejo": [["Mar bajo"], ["Frio", "Temperado"], 6, 10,
					2, ["Mañana", "Marea baja"]],

	"pez globo": [["Mar profundo"], ["Temperado", "Caliente"], 18, 44,
					3, ["Mañana", "Marea baja"]],
	
}

var mullu_dictionary = {
	
}

var total_fish = 0
var total_mullu = 0
