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

const COLOR_HOVER: Color = Color(0, 1, 0)
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
