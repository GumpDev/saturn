@tool
extends Control

@export var tree: Tree
@export var add_window: Window
@export var not_loaded_label: Label
@onready var machine_player: SaturnStatePlayer

var context: SaturnContext
var state_machine: SaturnStateGroup

const SaturnListTreeUtils = preload("res://addons/saturn/utils/SaturnListTreeUtils.gd")
const SaturnStateCreator = preload("res://addons/saturn/utils/SaturnStateCreator.gd")
const SaturnStateNameUtils = preload("res://addons/saturn/utils/SaturnStateNameUtils.gd")

const StateValueEditor = preload("res://addons/saturn/editor/scenes/state_value_editor.tscn")
const StateCooldownEditor = preload("res://addons/saturn/editor/scenes/state_cooldown_editor.tscn")
const StateConditionEditor = preload("res://addons/saturn/editor/scenes/state_condition_editor.tscn")

var state_name_utils

func _enter_tree():
	tree.button_clicked.connect(_button_clicked)
	tree.item_edited.connect(_state_renamed)
	tree.state_machine_updated.connect(load_tree)
	add_window.state_machine_updated.connect(load_tree)

func _exit_tree():
	tree.button_clicked.disconnect(_button_clicked)
	tree.item_edited.disconnect(_state_renamed)
	tree.state_machine_updated.disconnect(load_tree)

func init(_machine_player: SaturnStatePlayer):
	if not _machine_player:
		tree.hide()
		not_loaded_label.show()
		return
	
	tree.show()
	not_loaded_label.hide()
	machine_player = _machine_player
	state_machine = machine_player.state_machine
	tree.state_machine = state_machine
	context = SaturnContext.new()
	context.data_adapter = machine_player.data_adapter
	
	add_window.state_machine = state_machine
	add_window.context = context
	
	state_name_utils = SaturnStateNameUtils.new(context)
	load_tree()

func _state_renamed():
	var tree_item = tree.get_edited()
	var state = SaturnListTreeUtils.get_state(state_machine, tree_item)
	if state_name_utils.get_state_name(state) == tree_item.get_text(0):
		state.custom_name = ""
	else:
		state.custom_name = tree_item.get_text(0)
	if not tree_item.get_text(0):
		tree_item.set_text(0, state_name_utils.get_state_name(state))

func _button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int):
	match id:
		1: 
			add_window.position = get_viewport().get_mouse_position() + Vector2(-200, 0)
			add_window.tree_item = item
			add_window.show()
		2:
			var actual_state = SaturnListTreeUtils.get_state(state_machine, item)
			if actual_state is SaturnStateValue:
				var state_value_editor = StateValueEditor.instantiate()
				state_value_editor.state_updated.connect(func (): load_tree())
				EditorInterface.get_base_control().add_child(state_value_editor)
				state_value_editor.show_popup(state_machine, context, null, item)
			elif actual_state is SaturnStateCooldown:
				var state_cooldown_editor = StateCooldownEditor.instantiate()
				state_cooldown_editor.state_updated.connect(func (): load_tree())
				EditorInterface.get_base_control().add_child(state_cooldown_editor)
				state_cooldown_editor.show_popup(state_machine, context, null, item)
			elif actual_state is SaturnStateCondition:
				var state_condition_editor = StateConditionEditor.instantiate()
				state_condition_editor.state_updated.connect(func (): load_tree())
				EditorInterface.get_base_control().add_child(state_condition_editor)
				state_condition_editor.show_popup(state_machine, context, null, item)
		3:
			SaturnStateCreator.remove_state(state_machine, item, func (): load_tree())
	 

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
		if state is SaturnStateCondition or SaturnStateCooldown or SaturnStateValue:
			tree_item.add_button(0, SaturnIconManager.get_icon("edit"), 2)
		tree_item.add_button(0, SaturnIconManager.get_icon("remove"), 3)

	if state is SaturnStateGroup:
		var i = 0;
		for child in state.children:
			var new_path = path.duplicate()
			new_path.append(i)
			load_states(child, tree_item, new_path)
			i += 1
	
