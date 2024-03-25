class_name SaturnStatePlayer extends Node

@export var state_machine: SaturnStateGroup
@export var data_adapter: SaturnDataAdapter

var context: SaturnContext = SaturnContext.new()
var _old_state: String = ""
var _actual_state

signal state_changed()

func _ready():
	context.data_adapter = data_adapter
	if data_adapter:
		_actual_state = data_adapter.get_data(null)

func run_cooldowns():
	if _actual_state == context.cooldown_state: return
	for cooldown in context.cooldowns:
		cooldown.is_on_cooldown = true
		get_tree().create_timer(cooldown.time).timeout.connect(func (): cooldown.is_on_cooldown = false)
	context.cooldowns.clear()
	context.cooldown_state = null

func set_argument(name: String, value):
	context.arguments[name] = value

func get_state():
	if data_adapter:
		return data_adapter.get_data(_actual_state)
	return _actual_state

func update_state(state):
	_actual_state = state
	state_changed.emit()
	_old_state = state

func _process(_delta):
	var state = state_machine.get_state(context)
	if state != _old_state:
		update_state(state)
		run_cooldowns()
