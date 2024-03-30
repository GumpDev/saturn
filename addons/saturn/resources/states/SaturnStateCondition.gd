@icon("res://addons/saturn/icons/TreeCondition.svg")
class_name SaturnStateCondition extends SaturnStateGroup

@export var argument_name: String
@export var operator: Operators
@export var value: String

enum Operators{
	NONE,
	EQUALS,
	NOT_EQUALS,
	GREATER_THAN,
	GREATER_THAN_OR_EQUALS,
	LESS_THAN,
	LESS_THAN_OR_EQUALS
}

var operators_funcs = {
	Operators.NONE: func (_argument_value): return true,
	Operators.EQUALS: func (argument_value): return str(argument_value) == str(value),
	Operators.NOT_EQUALS: func (argument_value): return str(argument_value) != str(value),
	Operators.GREATER_THAN: func (argument_value): return float(argument_value) > float(value),
	Operators.GREATER_THAN_OR_EQUALS: func (argument_value): return float(argument_value) >= float(value),
	Operators.LESS_THAN: func (argument_value): return float(argument_value) < float(value),
	Operators.LESS_THAN_OR_EQUALS: func (argument_value): return float(argument_value) <= float(value),
}

func get_result(argument_value):
	return operators_funcs[operator].call(argument_value)

func get_state(context: SaturnContext):
	if get_result(context.get_argument_value(argument_name)):
		return super(context)
	return null
