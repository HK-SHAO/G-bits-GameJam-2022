extends Node2D

export(PackedScene) var game1: PackedScene



# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene_to(game1)
