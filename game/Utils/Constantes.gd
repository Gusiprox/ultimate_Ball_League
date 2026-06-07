class_name Constantes

const MSG_EMPATE: String = "Empate"
const MSG_GOL: String = "GOL {equipo} | Azul: {azules} Rojo: {rojos}"
const MSG_FINAL: String = "FINAL: {resultado} | Azul: {azules} Rojo: {rojos}"

const ANCHO_MAPA: int = 7
const LARGO_MAPA: int = 14

const TAMANO_CASILLA: float = 1.1
const ALTURA_PERSONAJE: float = 0.5

const TURNOS_PARTIDO: int = 25
const TURNOS_PRORROGA: int = 10

const VALOR_UNIVERSAL_TURNO: float = 1000.0

const LINEA_GOL_AZUL: int = 13
const LINEA_GOL_ROJO: int = 0

const EQUIPO_AZUL: String = "azul"
const EQUIPO_ROJO: String = "rojo"

const COLOR_CURSOR_ENCIMA: Color = Color(0, 1, 0)
const COLOR_DISPONIBLE: Color = Color(1, 1, 0)
const COLOR_NORMAL: Color = Color(1, 1, 1)

const COLOR_EQUIPO_AZUL: Color = Color.BLUE
const COLOR_EQUIPO_ROJO: Color = Color.RED

const DIRECCIONES_CARDINALES: Array[Vector2i] = [
	Vector2i(0, -1),
	Vector2i(0, 1),
	Vector2i(-1, 0),
	Vector2i(1, 0)
]

const COOLDOWN_DOS_TURNOS: int = 2
const COOLDOWN_TRES_TURNOS: int = 3

const STATS_FUERZA_EMPUJE: String = "fuerzaEmpuje"
const STATS_RESISTENCIA_EMPUJE: String = "resistenciaEmpuje"

const DICTIONARY_KEY_BLOQUEADO: String = "Bloqueado"
const DICTIONARY_KEY_ENEMIGO: String = "Enemigo"
const DICTIONARY_KEY_POSICION: String = "Posicion"
const DICTIONARY_KEY_DISTANCIA: String = "Distancia"
const DICTIONARY_KEY_CASILLAS: String = "Casillas"
const DICTIONARY_KEY_POSICION_ENEMIGO: String = "Posicion enemigo"
const DICTIONARY_KEY_PERSONAJE: String = "Personaje"
const DICTIONARY_KEY_VALOR_ACCION: String = "Valor accion"
const DICTIONARY_KEY_STAT: String = "Stat"
const DICTIONARY_KEY_VALOR: String = "Valor"
const DICTIONARY_KEY_DURACION: String = "Duracion"

const SENSIBILIDAD_CAMARA: float = 0.005
const DISTANCIA_MINIMA_CAMARA: float = 5.0
const DISTANCIA_MAXIMA_CAMARA: float = 25.0
const VELOCIDAD_ZOOM_CAMARA: float = 1.0
const ALTURA_MINIMA_CAMARA: float = 2.0
const ANGULO_VERTICAL_MINIMO_CAMARA: float = deg_to_rad(15.0)
const ANGULO_VERTICAL_MAXIMO_CAMARA: float = deg_to_rad(80.0)
const DISTANCIA_INICIAL_CAMARA: float = 12.0
