extends Node

# Señales para avisar a la interfaz cuando cambie el dinero
signal gold_changed(new_amount: int)
signal gacha_tokens_changed(new_amount: int)
signal charactersSeted
signal initDataSetted


const DIC_CODE_USERNAME: String = "DisplayName"
const DIC_CODE_GOLD: String = "OR"
const DIC_CODE_GACHATOKEN: String = "GP"

# Las variables donde guardamos los datos en RAM
var playfab_id: String = ""
var username: String = ""

var equipo: Array[CharacterBody3D] = []
var shopItems: Array[ItemData] = []
var characters: Array[CharacterDataModel] = []

var gold: int = 0:
	set(value):
		gold = value
		gold_changed.emit(gold) # Emite automáticamente al cambiar

var gacha_tokens: int = 0:
	set(value):
		gacha_tokens = value
		gacha_tokens_changed.emit(gacha_tokens)

func _ready() -> void:
	EventBus.reloadData.connect(_setInitData)
	EventBus.saveTeam.connect(_setTeamImp)

func _setData(data: LoginResult):
	var usernameDic: Dictionary = data.InfoResultPayload.PlayerProfile
	var currencyDic: Dictionary = data.InfoResultPayload.UserVirtualCurrency
	await _setInitData()
	
	username = usernameDic.get(DIC_CODE_USERNAME)
	gold = currencyDic.get(DIC_CODE_GOLD)
	gacha_tokens = currencyDic.get(DIC_CODE_GACHATOKEN)
	
func _delData():
	pass

func _setTeamImp(teamArray: Array[int]):
	if teamArray == null or teamArray.is_empty():
		return
	
	equipo.clear()
	var charactersData: Array[CharacterDataModel]
	
	for characterId in teamArray:
		charactersData.push_front(characters.get(characterId))
	equipo = ParserUtil._charactersDataToCharactersBody(charactersData)
	
func _setCharactersImp(a):
	characters.clear()
	var charactersDict: Dictionary = a.data.FunctionResult.characters.personajes
	
	for character in charactersDict:
		var characterData = CharacterDataModel.new(charactersDict.get(character))
		characterData.id = character
		
		characters.push_front(characterData)

func _setShopImp(a):
	shopItems.clear()
	for itemShop in a.data.FunctionResult.catalog.catalogo:
		shopItems.push_front(ItemData.new(itemShop))

func _setInitData():
	var dict = {
		"FunctionName": "getInitData",
		"keys": [
			"BarKey"
		]
	}
	PlayFabManager.client.post_dict_auth(
		dict, 
		"/Client/ExecuteCloudScript", 
		PlayFab.AUTH_TYPE.SESSION_TICKET, 
		_setInitDataImp
	)
	await initDataSetted

func _setInitDataImp(data):
	await _setCharactersImp(data)
	await  _setShopImp(data)
	await  _setTeamImp([])
	await _setShopImp(data)
	
	initDataSetted.emit()


func stringToInt(value: String) -> int:
	var texto_limpio = value.strip_edges()
	
	if texto_limpio.is_valid_int():
		return texto_limpio.to_int()
	return 0
