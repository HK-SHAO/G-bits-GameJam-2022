extends Node2D

export(PackedScene) var map: PackedScene

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func _process(delta: float) -> void:
	if $Sprites/Enemys.get_child_count() + $Sprites/Virus.get_child_count() == 0:
		get_tree().change_scene_to(map)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
