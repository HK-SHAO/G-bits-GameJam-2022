extends RigidBody2D

onready var _sprite := $Sprite

onready var _animation_player := $AnimationPlayer as AnimationPlayer
onready var _particles := $Particles2D as Particles2D

func _ready() -> void:
	pass

func _on_Enemy_body_entered(body: Node) -> void:
	if "Player" in body.name:
		if body.has_method("food_entered"):
			body.food_entered()
		
func _process(delta: float) -> void:
	var alpha = (1 + cos(Util.time * 3)) / 2
	outline_alpha(alpha * 10)
	
func outline_alpha(value: float) -> void:
	if is_instance_valid(_sprite):
		_sprite.material.set_shader_param("line_thickness", value)

func _on_FoodArea2D_body_entered(body: Node) -> void:
	if "Virus" in body.name or "Enemy" in body.name:
		if body.has_method("dead"):
			body.dead()
			pass
