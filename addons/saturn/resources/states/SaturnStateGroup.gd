@icon("res://addons/saturn/icons/TreeGroup.svg")
class_name SaturnStateGroup extends SaturnState

@export var children: Array[SaturnState]

func get_state(context: SaturnContext):
	for child in children:
		var state = child.get_state(context)
		if state:
			return state
	return null
