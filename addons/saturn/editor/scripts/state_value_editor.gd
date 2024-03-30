@tool
extends ConfirmationDialog

@export var state_dropdown: OptionButton
@export var state_input: LineEdit
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
		title = "Edit State"
	else:
		title = "Add State"
		
	if tree_item:
		var value_state: SaturnStateValue = SaturnListTreeUtils.get_state(state_machine, tree_item)
		state_input.text = str(value_state.value)
		if data_adapter:
			state_dropdown.select(value_state.value)
	
func load_values():
	state_dropdown.clear()
	state_input.clear()
	if data_adapter:
		for item in data_adapter.get_data_list():
			var i = 0
			state_dropdown.add_item(item.capitalize(), i)
			i += 1
		state_dropdown.show()
		state_input.hide()
	else:
		state_dropdown.hide()
		state_input.show()

func create_item():
	if state_dropdown.selected == -1 and state_input.text.is_empty():
		if data_adapter:
			state_dropdown.grab_focus()
		else:
			state_input.grab_focus()
		error_label.show()
		return
	
	if not tree_item:
		if data_adapter:
			SaturnStateCreator.create_state_value(state_machine, parent, state_dropdown.selected)
		else:
			SaturnStateCreator.create_state_value(state_machine, parent, int(state_input.text))
	else:
		var actual_state: SaturnStateValue = SaturnListTreeUtils.get_state(state_machine, tree_item)
		actual_state.value = int(state_input.text) if not data_adapter else state_dropdown.selected
		
	state_updated.emit()
	queue_free()
