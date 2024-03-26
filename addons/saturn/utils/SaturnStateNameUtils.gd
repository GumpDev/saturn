extends Object

var context: SaturnContext

func _init(_context: SaturnContext):
	context = _context

func get_state_name(state: SaturnState):
	if state.custom_name:
		return state.custom_name
	
	if state is SaturnStateCooldown:
		var state_cooldown: SaturnStateCooldown = state
		return "Cooldown -> %2.fs" % state_cooldown.time
	if state is SaturnStateCondition:
		var state_condition: SaturnStateCondition = state
		return "Condition -> %s %s %s" % [state_condition.argument_name, SaturnStateCondition.Operators.keys()[state_condition.operator].to_lower(), state_condition.value]
	if state is SaturnStateGroup:
		var state_group: SaturnStateGroup = state
		return "Group -> %s items" % len(state_group.children)
	if state is SaturnStateValue:
		var state_value: SaturnStateValue = state
		var value_name = state_value.value
		if context.data_adapter:
			var data_adapter = context.data_adapter.get_script().new()
			value_name = data_adapter.get_data_name(state_value.value)
		return "State -> %s" % value_name
	return ""
