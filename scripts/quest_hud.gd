extends CanvasLayer

@onready var quest_label: Label = $QuestLabel


func _ready() -> void:
	QuestManager.quest_updated.connect(update_quest_text)
	update_quest_text()


func update_quest_text() -> void:
	match QuestManager.quest_state:

		QuestManager.QuestState.NOT_STARTED:
			quest_label.text = "Quest: Talk with the professor"

		QuestManager.QuestState.ACTIVE:
			quest_label.text = "Crystals: %d/%d" % [
				QuestManager.collected_crystals,
				QuestManager.required_crystals
			]

		QuestManager.QuestState.READY_TO_DELIVER:
			quest_label.text = "Get back with the professor"

		QuestManager.QuestState.COMPLETED:
			quest_label.text = "Completed quest"
