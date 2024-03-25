class_name SaturnStateValue extends SaturnState

@export var value: String

func get_state(_context: SaturnContext):
	return value

func get_state_name(context: SaturnContext):
	var value_name = value
	if context.data_adapter:
		value_name = context.data_adapter.get_data_name(value)
	return "State -> %s" % [value_name]
