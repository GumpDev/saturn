@tool
extends Control

@export var tree: Tree
@export var add_window: Window
@export var not_loaded_label: Label
@onready var machine_player: SaturnStatePlayer

var context: SaturnContext
var state_machine: SaturnStateGroup

const SaturnListTreeUtils = preload("res://addons/saturn/utils/SaturnListTreeUtils.gd")
const SaturnStateNameUtils = preload("res://addons/saturn/utils/SaturnStateNameUtils.gd")
var list_tree_utils
var state_name_utils

func _enter_tree():
	tree.button_clicked.connect(_button_clicked)
	tree.item_edited.connect(_state_renamed)

func _exit_tree():
	tree.button_clicked.disconnect(_button_clicked)
	tree.item_edited.disconnect(_state_renamed)

func init(_machine_player: SaturnStatePlayer):
	if not _machine_player:
		tree.hide()
		not_loaded_label.show()
		return
	
	tree.show()
	not_loaded_label.hide()
	machine_player = _machine_player
	state_machine = machine_player.state_machine
	context = SaturnContext.new()
	context.data_adapter = machine_player.data_adapter
	
	list_tree_utils = SaturnListTreeUtils.new(state_machine)
	state_name_utils = SaturnStateNameUtils.new(context)
	
	load_tree()

func _state_renamed():
	var tree_item = tree.get_edited()
	var state = list_tree_utils.get_state(tree_item)
	state.custom_name = tree_item.get_text(0)
	if not tree_item.get_text(0):
		tree_item.set_text(0, state_name_utils.get_state_name(state))

func _button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int):
	if id == 1:
		add_window.position = get_viewport().get_mouse_position() + Vector2(-200, 0)
		add_window.show()

func load_tree():
	tree.clear()
	load_states(state_machine)

func load_states(state: SaturnState, parent: TreeItem = null, path: Array[int] = []):
	var tree_item: TreeItem = tree.create_item(parent)
	tree_item.set_metadata(0, path)
	
	if parent == null:
		tree_item.set_text(0, "State Machine")
	else:
		tree_item.set_text(0, state_name_utils.get_state_name(state))
		tree_item.set_editable(0, true)
	
	tree_item.set_icon(0, SaturnIconManager.get_icon_by_state(state))
	
	if state is SaturnStateGroup:
		tree_item.add_button(0, SaturnIconManager.get_icon("add"), 1)
	
	if parent:
		if state in [SaturnStateCondition, SaturnStateCooldown, SaturnStateValue]:
			tree_item.add_button(0, SaturnIconManager.get_icon("edit"), 2)
		tree_item.add_button(0, SaturnIconManager.get_icon("remove"), 3)

	if state is SaturnStateGroup:
		var i = 0;
		for child in state.children:
			var new_path = path.duplicate()
			new_path.append(i)
			load_states(child, tree_item, new_path)
			i += 1
	
