@icon("res://addons/saturn/icons/TreeLockState.svg")
class_name SaturnStateValueLock extends SaturnStateValue

@export var time: float

func get_state(_context: SaturnContext):
	_context.lock_state(_context.data_adapter.to_data(value), time)
	return value
