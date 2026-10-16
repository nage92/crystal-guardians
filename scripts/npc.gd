extends Node2D

@onready var interactive_area: Area2D = $InteractiveArea
var player_nearby: bool = false

func _ready() -> void:
	interactive_area.body_entered.connect(
		_on_interactive_area_body_entered
	)
	interactive_area.body_exited.connect(
		_on_interactive_area_body_exited
	)

func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact() # llamamos a la función

func interact() -> void: # ejecuta los mensajes de diálogo e inicia la misión
	var dialogue_ui = get_tree().current_scene.get_node("DialogueUI")

	if dialogue_ui.is_open:
		return
	
	match QuestManager.quest_state:
		QuestManager.QuestState.NOT_STARTED:
			dialogue_ui.show_dialogue(
				"Only Han",
				[
					"Guard, I need your help",
					"The enemies had dispersed the magic crystals around the city",
					"You have to get them back quickly before they get lost"
				]
			)
			QuestManager.start_quest()

		QuestManager.QuestState.ACTIVE:
			dialogue_ui.show_dialogue(
				"Only Han",
				[
					"Keep looking for the crystals!",
					"You only found %d of %d" % [
						QuestManager.collected_crystals,
						QuestManager.required_crystals
					]
				]
			)

		QuestManager.QuestState.READY_TO_DELIVER:
			dialogue_ui.show_dialogue(
				"Only Han",
				[
					"Perfect, thank you for helping me",
					"You recovered all the crystals in time",
					"Now we can activate the portal"
				]
			)
			QuestManager.complete_quest()

		QuestManager.QuestState.COMPLETED:
			dialogue_ui.show_dialogue(
				"Only Han",
				["Thank you again, guard. The city is safe."]
			)

func _on_interactive_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_interactive_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		# jugador se aleja se oculta el diálogo
		var dialogue_ui = get_tree().current_scene.get_node("DialogueUI")
		if dialogue_ui.is_open:
			dialogue_ui.close_dialogue()
		
