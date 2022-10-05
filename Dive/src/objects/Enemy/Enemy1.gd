class_name MyEnemy

extends RigidBody2D

func _on_Enemy_body_entered(body: Node) -> void:
	if "Player" in body.name:
		if body.has_method("enemy_entered"):
			body.enemy_entered(self)
		
func generate_new():

	var new = duplicate()
	new.global_position = global_position  + Vector2(0, -1)
	z_index = new.z_index + 1
	get_parent().add_child(new)
