@tool
extends ConfirmationDialog

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
	
	if tree_item:
		title = "Edit Cooldown"
	else:
		title = "Add Cooldown"
		
	if tree_item:
		var cooldown_state: SaturnStateCooldown = SaturnListTreeUtils.get_state(state_machine, tree_item)
		time_input.value = cooldown_state.time

func create_item():
	if not tree_item:
		SaturnStateCreator.create_state_cooldown(state_machine, parent, time_input.value)
	else:
		var actual_state: SaturnStateCooldown = SaturnListTreeUtils.get_state(state_machine, tree_item)
		actual_state.time = time_input.value
		
	state_updated.emit()
	queue_free()
