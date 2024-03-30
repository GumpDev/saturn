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
			var state_condition_editor = StateConditionEditor.instantiate()
			instantiate_menu(state_condition_editor)
		1:
			var state_cooldown_editor = StateCooldownEditor.instantiate()
			instantiate_menu(state_cooldown_editor)
		2:
			SaturnStateCreator.create_state_group(state_machine, tree_item)
			state_machine_updated.emit()
		3:
			var state_value_editor = StateValueEditor.instantiate()
			instantiate_menu(state_value_editor)
		4:
			var state_value_editor = StateValueLockEditor.instantiate()
			instantiate_menu(state_value_editor)
	hide()

func instantiate_menu(menu: Node):
	var selected_state = SaturnListTreeUtils.get_state(state_machine, tree_item)
	menu.state_updated.connect(func (): state_machine_updated.emit())
	EditorInterface.get_base_control().add_child(menu)
	menu.show_popup(state_machine, context, tree_item)

func _on_close_requested():
	hide()
