extends Node

onready var playerPack := preload("res://src/objects/Player/Player.tscn")

var time := 0.0

func _ready() -> void:
	rand_seed(Time.get_unix_time_from_system())

func _process(delta: float) -> void:
	time += delta
