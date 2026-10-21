extends Area2D
@export var crystal_id: String = ""
var was_collected: bool = false

func _ready() -> void:
	if crystal_id in QuestManager.collected_crystal_ids:
		queue_free()
		return
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if was_collected:
		return

	if body.is_in_group("player"):
		if QuestManager.collect_crystal():
			queue_free()
			was_collected = true
func _try_collect(body: Node2D) -> void:
	if was_collected or not body.is_in_group("player"):
		return
	if not body.is_in_group("player"):
		return
<<<<<<< HEAD
	if QuestManager.collect_crystal(): # false si la misión no está ACTIVE
=======
	if QuestManager.collect_crystal(crystal_id):
>>>>>>> upstream/main
		was_collected = true
		queue_free()
