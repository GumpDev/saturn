class_name TestDataAdapter extends SaturnDataAdapter

enum State{
	IDLE,
	JUMPING,
	CROUCHING
}

func from_data(state: Variant) -> int:
	return state

func to_data(state: int) -> State:
	return State.get(State.keys()[state])

func get_data_list() -> Array:
	return State.keys()
