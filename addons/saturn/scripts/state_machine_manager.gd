@tool
extends Control

@onready var tree = $Tree
@onready var add_window = $AddWindow
@onready var edit_window = $StateMachineEditValues
@onready var test_player = $SaturnStatePlayerTest

var context: SaturnContext
var state_machine: SaturnStateGroup

const SaturnListTreeUtils = preload("res://addons/saturn/utils/SaturnListTreeUtils.gd")
var list_tree_utils

func _ready():
	state_machine = test_player.state_machine
	list_tree_utils = SaturnListTreeUtils.new(state_machine)
	context = test_player.context
	tree.button_clicked.connect(_button_clicked)
	edit_window.on_edited.connect(load_tree)
	load_tree()

func _button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int):
	if id == 1:
		add_window.show_window(get_viewport().get_mouse_position() + Vector2(-200, 0))
		var index = await add_window.button_clicked
		match index:
			0:
				edit_window.show_popup(2, context, list_tree_utils.get_state(item))
			1:
				edit_window.show_popup(1, context, list_tree_utils.get_state(item))
			2:
				# apenas adicionar
				pass
			3:
				edit_window.show_popup(0, context, list_tree_utils.get_state(item))
		add_window.hide()

func load_tree():
	tree.clear()
	load_states(state_machine)

func load_states(state: SaturnState, parent: TreeItem = null, path: Array[int] = []):
	var tree_item: TreeItem = tree.create_item(parent)
	tree_item.set_metadata(0, path)
	
	if parent == null:
		tree_item.set_text(0, "State Machine")
	else:
		tree_item.set_text(0, state.get_state_name(context))
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
	
