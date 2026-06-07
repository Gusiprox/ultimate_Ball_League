extends Node

enum Parte { CUERPO, OJO, PIE, BOCA, GORRA }

var lista_cuerpos: Array[Dictionary] = []
var lista_ojos: Array[Dictionary] = []
var lista_pies: Array[Dictionary] = []
var lista_bocas: Array[Dictionary] = []
var lista_gorras: Array[Dictionary] = []

func _ready() -> void:
	_cargar_carpeta("res://characters/models/bodys/", lista_cuerpos)
	_cargar_carpeta("res://characters/models/eyes/", lista_ojos)
	_cargar_carpeta("res://characters/models/foots/", lista_pies)
	_cargar_carpeta("res://characters/models/mouths/", lista_bocas)
	_cargar_carpeta("res://characters/models/hats/", lista_gorras)

func _getMeshById(id: String, parte: Parte) -> Mesh:
	var lista = getListByParte(parte)
	
	for diseno in lista:
		if diseno["nombre"] == id:
			return diseno["mesh"]
			
	# Si termina el bucle y no encuentra nada, avisa en consola y devuelve un diccionario vacío
	push_warning("No se encontró ningún diseño con el nombre '" + id + "' en la categoría especificada.")
	#Mirar si esto puede dar error
	return null

func getListByParte(parte: Parte) -> Array[Dictionary] :
	match parte:
		Parte.CUERPO:
			return lista_cuerpos
		Parte.OJO:
			return lista_ojos
		Parte.PIE:
			return lista_pies
		Parte.BOCA:
			return lista_bocas
		Parte.GORRA:
			return lista_gorras
		_:
			return []

func _cargar_carpeta(ruta: String, array_destino: Array[Dictionary]):
	var dir = DirAccess.open(ruta)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Comprobamos que sea un archivo de recurso
			if !dir.current_is_dir() and file_name.contains(".tres"):
				
				# 1. Obtenemos el nombre limpio SIN extensiones para el Diccionario
				# Quitamos .remap, .import y .tres para quedarnos solo con el nombre base (ej: "zapatos1")
				var nombre_limpio = file_name.replace(".remap", "").replace(".import", "").replace(".tres", "")
				
				# 2. Limpiamos la ruta completa para poder hacer el load() correctamente
				var ruta_limpia = ruta + file_name.replace(".remap", "").replace(".import", "")
				var res = load(ruta_limpia)
				
				if res is Mesh:
					# 3. Creamos el diccionario con la estructura que buscas
					var datos_mesh = {
						"nombre": nombre_limpio,
						"mesh": res
					}
					array_destino.append(datos_mesh)
					
			file_name = dir.get_next()
