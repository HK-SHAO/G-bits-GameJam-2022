extends RigidBody2D

onready var _sprite := $Sprite

func _on_Enemy_body_entered(body: Node) -> void:
	if "Player" in body.name:
		if body.has_method("food_entered"):
			body.food_entered()
		
func _process(delta: float) -> void:
	var alpha = (1 + cos(Util.time * 3)) / 2
	outline_alpha(alpha)
	
func outline_alpha(value: float) -> void:
	if is_instance_valid(_sprite):
		var line_color = _sprite.material.get_shader_param("line_color")
		line_color.a = value
		_sprite.material.set_shader_param("line_color", line_color)
