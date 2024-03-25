@tool
extends Control

@onready var tree = $Tree
@onready var add_window = $AddWindow
@onready var test_player = $SaturnStatePlayerTest

var context: SaturnContext
var state_machine: SaturnStateGroup

func _ready():
	state_machine = test_player.state_machine
	context = test_player.context
	tree.button_clicked.connect(_button_clicked)
	add_window.focus_exited.connect(func (): add_window.hide())
	add_window.hide()
	load_tree()

func _button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int):
	if id == 1:
		add_window.position = get_viewport().get_mouse_position() + Vector2(-200, 0)
		add_window.show()
		

func load_tree():
	tree.clear()
	tree.add_theme_constant_override("icon_max_width", 24)
	load_states(state_machine)

func load_states(state: SaturnState, parent: TreeItem = null):
	var tree_item: TreeItem = tree.create_item(parent)
	
	if parent == null:
		tree_item.set_text(0, "State Machine")
	else:
		tree_item.set_text(0, state.get_state_name(context))
	tree_item.set_icon(0, SaturnIconManager.get_icon_by_state(state))
	
	if state is SaturnStateGroup:
		tree_item.add_button(0, SaturnIconManager.get_icon("add"), 1)
	
	if parent:
		tree_item.add_button(0, SaturnIconManager.get_icon("edit"), 2)
		tree_item.add_button(0, SaturnIconManager.get_icon("remove"), 3)

	if state is SaturnStateGroup:
		for child in state.children:
			load_states(child, tree_item)
	
