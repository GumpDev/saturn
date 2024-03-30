class_name SaturnContext extends Resource

var arguments = {}
var cooldowns: Array[SaturnStateCooldown] = []
var data_adapter: SaturnDataAdapter

var tree: SceneTree
var _cooldown_state: int
var _locked_state: int = -1
var _locked_state_time: int

func get_argument_value(argument_name: String):
	if argument_name in arguments:
		return arguments[argument_name]
	return null

func run_cooldowns(actual_state: int):
	if actual_state == _cooldown_state: return
	for cooldown in cooldowns:
		cooldown.is_on_cooldown = true
		tree.create_timer(cooldown.time).timeout.connect(func (): cooldown.is_on_cooldown = false)
	cooldowns.clear()
	_cooldown_state = -1

func lock_state(_state: Variant, _time: float):
	var msec = Time.get_ticks_msec()
	_locked_state = data_adapter.from_data(_state)
	_locked_state_time = msec
	await tree.create_timer(_time).timeout
	if _locked_state_time != msec: return
	if _locked_state != _state: return
	_locked_state = -1
