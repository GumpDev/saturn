extends Object

static func get_parent(state_machine: SaturnStateGroup, tree_item: TreeItem):
	var path = tree_item.get_metadata(0).duplicate()
	path.pop_back()
	var state: SaturnState = state_machine
	for i in path:
		state = state.children[i]
	return state

static func get_state(state_machine: SaturnStateGroup, tree_item: TreeItem):
	var path = tree_item.get_metadata(0)
	var state: SaturnState = state_machine
	for i in path:
		state = state.children[i]
	return state

static func get_parent_index(state_machine: SaturnStateGroup, tree_item: TreeItem):
	var path = tree_item.get_metadata(0)
	return path.back()
