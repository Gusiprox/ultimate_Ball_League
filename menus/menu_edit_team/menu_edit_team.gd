extends Control

@onready var card1 = $contMenuField/MenuField/HBoxContainer/CharacterCard
@onready var card2 = $contMenuField/MenuField/HBoxContainer/CharacterCard2
@onready var card3 = $contMenuField/MenuField/HBoxContainer/CharacterCard3

var teamIds: Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setCardsInvisible()	
	EventBus.equipCard.connect(_equipACard)

func _on_btn_save_team_button_down() -> void:
	EventBus.saveTeam.emit(teamIds)

func _equipACard(id: int):
	if teamIds.has(id):
		return
	else: 
		teamIds.push_front(id)
	if teamIds.size() > 3:
		teamIds.resize(3)
	_loadCards()
	
func _loadCards():
	_setCardsInvisible()
	
	var cards = [
		card1,
		card2,
		card3
	]
	var i = 0
	for id in teamIds:
		var cartaActual = cards.get(i)
		cartaActual._setData(PlayerData.characters.get(id))
		cartaActual.visible = true
		i = i+1

func _setCardsInvisible():
	card1.visible = false
	card2.visible = false
	card3.visible = false
