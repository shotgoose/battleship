extends Node3D

const CAMERA_PAN_SPEED : float = 5;
const CAMERA_ROTATE_SPEED : float = PI / 4;
const CAMERA_ARC_RADIUS : float = 10;

var movement_input : Vector2 = Vector2.ZERO;
var rotation_input : float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "up", "down");
	rotation_input = Input.get_axis("rotate ccw", "rotate cw");
	
	var angle = rotation_input * CAMERA_ROTATE_SPEED * delta;
	var orbit_vector = Vector3(CAMERA_ARC_RADIUS * sin(angle), 0, CAMERA_ARC_RADIUS * (cos(angle) - 1));
	var pan_vector = Vector3(movement_input.x, 0, movement_input.y) * CAMERA_PAN_SPEED * delta;
	
	rotate_y(angle);
	translate(orbit_vector + pan_vector);
