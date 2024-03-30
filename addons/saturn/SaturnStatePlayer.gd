@icon("res://addons/saturn/icons/SaturnPlayer.svg")
class_name SaturnStatePlayer extends Node

@export var state_machine: SaturnStateGroup = SaturnStateGroup.new()
@export var initial_arguments: Dictionary = {}
@export var data_adapter: SaturnDataAdapter

var context: SaturnContext = SaturnContext.new()
var _old_state: int = 0
var _actual_state: int = 0

signal state_changed()

func _ready():
	if not data_adapter:
		data_adapter = SaturnDataAdapter.new()
	context.tree = get_tree()
	context.data_adapter = data_adapter
	context.arguments = initial_arguments

func set_argument(name: String, value):
	context.arguments[name] = value

func lock_state(_state: Variant, _time: float):
	context.lock_state(_state, _time)

func get_state():
	if data_adapter:
		return data_adapter.to_data(_actual_state)
	return _actual_state

func update_state(state):
	_actual_state = state
	state_changed.emit()
	_old_state = state
	context.run_cooldowns(_actual_state)

func _process(_delta):
	if context._locked_state != -1:
		if context._locked_state != _old_state:
			update_state(context._locked_state)
	else:
		var state = state_machine.get_state(context)
		if not state: state = 0
		if state != _old_state:
			update_state(state)
