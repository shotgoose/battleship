class_name TravelRange
extends RefCounted

var min_value: float
var max_value: float

func _init(low: float, high: float):
	if low >= high:
		return
	min_value = low
	max_value = high

func contains(num: float) -> bool:
	return num >= min_value and num <= max_value
	
func within_range(num: float) -> bool:
	return num <= max_value
	
func clamp_value(num: float) -> float:
	return clamp(num, min_value, max_value)
