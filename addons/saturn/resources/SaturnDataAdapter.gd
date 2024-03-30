class_name SaturnDataAdapter extends Resource

func from_data(state: Variant) -> int:
	return int(state)

func to_data(state: int) -> Variant:
	return str(state)

func get_data_list() -> Array:
	return []
