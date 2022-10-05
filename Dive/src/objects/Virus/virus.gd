class_name MyVirus

extends RigidBody2D
		
func generate_new():
	var new = duplicate()
	new.global_position = global_position  + Vector2(0, -1)
	z_index = new.z_index + 1
	get_parent().add_child(new)


func _on_Virus_body_entered(body: Node) -> void:
	if "Player" in body.name:
		if body.has_method("virus_entered"):
			body.virus_entered(self)
