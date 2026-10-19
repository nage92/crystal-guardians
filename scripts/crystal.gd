extends Area2D

var was_collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if was_collected:
		return

<<<<<<< HEAD
	if body.is_in_group("player"):
		if QuestManager.collect_crystal():
			queue_free()
			was_collected = true
			collected.emit()
func _try_collect(body: Node2D) -> void:
	if was_collected or not body.is_in_group("player"):
		return
	if QuestManager.collect_crystal():  # false si la misión no está ACTIVE
=======
	if not body.is_in_group("player"):
		return
	if QuestManager.collect_crystal():
>>>>>>> upstream/main
		was_collected = true
		queue_free()
