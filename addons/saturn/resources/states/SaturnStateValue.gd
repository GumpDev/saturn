@icon("res://addons/saturn/icons/TreeValue.svg")
class_name SaturnStateValue extends SaturnState

@export var value: int

func get_state(_context: SaturnContext):
	return value

