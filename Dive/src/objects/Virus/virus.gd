class_name MyVirus

extends RigidBody2D

var is_dead := false

# func _physics_process(delta: float) -> void:
# 	apply_central_impulse(Vector2(randf(), randf()) * delta * 10)
		
func generate_new():
	var new = duplicate()
	new.global_position = global_position\
	  + Vector2(1 if randf() < 0.5 else -1, 1 if randf() < 0.5 else -1)
	z_index = new.z_index + 1
	get_parent().add_child(new)


func _on_Virus_body_entered(body: Node) -> void:
	if is_dead:
		return
	if "Player" in body.name:
		if body.has_method("virus_entered"):
			body.virus_entered(self)

func dead():
	is_dead = true
	$AnimationPlayer.play("dead")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
