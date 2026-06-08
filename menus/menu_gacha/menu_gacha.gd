extends Control

@onready var gachaLayer = $CanvasLayer
@onready var animationPlayer = $CanvasLayer/AnimationPlayer
@onready var modelCharacter = $CanvasLayer/SubViewportContainer/SubViewport/CharacterPlaceholder2
@onready var hboxCharactersCards = $CanvasLayer/HBoxCharacters

@onready var lblForce = $CanvasLayer/HBoxFuerza/txtContent
@onready var lblResistance = $CanvasLayer/HBoxResistencia/txtContent
@onready var lblVelocity = $CanvasLayer/HBoxVelocidad/txtContent

@export var nodesCards: Array[Panel]

signal  endAnimation

var animacionEnCurso: bool = false

func _ready() -> void:
	gachaLayer.visible = false
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if animacionEnCurso:
			endAnimation.emit()

func _on_btn_one_pull_button_down() -> void:
	
	if PlayerData.gacha_tokens < 5:
		return
	
	var dict = {
		"FunctionName": "pullGacha",
		"keys": [
			"BarKey"
		]
	}
	PlayFabManager.client.post_dict_auth(
		dict, 
		"/Client/ExecuteCloudScript", 
		PlayFab.AUTH_TYPE.SESSION_TICKET, 
		_correct
	)

func _on_btn_ten_pulls_button_down() -> void:
	if PlayerData.gacha_tokens < 20:
		return
	var dict = {
		"FunctionName": "pullGachaTen",
		"keys": [
			"BarKey"
		]
	}
	PlayFabManager.client.post_dict_auth(
		dict, 
		"/Client/ExecuteCloudScript", 
		PlayFab.AUTH_TYPE.SESSION_TICKET, 
		_correct
	)


func _on_out_gacha_button_button_down() -> void:
	gachaLayer.visible = false

func _correct(a) -> void:
	gachaLayer.visible = true
	var characters: Array[CharacterDataModel]
	var dataDictionary: Dictionary = a.data.FunctionResult

	for characterDict in dataDictionary:
		var character = CharacterDataModel.new(dataDictionary.get(characterDict))
		characters.append(character)
		_setStatsData(character)
		await runAnimation(character)
	
	setCardsData(characters)
	animationPlayer.play("final")
	EventBus.reloadData.emit()
	await endAnimation
	gachaLayer.visible = false

func runAnimation(characterData: CharacterDataModel):
	
	modelCharacter._setData(ModelData.new(characterData))
	
	animationPlayer.play("mostrarFuerza")
	await  endAnimation
	animationPlayer.play("mostrarResistencia")
	await  endAnimation
	animationPlayer.play("mostrarVelocidad")
	await  endAnimation

func setCardsData(charDatas: Array[CharacterDataModel]):
	_ocultarCartas()
	var cardDatas = hboxCharactersCards.get_children()
	var i = 0
	for characterData in charDatas:
		cardDatas.get(i).visible = true
		cardDatas.get(i)._setData(characterData)
		i = i+1
	
@warning_ignore("unused_parameter")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	endAnimation.emit()

func _on_btn_next_button_down() -> void:
	endAnimation.emit()
	
func _setStatsData(data: CharacterDataModel):
	
	lblForce.text = str(data.knokForce)
	lblResistance.text = str(data.knokResistance)
	lblVelocity.text = str(data.speed)
	
	
func _ocultarCartas():
	for oneCard in nodesCards:
		oneCard.visible = false
	
	
	
	
	
