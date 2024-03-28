@tool
extends ConfirmationDialog

@export var operator_dropdown: OptionButton
@export var argument_input: LineEdit
@export var value_input: LineEdit
@export var error_label: Label

var context: SaturnContext
var state_machine: SaturnStateGroup
var parent: TreeItem
var tree_item: TreeItem
var data_adapter: SaturnDataAdapter = null

signal state_updated()

const SaturnStateCreator = preload("res://addons/saturn/utils/SaturnStateCreator.gd")
const SaturnListTreeUtils = preload("res://addons/saturn/utils/SaturnListTreeUtils.gd")

func _ready():
	error_label.hide()
	confirmed.connect(create_item)

func show_popup(_state_machine: SaturnStateGroup, _context: SaturnContext, _parent: TreeItem, _tree_item: TreeItem = null):
	state_machine = _state_machine
	context = _context
	parent = _parent
	tree_item = _tree_item
	
	if context.data_adapter:
		data_adapter = context.data_adapter.get_script().new()
	
	load_values()
	
	if tree_item:
		title = "Edit Condition"
	else:
		title = "Add Condition"
		
	if tree_item:
		var condition_state: SaturnStateCondition = SaturnListTreeUtils.get_state(state_machine, tree_item)
		argument_input.text = condition_state.argument_name
		operator_dropdown.select(condition_state.operator)
		value_input.text = condition_state.value
	
func load_values():
	operator_dropdown.clear()
	var i = 0
	for item in SaturnStateCondition.Operators.keys():
		operator_dropdown.add_item(item.capitalize(), i)
		i += 1

func create_item():
	if argument_input.text.is_empty():
		argument_input.grab_focus()
		error_label.show()
		return
	if value_input.text.is_empty():
		value_input.grab_focus()
		error_label.show()
		return
	if operator_dropdown.selected == 0:
		operator_dropdown.grab_focus()
		error_label.show()
		return
	
	if not tree_item:
		SaturnStateCreator.create_state_condition(state_machine, parent, argument_input.text, operator_dropdown.selected, value_input.text)
	else:
		var actual_state: SaturnStateCondition = SaturnListTreeUtils.get_state(state_machine, tree_item)
		actual_state.argument_name = argument_input.text
		actual_state.operator = operator_dropdown.selected
		actual_state.value = value_input.text
		
	state_updated.emit()
	queue_free()
