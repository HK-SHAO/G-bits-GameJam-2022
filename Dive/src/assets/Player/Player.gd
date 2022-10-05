class_name MyPlayer

extends RigidBody2D

export(StreamTexture) var texture1
export(StreamTexture) var texture2
export(StreamTexture) var texture3
export(StreamTexture) var texture4

onready var _area := $Area2D
onready var _sprite := $Sprite
onready var _player := $AnimationPlayer

var pressed = false
var mouse_entered = false

var line_alpha = 0

var times = 3 setget times_set, times_get

const gravity := Vector2(0, 2)

func times_set(value: int):
	match value:
		3:
			_sprite.texture = texture1
		2:
			_sprite.texture = texture2
		1:
			_sprite.texture = texture3
		_:
			_sprite.texture = texture4
	times = value
	
func times_get() -> int:
	return times


func _ready() -> void:
	# 复制一份新的 material
	var shader_material: ShaderMaterial = _sprite.material.duplicate()
	_sprite.material = shader_material
	
	
	_area.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	_area.connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	outline_alpha(0)
	
func _process(delta: float) -> void:
	if times < 1 and line_alpha  < 0.01:
		return
	if mouse_entered:
		line_alpha += (1 - line_alpha) * delta * 10
		_sprite.scale.x += (1.2 - _sprite.scale.x) * delta * 10
		_sprite.modulate.r += (0.7 - _sprite.modulate.r) * delta * 10
		_sprite.modulate.g += (0.7 - _sprite.modulate.g) * delta * 10
	else:
		line_alpha += (0 - line_alpha) * delta * 10
		_sprite.scale.x += (1 - _sprite.scale.x) * delta * 10
		_sprite.modulate.r += (1 - _sprite.modulate.r) * delta * 10
		_sprite.modulate.g += (1 - _sprite.modulate.g) * delta * 10
		
	outline_alpha(line_alpha)
	
	# 最近的 1 个互相吸引
	
	var force := Vector2(0, 0)
	
	var bodies = $ForceRange.get_overlapping_bodies()
	if bodies.size() >= 1:
		var body = bodies[0]
		if "Player" in body.name:
			var distance = global_position.distance_squared_to(body.global_position)
			if distance > 10000:
				force += global_position - body.global_position
		
	add_central_force(- force / 10 + gravity)
		

func _on_Area2D_mouse_entered() -> void:
	if times < 1:
		return
	mouse_entered = true


func _on_Area2D_mouse_exited() -> void:
	mouse_entered = false


func outline_alpha(value: float) -> void:
	if is_instance_valid(_sprite):
		var line_color = _sprite.material.get_shader_param("line_color")
		line_color.a = value
		_sprite.material.set_shader_param("line_color", line_color)


func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		pressed = event.is_pressed()
		if pressed:
			generate_new()

func generate_new():
	if times < 1:
		return
		
	mouse_entered = false
	var new: MyPlayer = duplicate()
	new.global_position = global_position  + Vector2(1 if randf() < 0.5 else -1, -1)
	z_index = new.z_index + 1
	get_parent().add_child(new)
	new.times = 1 if times == 1 else times
	
	times_set(times - 1)

func enemy_entered(enemy):
	times_set(times - 1)
	
	_player.play("dead", -1, 4)
	yield(_player, "animation_finished")
	queue_free()
	
func virus_entered(virus):	
	match(times):
		3, 2, 1:
			virus.generate_new()
		_:
			pass
			
	_player.play("dead", -1, 4)
	yield(_player, "animation_finished")
	queue_free()

func food_entered():
	print("win")
	pass
