extends Node

enum Phase {
	PLANNING,
	EXECUTING,
}

var turn := 0
var phase := Phase.PLANNING

var _ready_state: Dictionary = {}
var _pending_units := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
