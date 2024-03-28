class_name SaturnContext extends Resource

var arguments = {}
var cooldowns: Array[SaturnStateCooldown] = []
var data_adapter: SaturnDataAdapter
var cooldown_state

func get_argument_value(argument_name: String):
	if argument_name in arguments:
		return arguments[argument_name]
	return null

func run_cooldowns(tree: SceneTree, actual_state: String):
	if actual_state == cooldown_state: return
	for cooldown in cooldowns:
		cooldown.is_on_cooldown = true
		tree.create_timer(cooldown.time).timeout.connect(func (): cooldown.is_on_cooldown = false)
	cooldowns.clear()
	cooldown_state = null
