extends Sprite

export(PackedScene) var map: PackedScene

onready var _area := $Area2D

var mouse_entered = false

var line_alpha = 0


func _process(delta: float) -> void:

	if mouse_entered:
		line_alpha += (1 - line_alpha) * delta * 10
	else:
		line_alpha += (0 - line_alpha) * delta * 10
		
	outline_alpha(line_alpha)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 复制一份新的 material
	var shader_material: ShaderMaterial = material.duplicate()
	material = shader_material
	
	_area.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	_area.connect("mouse_exited", self, "_on_Area2D_mouse_exited")

func _on_Area2D_mouse_entered() -> void:
	mouse_entered = true


func _on_Area2D_mouse_exited() -> void:
	mouse_entered = false


func outline_alpha(value: float) -> void:
		material.set_shader_param("line_thickness", 50 + value * 100)


func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed():
			Global.audio_click()
			get_tree().change_scene_to(map)
