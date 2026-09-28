extends Node

var fish_dictionary = {
	# "nombre": [[profundidad(es)], [temperatura(s)], tamaño min, tamaño max,
	#             dificultad, [hora, marea (opcional), capturado?]
	"anchoveta": [["Mar bajo", "Mar Aeropuerto"], ["Frio"], 12, 20,
					0, ["Mañana"], false],
					
	"tiburón toyo": [["Mar medio", "Mar Profundo"], ["Frio"], 60, 120,
					4, ["Noche"], false], # Crear Madrugada?

	"mantarraya": [["Mar bajo"], ["Temperada", "Caliente"], 100, 220,
					5, ["Mediodía"], false],

	"chita": [["Mar bajo"], ["Frio", "Temperado"], 20, 40,
					3, ["Mañana"], false],

	"pez diablo": [["Mar medio"], ["Temperado"], 12, 27,
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
