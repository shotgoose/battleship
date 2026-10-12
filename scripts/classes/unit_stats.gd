class_name UnitStats
extends Resource

@export var display_name: String = "Unit"
@export var max_health: float = 180.0
@export var top_speed: float = 150.0 #units/turn
@export var max_acceleration: float = 15.0 #units/turn^2
@export var max_deceleration: float = 30.0 #units/turn^2
@export var base_turn_radius: float = 3.0 #units
@export var turn_radius_speed_coeff: float = 0.1 #units / units/turn
@export var icon: Texture2D
