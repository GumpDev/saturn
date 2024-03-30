@icon("res://addons/saturn/icons/TreeCooldown.svg")
class_name SaturnStateCooldown extends SaturnStateGroup

@export var time: float

var is_on_cooldown = false

func get_state(context: SaturnContext):
	if not is_on_cooldown:
		var state = super(context)
		if state:
			context._cooldown_state = state
			context.cooldowns.append(self)
		return state
	return null
