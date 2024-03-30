@tool
extends Tree

var state_machine: SaturnStateGroup

signal state_machine_updated()

const SaturnListTreeUtils = preload("res://addons/saturn/utils/SaturnListTreeUtils.gd")

func _can_drop_data(at_position, data):
	var drop_section = get_drop_section_at_position(at_position)
	var tree_item = get_item_at_position(at_position)
	if not tree_item:
		return false
	
	if drop_section == 0:
		var state = SaturnListTreeUtils.get_state(state_machine, tree_item)
		if not state is SaturnStateGroup:
			set_drop_mode_flags(DROP_MODE_INBETWEEN)
		else:
			set_drop_mode_flags(DROP_MODE_INBETWEEN + DROP_MODE_ON_ITEM)
		return state is SaturnStateGroup and tree_item != data
	return tree_item != data

func _drop_data(at_position, tree_item_dropped):
	set_drop_mode_flags(DROP_MODE_DISABLED)
	
	var drop_section = get_drop_section_at_position(at_position)
	var tree_item = get_item_at_position(at_position)
	var state_below = SaturnListTreeUtils.get_state(state_machine, tree_item)
	var state_dropped = SaturnListTreeUtils.get_state(state_machine, tree_item_dropped)
	
	if tree_item_dropped == tree_item: return
	
	if drop_section == 0:
		if not state_below is SaturnStateGroup: return
		if state_dropped is SaturnStateGroup:
			if state_below in get_flat_children(state_dropped):
				return
		SaturnListTreeUtils.get_parent(state_machine, tree_item_dropped).children.remove_at(SaturnListTreeUtils.get_parent_index(state_machine, tree_item_dropped))
		state_below.children.insert(0, state_dropped)
	else:
		var state_below_parent = SaturnListTreeUtils.get_parent(state_machine, tree_item)
		var state_below_index = SaturnListTreeUtils.get_parent_index(state_machine, tree_item)
		var state_index = state_below_index
		SaturnListTreeUtils.get_parent(state_machine, tree_item_dropped).children.remove_at(SaturnListTreeUtils.get_parent_index(state_machine, tree_item_dropped))
		state_below_parent.children.insert(state_index, state_dropped)
	
	state_machine_updated.emit()

func _get_drag_data(at_position):
	var tree_item = get_item_at_position(at_position)
	set_drop_mode_flags(DROP_MODE_INBETWEEN + DROP_MODE_ON_ITEM)
	return tree_item

func get_flat_children(state_group: SaturnStateGroup):
	var states = []
	for state in state_group.children:
		if state is SaturnStateGroup:
			states.append_array(get_flat_children(state))
		states.append(state)
	return states
