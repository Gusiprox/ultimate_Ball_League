# Ultimate Ball League

## Integrantes del proyecto

- Sara Pérez
- Aitor Rebato
- Erik de la Cruz

## Índice

- [Ultimate Ball League](#ultimate-ball-league)
  - [Integrantes del proyecto](#integrantes-del-proyecto)
  - [Índice](#índice)
  - [Conceptualización](#conceptualización)
	- [Historia **No sé que poner**](#historia-no-sé-que-poner)
	- [Juego](#juego)
	  - [Interfaz](#interfaz)
	  - [Obtención de personajes **Esto es la última entrega, cambiadlo como veais conveniente**](#obtención-de-personajes-esto-es-la-última-entrega-cambiadlo-como-veais-conveniente)
	  - [Partidas](#partidas)
	  - [Estadísticas de personajes](#estadísticas-de-personajes)
	  - [Mecánica principal](#mecánica-principal)
	  - [Controles](#controles)
  - [Arte](#arte)
  - [Programación](#programación)
	- [Menús](#menús)
	- [Creación de escenarios](#creación-de-escenarios)
	- [Personajes **Tenemos que mirar como hacer esto y si eso hablar de las habilidades y pasivas aquí**](#personajes-tenemos-que-mirar-como-hacer-esto-y-si-eso-hablar-de-las-habilidades-y-pasivas-aquí)
	- [Partida](#partida)
	- [Inteligencia artificial](#inteligencia-artificial)
  - [Elementos destacables](#elementos-destacables)
	- [Sistema de turnos](#sistema-de-turnos)
  - [Bibliografía](#bibliografía)

## Conceptualización

### Historia **No sé que poner**

### Juego

#### Interfaz

Al abrir el juego el usuario se encuentra con un menú inicial en el que el usuario puede ver el nombre del juego y la imágen de inicio. Para entrar al juego primero hay que hacer clic en el botón empezar, que abrirá el menú de inicio de sesión. En caso de que el usuario no tenga una cuenta, tendrá que abrir otro menú para crearla y después iniciar sesión.

Una vez se haya iniciado sesión, se accede al juego. En la parte superior de la pantalla hay una barra de menús, de izquierda a derecha: Menú principal (donde está el botón para empezar a jugar), editor de personaje, editor de equipo, gacha, tienda e inventario para que el usuario pueda ver todos los personajes y gorros que tiene.

En la misma barra, a la derecha, se muestran las tiradas que tenga el usuario, el dinero y el nombre de la cuenta que haya iniciado sesión.

Al hacer clic en el icono del usuario (o con el esc) se despliega un menú lateral con varias opciones que permiten al usuario ver:

- Opciones.
  - Modificar el sonido del juego.
  - Ver los controles del juego. 
  - Cambiar el idioma.
- Cerrar sesión. 
- Salir del juego.

#### Obtención de personajes **Esto es la última entrega, cambiadlo como veais conveniente**

Para conseguir personajes habrá un menú en el que de manera aleatoria te genera un personaje con estadísticas aleatorias a cambio de una moneda dentro del juego.

Esta parte la maneja el servidor para evitar la generación de personajes con métodos ilícitos, y así generar personajes garantizando que sean raros y valiosos.

Ejemplo explicativo:  
Gastas X monedas y te dan a un jugador con:
- Fuerza de empuje: 10.
- Resistencia de empuje: 5.
- Velocidad: 11.
- Habilidad: “Aumento de resistencia de empuje +2”.
- Talento:  “Aumenta la fuerza de empuje si tiene un compañero al lado”.

Y así tendrías tu nuevo personaje listo para usar.

#### Partidas 

Una partida cuenta con 2 jugadores (O un jugador y una IA), cada uno con un equipo de 5 personajes. Gana aquel jugador que tenga más puntos al acabar la partida. Si los jugadores empatan se continuará jugando hasta que uno de los jugadores desempate y si este periodo se alarga demasiado se terminará en empate.

Se obtienen puntos al hacer que tus personajes, que serán pelotas con brazos y piernas, lleguen al final del campo enemigo que sería donde se encuentra su portería, al llegar a la portería el personaje volverá al inicio de su campo y el jugador obtendrá un punto.

Se va a utilizar un sistema de turnos en el que, mediante la estadística de velocidad de los jugadores, se decidirá a quién le ha llegado el turno para poder actuar y el final del partido.

El escenario del juego es un campo de fútbol con 14 casillas de alto y 7 de ancho, con dos porterías, una a cada extremo del campo.

#### Estadísticas de personajes 
  
Cada personaje contará con las siguientes estadísticas, que influirán en su utilización en el juego:

- Fuerza de empuje: Indica las casillas que se puede mover cada personaje en su turno.

- Resistencia de empuje: Para evitar el avance de los atacantes.

- Velocidad: Decide cuándo obtiene el turno un personaje, a mayor velocidad antes podrá volver a actuar ese personaje.

- Habilidad: Se activará en el turno del personaje pulsando la tecla **E** y tras usarla se terminará el turno del personaje y se deberá esperar una cantidad establecida de turnos para volver a utilizarla, algunos personajes pueden no llevar habilidad.

- Talento: Se activará automáticamente o al cumplir una condición, algunos personajes pueden no llevar talento.

#### Mecánica principal 

La mecánica principal del juego está basada en empujes.

- Los jugadores se moverán usando su fuerza de empuje (Si un jugador tiene 3 de fuerza de empuje, este se podrá mover hasta 3 casillas). 

- Si un jugador colisiona con un personaje del equipo opuesto se empezará un duelo para decidir si este podrá seguir avanzando, solo se puede realizar un duelo por turno. 

- Si el atacante gana el duelo podrá seguir avanzando y empujará al defensor al lado o detrás de él. 

- Si el defensor gana el atacante no podrá avanzar. 

- Para calcular quién gana el duelo se calculará cual es mayor entre la resistencia de empuje del defensor y la fuerza de empuje del atacante menos las casillas que se tiene que mover para alcanzar al defensor, para que el atacante gane su valor tiene que ser estrictamente mayor.

*Ejemplo explicativo*: Se tiene un jugador atacante con 6 puntos en fuerza de empuje y otro en el equipo contrario con 4 de resistencia de empuje. El atacante tras moverse 2 casillas, colisiona con el defensor e iniciarán un duelo en el que el defensor ganaría debido a que su resistencia de empuje (4) es mayor o igual a la fuerza de empuje restante del atacante (6 - 2 = 4).

#### Controles en partida

- Cuando sea el turno de un personaje las casillas que se encuentren en su fuerza de empuje resaltarán de color amarillo y para moverse a esa casilla solo se necesita pasar el cursor del ratón y hacer click izquierdo, al ganar un duelo se resaltarán las casillas a las que puedes empujar al adversario.

- Para mover la cámara se tiene que mantener click izquierdo y mover el ratón y con la rueda del ratón se puede hacer zoom.

- Para activar una habilidad se tiene que pulsar la tecla **E** para que te muestre el rango de tus habilidades y luego seleccionar al objetivo de tu habilidad con el click izquierdo, en caso de no querer usar habilidad se puede volver a pulsar la **E** para moverse.

## Arte

A continuación se proporciona información sobre dónde se han obtenido los elementos artísticos utilizados en el juego:

- **Personajes:** los modelos de los personajes y sus animaciones han sido creados por nosotros utilizando Blender.
- **Sombreros:** los modelos de los sombreros han sido creados por nosotros utilizando Blender.
- **Campo:** el campo en sí ha sido realizado por nosotros utilizando Blender, pero las porterías se han obtenido de esta [página](https://www.turbosquid.com/FullPreview/1840894).
- Fondos:
  - **Fondo del menú de inicio:** se ha generado con IA (Gemini).
  - **Fondo de MenuAll:** el color verde ha sido proporcionado por la IA pero el diseño ha sido creado por nosotros utilizando iconos obtenidos de ésta [página](https://fontawesome.com/search?f=classic&s=solid).
- **Iconos:**
  - **Ojo y exclamación de MenuStart:** se han obtenido de ésta [página](https://fontawesome.com/search?f=classic&s=solid).
  - **Tirada:** la hemos diseñado nosotros. Los iconos utilizados se han obtenido de ésta [página](https://fontawesome.com/search?f=classic&s=solid).
  - **Moneda:** la hemos diseñado nosotros. Los iconos utilizados se han obtenido de ésta [página](https://fontawesome.com/search?f=classic&s=solid).
  - **Botón MenuUser:** se ha generado con IA (Gemini).
  - **Montón de monedas y carro de la compra:** se han obtenido de ésta [página](https://fontawesome.com/search?f=classic&s=solid).
  - **Botón salir del menú de inicio:** se ha obtenido de ésta [página](https://fontawesome.com/search?f=classic&s=solid).
- **Banner de gacha:** se ha generado con IA (Gemini).
- **Marcos de menús:** todos los marcos se ha generado con IA (Gemini).
- **Fuente:** la fuente de la letra utilizada en nuestro juego es [Texturina](https://bestfreefonts.com/texturina).
- **Música:**
  - [Música del menú de inicio.](https://pixabay.com/music/upbeat-fun-game-427132/)
  - [Música de MenuAll.](https://pixabay.com/music/video-games-game-176807/)

## Programación

El videojuego ha sido hecho con el sistema de escenas y nodos de Godot con código escrito en GDScript, el servidor usado es Playfab y los modelos 3D han sido creados con Blender.

### Menús

Los menús que tiene nuestro juego al momento de ejecutarlo son los siguientes:

- **Menú de inicio**, que tiene los siguientes elementos:
  - **Menú de inicio de sesión:** permite al usuario iniciar sesión con su cuenta y entrar al juego.
  - **Menú de creación de cuenta:** en caso de no tener cuenta el usuario debe crearla en éste menú y luego iniciar sesión con ella.
  - **Botón** para cerrar el juego.

Una vez el usuario ha iniciado sesión, éste accede a los menús de gestión del juego:

- **MenuAll**, que contiene los siguientes elementos:
  - **NavBar:** barra de menús que permite navegar entre los distintos menús del juego. También sirve para que el usuario pueda ver las tiradas y monedas que tiene y para abrir un submenú donde el usuario podrá acceder a las opciones del juego, cerrar sesión o cerrar el juego.
  - **Menú jugar:** permite al usuario acceder a partidas al presionar el botón "jugar".
  - **Menú editar personaje:** permite al usuario editar el sombrero que tiene equipado cada personaje que posea.
  - **Menú editar equipo:** permite al usuario seleccionar los personajes que van a conformar el equipo que va a usar en las partidas.
  - **Menú gacha:** permite al usuario obtener personajes gastando sus tiradas.
  - **Menú tienda:** permite al usuario comprar sombreros que proporcionan mejoras a sus personajes, gastando monedas.
  - **Menú inventario:** permite al usuario ver la lista de personajes y sombreros que tiene, pudiendo también comprobar sus estadísticas.

Al iniciar una partida, el usuario tiene acceso a los siguientes menús:

- **Menú InGame:** al presionar la tecla esc, el usuario abre un menú en el que puede acceder a las opciones del juego, salir de la partida y volver a los menús de gestión del juego o cerrar el menú para seguir jugando.
- **Menú de victoria:** en caso de que el usuario gane la partida le aparecerá un menú de victoria en el que podrá observar las tiradas y monedas que ha ganado. También podrá elegir si volver a los menús o buscar una partida nueva (NO IMPLEMENTADO).
- **Menú de derrota:** en caso de que el usuario pierda la partida, le aparecerá un menú de derrota en el que podrá observar las monedas que ha obtenido. También podrá elegir si volver a los menús o buscar una partida nueva (NO IMPLEMENTADO).

### Creación de escenarios

Se cuenta con una escena que consta de la creación de una casilla y luego con otra escena que será el terreno de fútbol, donde se jugarán las partidas de fútbol, que contendrá la cantidad de casillas que nosotros indiquemos (En este caso sería un estadio de 14x7 casillas) el motivo de crear los escenarios de esta forma es para cuando, en un futuro, se quiera crear un escenario de otro deporte se pueda reutilizar la escena de la casilla y solamente se tenga que crear el escenario del nuevo deporte con las dimensiones que se necesite. 

### Personajes **Tenemos que mirar como hacer esto y si eso hablar de las habilidades y pasivas aquí**

Tendremos un código base que será el que tenga la lógica de todos los personajes (Moverse, asignarse equipos, etc) para evitar duplicar código, luego el resto de personajes extenderán de ese código base y tendrán sus propias estadísticas que serán asignadas dependiendo de sus caracteristicas.

### Partida

Una vez se ha elegido qué personajes se usarán antes de empezar el partido, este empezará en una escena que contendrá la escena del terreno y se colocarán a los personajes en unas posiciones fijas al inicio de la partida, para saber quien actúa se usará un sistema por turnos y para decidir quien obtendrá su turno se usará la estadística de velocidad de los personajes, haciendo que los personajes más rápidos actúen más frecuentemente. 

### Inteligencia artificial

Si se decide jugar una partida con una IA como oponente este realizará movimientos para marcar gol y también será capaz de realizar duelos y seguir las reglas del sistema de empujes.

## Elementos destacables

### Sistema de turnos

Para determinar el orden de los turnos se usa un sistema dinámico. A partir de la velocidad de cada personaje y de un valor universal, se calcula un parámetro denominado **valor de acción**.

Con este valor, los personajes se introducen en una cola, cuanto menor sea el valor de acción de un personaje, antes llegará su turno de actuar.

Este sistema permite situaciones en las que personajes con una velocidad muy alta pueden actuar antes de que lo haga un personaje extremadamente lento, haciendo que la velocidad juegue un papel importante en las decisiones del partido.


## Bibliografía

- [Godot Docs](https://docs.godotengine.org/en/stable/index.html)
- [Godot Tactical RPG](https://github.com/ramaureirac/godot-tactical-rpg)
