class_name TestDataAdapter extends SaturnDataAdapter

enum State{
	IDLE,
	JUMPING,
	CROUCHING
}

func get_data(state):
	if not state:
		return State.IDLE
	return int(state)

func get_data_name(state):
	if not state:
		return State.keys()[0]
	return State.keys()[int(state)]

func to_data(state):
	return State.keys().find(state)

func get_data_list():
	return State.keys()
