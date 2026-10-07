extends Node3D

@onready var camera : Camera3D = $Camera3D;

const CAMERA_PAN_SPEED : float = 5;
const CAMERA_ROTATE_SPEED : float = PI / 2;
const CAMERA_ARC_RADIUS : float = 10;
const CAMERA_ZOOM_SPEED : float = PI;

const MIN_ANGLE : float = - PI / 3;
const MAX_ANGLE : float = - PI / 16;
const HEIGHT_PER_RAD : float = 20;
const CAMERA_PAN_SPEED_HEIGHT_COEFF : float = 0.2;

var movement_input : Vector2 = Vector2.ZERO;
var rotation_input : float = 0;
var zoom_input : int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "up", "down");
	rotation_input = Input.get_axis("rotate ccw", "rotate cw");
	zoom_input = int(Input.is_action_just_pressed("zoom out")) - int(Input.is_action_just_pressed("zoom in"));
	
	var yaw = rotation_input * CAMERA_ROTATE_SPEED * delta;
	var pitch = -zoom_input * CAMERA_ZOOM_SPEED * delta;
	
	rotate_y(yaw);
	camera.rotate_x(pitch);
	camera.rotation.x = clamp(camera.rotation.x, MIN_ANGLE, MAX_ANGLE);
	
	var height = abs(camera.rotation.x) * HEIGHT_PER_RAD;
	var orbit_vector = Vector3(CAMERA_ARC_RADIUS * sin(yaw), 0, CAMERA_ARC_RADIUS * (cos(yaw) - 1));
	var pan_vector = Vector3(movement_input.x, 0, movement_input.y) * CAMERA_PAN_SPEED * (0.5 + CAMERA_PAN_SPEED_HEIGHT_COEFF * pow(height, 1.2)) * delta;
	
	translate(orbit_vector + pan_vector);
	position.y = height;
