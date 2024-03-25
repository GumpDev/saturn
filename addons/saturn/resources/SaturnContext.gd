class_name SaturnContext extends Resource

var arguments = {}
var cooldowns: Array[SaturnStateCooldown] = []
var data_adapter: SaturnDataAdapter
var cooldown_state

func get_argument_value(argument_name: String):
	if argument_name in arguments:
		return arguments[argument_name]
	return null
