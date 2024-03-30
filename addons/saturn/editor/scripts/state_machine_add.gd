@tool
extends Window

@export var item_list: ItemList
var state_machine: SaturnStateGroup
var context: SaturnContext
var tree_item: TreeItem

signal state_machine_updated()

const SaturnStateCreator = preload("res://addons/saturn/utils/SaturnStateCreator.gd")
const SaturnListTreeUtils = preload("res://addons/saturn/utils/SaturnListTreeUtils.gd")

const StateValueEditor = preload("res://addons/saturn/editor/scenes/state_value_editor.tscn")
const StateValueLockEditor = preload("res://addons/saturn/editor/scenes/state_value_lock_editor.tscn")
const StateConditionEditor = preload("res://addons/saturn/editor/scenes/state_condition_editor.tscn")
const StateCooldownEditor = preload("res://addons/saturn/editor/scenes/state_cooldown_editor.tscn")

func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	match index:
		0:
			var selected_state = SaturnListTreeUtils.get_state(state_machine, tree_item)
			var state_condition_editor = StateConditionEditor.instantiate()
			state_condition_editor.state_updated.connect(func (): state_machine_updated.emit())
			EditorInterface.get_base_control().add_child(state_condition_editor)
			state_condition_editor.show_popup(state_machine, context, tree_item)
		1:
			var selected_state = SaturnListTreeUtils.get_state(state_machine, tree_item)
			var state_cooldown_editor = StateCooldownEditor.instantiate()
			state_cooldown_editor.state_updated.connect(func (): state_machine_updated.emit())
			EditorInterface.get_base_control().add_child(state_cooldown_editor)
			state_cooldown_editor.show_popup(state_machine, context, tree_item)
		2:
			SaturnStateCreator.create_state_group(state_machine, tree_item)
			state_machine_updated.emit()
		3:
			var selected_state = SaturnListTreeUtils.get_state(state_machine, tree_item)
			var state_value_editor = StateValueEditor.instantiate()
			state_value_editor.state_updated.connect(func (): state_machine_updated.emit())
			EditorInterface.get_base_control().add_child(state_value_editor)
			state_value_editor.show_popup(state_machine, context, tree_item)
		4:
			var selected_state = SaturnListTreeUtils.get_state(state_machine, tree_item)
			var state_value_editor = StateValueLockEditor.instantiate()
			state_value_editor.state_updated.connect(func (): state_machine_updated.emit())
			EditorInterface.get_base_control().add_child(state_value_editor)
			state_value_editor.show_popup(state_machine, context, tree_item)
	hide()

func _on_close_requested():
	hide()
