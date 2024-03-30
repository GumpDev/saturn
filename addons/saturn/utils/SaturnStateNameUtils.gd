extends Object

var context: SaturnContext

const operator_name = {
	SaturnStateCondition.Operators.NONE: "",
	SaturnStateCondition.Operators.EQUALS: "=",
	SaturnStateCondition.Operators.NOT_EQUALS: "!=",
	SaturnStateCondition.Operators.GREATER_THAN: ">",
	SaturnStateCondition.Operators.GREATER_THAN_OR_EQUALS: ">=",
	SaturnStateCondition.Operators.LESS_THAN: "<",
	SaturnStateCondition.Operators.LESS_THAN_OR_EQUALS: "<="
}

func _init(_context: SaturnContext):
	context = _context

func get_state_name(state: SaturnState):
	if state.custom_name:
		return state.custom_name
	
	if state is SaturnStateCooldown:
		var state_cooldown: SaturnStateCooldown = state
		return "Cooldown -> %2.2f s" % state_cooldown.time
	if state is SaturnStateCondition:
		var state_condition: SaturnStateCondition = state
		return "Condition -> %s %s %s" % [state_condition.argument_name, operator_name[state_condition.operator], state_condition.value]
	if state is SaturnStateGroup:
		var state_group: SaturnStateGroup = state
		return "Group -> %s items" % len(state_group.children)
	if state is SaturnStateValueLock:
		var state_value_lock: SaturnStateValueLock = state
		var value_name = state_value_lock.value
		if context.data_adapter:
			var data_adapter = context.data_adapter.get_script().new()
			value_name = data_adapter.get_data_list()[state_value_lock.value]
		return "State Lock -> %s for %2.2f s" % [value_name, state_value_lock.time]
	if state is SaturnStateValue:
		var state_value: SaturnStateValue = state
		var value_name = state_value.value
		if context.data_adapter:
			var data_adapter = context.data_adapter.get_script().new()
			value_name = data_adapter.get_data_list()[state_value.value]
		return "State -> %s" % value_name
	return ""
