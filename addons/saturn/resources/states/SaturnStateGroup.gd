class_name SaturnStateGroup extends SaturnState

@export var children: Array[SaturnState]

func get_state(context: SaturnContext):
	for child in children:
		var state = child.get_state(context)
		if state:
			return state
	return null

func get_state_name(_context: SaturnContext):
	return "Group -> %s items" % [len(children)]
