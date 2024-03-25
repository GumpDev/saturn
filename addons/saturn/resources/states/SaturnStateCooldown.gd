class_name SaturnStateCooldown extends SaturnStateGroup

@export var time: float

var is_on_cooldown = false

func get_state(context: SaturnContext):
	if not is_on_cooldown:
		var state = super(context)
		if state:
			context.cooldown_state = state
			context.cooldowns.append(self)
		return state
	return null

func get_state_name(_context: SaturnContext):
	return "Cooldown -> %2.fs" % [time]
