@tool
extends ConfirmationDialog

@export var state_dropdown: OptionButton
@export var state_input: SpinBox
@export var time_input: SpinBox

var context: SaturnContext
var state_machine: SaturnStateGroup
var parent: TreeItem
var tree_item: TreeItem
var data_adapter: SaturnDataAdapter = null

signal state_updated()

const SaturnStateCreator = preload("res://addons/saturn/utils/SaturnStateCreator.gd")
const SaturnListTreeUtils = preload("res://addons/saturn/utils/SaturnListTreeUtils.gd")

func _ready():
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
		title = "Edit State Lock"
	else:
		title = "Add State Lock"
		
	if tree_item:
		var value_state: SaturnStateValue = SaturnListTreeUtils.get_state(state_machine, tree_item)
		state_input.value = value_state.value
		if data_adapter:
			state_dropdown.select(value_state.value)
	
func load_values():
	state_dropdown.clear()
	state_input.value = 0
	time_input.value = 0.1
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
	if not tree_item:
		if data_adapter:
			SaturnStateCreator.create_state_value_lock(state_machine, parent, state_dropdown.selected, time_input.value)
		else:
			SaturnStateCreator.create_state_value_lock(state_machine, parent, state_input.value, time_input.value)
	else:
		var actual_state: SaturnStateValueLock = SaturnListTreeUtils.get_state(state_machine, tree_item)
		actual_state.value = state_input.value if not data_adapter else state_dropdown.selected
		actual_state.time = time_input.value
		
	state_updated.emit()
	queue_free()
