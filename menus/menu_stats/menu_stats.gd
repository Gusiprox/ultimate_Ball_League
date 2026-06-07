extends Panel

signal cerrarSolicitado

@onready var lblForce = $contStats/contStatsElem/contNumStats/lblPushStrengthStat
@onready var lblResistance = $contStats/contStatsElem/contNumStats/lblPushResistenceStat
@onready var lblSpeed = $contStats/contStatsElem/contNumStats/lblSpeedStat
@onready var lblSkill = $contStats/contStatsElem/contNumStats/lblSkillStat
@onready var lblTalent = $contStats/contStatsElem/contNumStats/lblTalentStat

@onready var charModel = $character

func _ready() -> void:
	pass 

func _on_btn_close_stats_pressed() -> void:
	cerrarSolicitado.emit()

func _setData(data: CharacterDataModel):
	lblForce.text = str(data.knokForce) 
	lblResistance.text = str(data.knokResistance)
	lblSpeed.text = str(data.speed)
	lblSkill.text = str(data.ability)
	lblTalent.text = str(data.talent)
	charModel._setData(ModelData.new(data))
