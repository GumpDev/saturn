extends ConfirmationDialog

@onready var value_state_container = $ValueState
@onready var cooldown_state_container = $CooldownState
@onready var condition_state_container = $ConditionState

@onready var state_dropdown = $ValueState/StateDropdown
@onready var state_input = $ValueState/State
@onready var time_input = $CooldownState/Time
@onready var argument_input = $ConditionState/Argument
@onready var operation_dropdown = $ConditionState/OperatorDropdown
@onready var value_input = $ConditionState/Value

const type_name = [
	"State",
	"Cooldown",
	"Condition"
]

var type = -1
var context: SaturnContext
var parent: SaturnState
var state: SaturnState

signal on_edited()

func _ready():
	hide()
	load_operation()
	confirmed.connect(create_item)

func show_popup(_type: int, _context: SaturnContext, _parent: SaturnState, _state: SaturnState = null):
	type = _type
	context = _context
	parent = _parent
	state = _state
	
	load_values()
	
	if state:
		title = "Edit %s" % type_name[type]
	else:
		title = "Add %s" % type_name[type]
		
	show()
	match type:
		0:
			state_input.clear()
			state_dropdown.select(0)
			value_state_container.show()
			if state:
				var value_state: SaturnStateValue = state
				state_input.text = value_state.value
				if context.data_adapter:
					var value_state_id = context.data_adapter.get_data_list().find(value_state.value)
					state_dropdown.select(value_state_id)
					state_input.hide()
					state_dropdown.show()
				else:
					state_input.show()
					state_dropdown.hide()
		1:
			time_input.value = time_input.min_value
			cooldown_state_container.show()
		2:
			argument_input.clear()
			operation_dropdown.select(0)
			value_input.clear()
			condition_state_container.show()
	
func load_values():
	value_state_container.hide()
	cooldown_state_container.hide()
	condition_state_container.hide()
	
	if context.data_adapter:
		state_dropdown.clear()
		for item in context.data_adapter.get_data_list():
			var i = 0
			state_dropdown.add_item(item.capitalize(), i)
			i += 1
		state_dropdown.show()
	else:
		state_dropdown.hide()

func load_operation():
	var i = 0
	for operation in SaturnStateCondition.Operators.keys():
		operation_dropdown.add_item(operation.capitalize(), i)
		i += 1

func create_item():
	match type:
		0:
			var state_value = SaturnStateValue.new()
			state_value.value = context.data_adapter.get_data_list()[state_dropdown.selected] if context.data_adapter else state_input.value
			parent.children.append(state_value)
