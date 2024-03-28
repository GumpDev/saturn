class_name SaturnStatePlayer extends Node

@export var state_machine: SaturnStateGroup
@export var initial_arguments: Dictionary
@export var data_adapter: SaturnDataAdapter

var context: SaturnContext = SaturnContext.new()
var _old_state: String = ""
var _actual_state
var _locked_state: String = ""
var _locked_state_time: int

signal state_changed()

func _ready():
	context.data_adapter = data_adapter
	context.arguments = initial_arguments
	if data_adapter:
		_actual_state = data_adapter.get_data(null)

func set_argument(name: String, value):
	context.arguments[name] = value

func lock_state(_state: String, _time: float):
	var msec = Time.get_ticks_msec()
	_locked_state = _state
	_locked_state_time = msec
	await get_tree().create_timer(_time).timeout
	if _locked_state_time != msec: return
	if _locked_state != _state: return
	_locked_state = ""

func get_state():
	if data_adapter:
		return data_adapter.get_data(_actual_state)
	return _actual_state

func update_state(state):
	_actual_state = state
	state_changed.emit()
	_old_state = state

func _process(_delta):
	if _locked_state:
		if _locked_state != _old_state:
			update_state(_locked_state)
			context.run_cooldowns(get_tree(), _actual_state)
	else:
		var state = state_machine.get_state(context)
		if state != _old_state:
			update_state(state)
			context.run_cooldowns(get_tree(), _actual_state)
