extends Node3D
## enums
## consts
const CAMERA_PAN_SPEED : float = 5;
const CAMERA_ROTATE_SPEED : float = PI / 2;
const CAMERA_ARC_RADIUS : float = 10;
const CAMERA_ZOOM_SPEED : float = PI;
const MIN_ANGLE : float = - PI / 3;
const MAX_ANGLE : float = - PI / 16;
const START_ANGLE : float = - PI / 6;
const HEIGHT_PER_RAD : float = 20;
const CAMERA_PAN_SPEED_HEIGHT_COEFF : float = 0.2;
## exports
## public vars
## private vars
var _movement_input : Vector2 = Vector2.ZERO;
var _rotation_input : float = 0;
var _zoom_input : int = 0;
## onready vars
@onready var camera : Camera3D = $Camera3D;
## built-in override functions

func _ready() -> void:
	camera.rotation.x = START_ANGLE;

func _process(delta: float) -> void:
	_movement_input = Input.get_vector("left", "right", "up", "down");
	_rotation_input = Input.get_axis("rotate ccw", "rotate cw");
	_zoom_input = int(Input.is_action_just_pressed("zoom out")) - int(Input.is_action_just_pressed("zoom in"));
	
	var yaw = _rotation_input * CAMERA_ROTATE_SPEED * delta;
	var pitch = -_zoom_input * CAMERA_ZOOM_SPEED * delta;
	
	rotate_y(yaw);
	camera.rotate_x(pitch);
	camera.rotation.x = clamp(camera.rotation.x, MIN_ANGLE, MAX_ANGLE);
	
	var height = abs(camera.rotation.x) * HEIGHT_PER_RAD;
	var orbit_vector = Vector3(CAMERA_ARC_RADIUS * sin(yaw), 0, CAMERA_ARC_RADIUS * (cos(yaw) - 1));
	var pan_vector = Vector3(_movement_input.x, 0, _movement_input.y) * CAMERA_PAN_SPEED * (0.5 + CAMERA_PAN_SPEED_HEIGHT_COEFF * pow(height, 1.2)) * delta;
	
	translate(orbit_vector + pan_vector);
	position.y = height;
