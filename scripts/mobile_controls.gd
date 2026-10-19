extends CanvasLayer

@onready var joystick_base: Control = $Controls/JoystickBase
@onready var joystick_knob: Control = $Controls/JoystickBase/JoystickKnob

@export var joystick_radius: float = 65.0
@export var deadzone: float = 0.15

var joystick_direction: Vector2 = Vector2.ZERO
var active_touch_index: int = -1

func _ready() -> void:
	joystick_knob.position = (
		joystick_base.size - joystick_knob.size
	) / 2.0
	
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if active_touch_index == -1:
				if is_inside_joystick(event.position):
					active_touch_index = event.index
					update_joystick(event.position)
		elif event.index == active_touch_index:
			active_touch_index = -1
			reset_joystick()
	elif event is InputEventScreenDrag:
		if event.index == active_touch_index:
			update_joystick(event.position)

func is_inside_joystick(screen_position: Vector2) -> bool:
	# Un poco más grande que la base para que sea fácil de tocar
	var area := joystick_base.get_global_rect().grow(20.0)
	return area.has_point(screen_position)

func update_joystick(screen_position: Vector2) -> void:
	var center := joystick_base.get_global_rect().get_center()
	var offset := (screen_position - center).limit_length(joystick_radius)

	# Mueve el knob sin salirse del radio
	joystick_knob.global_position = center + offset - joystick_knob.size / 2.0

	# Dirección con zona muerta
	var strength := offset.length() / joystick_radius
	if strength < deadzone:
		joystick_direction = Vector2.ZERO
	else:
		joystick_direction = offset / joystick_radius

	apply_movement()

func reset_joystick() -> void:
	joystick_direction = Vector2.ZERO
	joystick_knob.position = (joystick_base.size - joystick_knob.size) / 2.0
	apply_movement()
	
func apply_movement() -> void:
	set_axis("move_left", "move_right", joystick_direction.x)
	set_axis("move_up", "move_down", joystick_direction.y)

func set_axis(negative: String, positive: String, value: float) -> void:
	if value < 0.0:
		Input.action_press(negative, -value)
		Input.action_release(positive)
	elif value > 0.0:
		Input.action_press(positive, value)
		Input.action_release(negative)
	else:
		Input.action_release(negative)
		Input.action_release(positive)
		
func _on_attack_button_down() -> void:
	Input.action_press("attack")

func _on_attack_button_up() -> void:
	Input.action_release("attack")

func _on_interact_button_down() -> void:
	Input.action_press("interact")

func _on_interact_button_up() -> void:
	Input.action_release("interact")
