extends Object

var state_machine: SaturnStateGroup

func _init(_state_machine: SaturnStateGroup):
	state_machine = _state_machine

func get_parent(tree_item: TreeItem):
	var path = tree_item.get_metadata(0).duplicate()
	path.pop_back()
	var state: SaturnState = state_machine
	for i in path:
		state = state.children[i]
	return state

func get_state(tree_item: TreeItem):
	var path = tree_item.get_metadata(0)
	var state: SaturnState = state_machine
	for i in path:
		state = state.children[i]
	return state

func get_parent_index(tree_item: TreeItem):
	var path = tree_item.get_metadata(0)
	return path.back()
