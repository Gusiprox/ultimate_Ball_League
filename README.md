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
  - [Arte](#arte)
  - [Programación](#programación)
    - [Menús](#menús)
  - [Elementos destacables](#elementos-destacables)

## Conceptualización

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

## Elementos destacables
