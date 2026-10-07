extends RigidBody3D

@export var outline_material : ShaderMaterial;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("selectable");

func set_selected(selected: bool) -> void:
	for child in find_children("*", "MeshInstance3D"):
		child.material_overlay = outline_material if selected else null;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
