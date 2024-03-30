@tool
extends Object

const SaturnListTreeUtils = preload("res://addons/saturn/utils/SaturnListTreeUtils.gd")

static func create_state_group(state_machine: SaturnStateGroup, tree_item: TreeItem):
	var item_state: SaturnStateGroup = SaturnListTreeUtils.get_state(state_machine, tree_item)
	var group_state = SaturnStateGroup.new()
	item_state.children.append(group_state)
	
static func create_state_value(state_machine: SaturnStateGroup, tree_item: TreeItem, value: int):
	var item_state: SaturnStateGroup = SaturnListTreeUtils.get_state(state_machine, tree_item)
	var value_state = SaturnStateValue.new()
	value_state.value = value
	item_state.children.append(value_state)
	
static func create_state_value_lock(state_machine: SaturnStateGroup, tree_item: TreeItem, value: int, time: float):
	var item_state: SaturnStateGroup = SaturnListTreeUtils.get_state(state_machine, tree_item)
	var value_state_lock = SaturnStateValueLock.new()
	value_state_lock.value = value
	value_state_lock.time = time
	item_state.children.append(value_state_lock)
	
static func create_state_cooldown(state_machine: SaturnStateGroup, tree_item: TreeItem, time: float):
	var item_state: SaturnStateGroup = SaturnListTreeUtils.get_state(state_machine, tree_item)
	var cooldown_state = SaturnStateCooldown.new()
	cooldown_state.time = time
	item_state.children.append(cooldown_state)

static func create_state_condition(state_machine: SaturnStateGroup, tree_item: TreeItem, argument_name: String, operator: SaturnStateCondition.Operators, value: String):
	var item_state: SaturnStateGroup = SaturnListTreeUtils.get_state(state_machine, tree_item)
	var condition_state = SaturnStateCondition.new()
	condition_state.argument_name = argument_name
	condition_state.operator = operator
	condition_state.value = value
	item_state.children.append(condition_state)

static func remove_state(state_machine: SaturnStateGroup, tree_item: TreeItem, callback: Callable):
	var state_children: SaturnStateGroup = SaturnListTreeUtils.get_parent(state_machine, tree_item)
	var state_index = SaturnListTreeUtils.get_parent_index(state_machine, tree_item)
	var confimationDialog = ConfirmationDialog.new()
	confimationDialog.dialog_text = "Do you really want to delete it? (this action is irreversible)"
	confimationDialog.confirmed.connect(func ():
		state_children.children.remove_at(state_index)
		callback.call()
	)
	EditorInterface.get_base_control().add_child(confimationDialog)
	confimationDialog.popup_centered()
