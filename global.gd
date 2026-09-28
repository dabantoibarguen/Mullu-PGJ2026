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
	
}

var total_fish = 0
var total_mullu = 0
