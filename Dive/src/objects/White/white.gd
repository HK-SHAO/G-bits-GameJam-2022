extends RigidBody2D

func _on_White_body_entered(body: Node) -> void:
	if "Enemy" in body.name or "Virus" in body.name:
		if body.has_method("white_entered"):
			body.white_entered(self)
