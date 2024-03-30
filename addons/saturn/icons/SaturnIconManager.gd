class_name SaturnIconManager extends Object

const condition_icon = preload("res://addons/saturn/icons/TreeCondition.svg")
const group_icon = preload("res://addons/saturn/icons/TreeGroup.svg")
const cooldown_icon = preload("res://addons/saturn/icons/TreeCooldown.svg")
const value_icon = preload("res://addons/saturn/icons/TreeValue.svg")
const value_lock_icon = preload("res://addons/saturn/icons/TreeLockState.svg")
const add_icon = preload("res://addons/saturn/icons/Add.svg")
const edit_icon = preload("res://addons/saturn/icons/Edit.svg")
const remove_icon = preload("res://addons/saturn/icons/Remove.svg")

const icons = {
	"add": add_icon,
	"edit": edit_icon,
	"remove": remove_icon
}

static func get_icon(name: String):
	return icons[name]

static func get_icon_by_state(state: SaturnState):
	if state is SaturnStateCondition:
		return condition_icon
	if state is SaturnStateCooldown:
		return cooldown_icon
	if state is SaturnStateGroup:
		return group_icon
	if state is SaturnStateValueLock:
		return value_lock_icon
	if state is SaturnStateValue:
		return value_icon

