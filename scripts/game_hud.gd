extends CanvasLayer

@onready var health_label: Label = $HUDContainer/HealthPanel/VBoxContainer/HealthLabel
@onready var health_bar: TextureProgressBar = $HUDContainer/HealthPanel/VBoxContainer/HealthBar
@onready var crystal_label: Label = $HUDContainer/CrystalsPanel/CrystalLabel
@onready var quest_label: Label = $HUDContainer/QuestPanel/QuestLabel



func _ready() -> void:
	QuestManager.quest_updated.connect(update_quest_info)
	update_quest_info()
	# Diferido: espera a que el jugador exista en la escena
	_connect_player.call_deferred()
func _connect_player() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_warning("GameHUD: no se encontró al jugador (grupo 'player')")
		return
	player.health_changed.connect(update_health)
	update_health(player.health, player.max_health) # estado inicial
	
func update_health(current: int, max: int) -> void:
	health_bar.max_value = max
	health_bar.value = current
	health_label.text = "LIFE: %d/%d" % [current, max]

func update_quest_info() -> void:
	crystal_label.text = "CRYSTALS: %d/%d" % [
		QuestManager.collected_crystals,
		QuestManager.required_crystals
	]
	match QuestManager.quest_state:
		QuestManager.QuestState.NOT_STARTED:
			quest_label.text = "Quest: Talk with Han Solo"
		QuestManager.QuestState.ACTIVE:
			quest_label.text = "Quest: Get the crystals"
		QuestManager.QuestState.READY_TO_DELIVER:
			quest_label.text = "Quest: Deliver the crystals to Only Han"
		QuestManager.QuestState.COMPLETED:
			quest_label.text = "QUEST COMPLETED"
