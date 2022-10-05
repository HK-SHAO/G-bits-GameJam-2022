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

var bodies: Array = []

var player_num := 0
var food_num := 0
var tile_num := 0

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

func _physics_process(delta: float) -> void:
	var force := Vector2(0, 0)
	
	var food_num_tmp := 0
	for area in $ForceRange.get_overlapping_areas():
		if "FoodArea" in area.name:
				food_num_tmp += 1
	if food_num != food_num_tmp:
		food_num = food_num_tmp
		
	var tile_num_tmp := 0
	# for body in get_colliding_bodies():
	# 	if body != self and is_instance_valid(body):
	# 		if "Tile" in body.name:
	# 			tile_num_tmp += 1
				
	if tile_num != tile_num_tmp:
		tile_num = tile_num_tmp
	
	bodies = $ForceRange.get_overlapping_bodies()
	var player_num_tmp := 0
	
	
	for body in bodies:
		if body != self and is_instance_valid(body):
			if "Player" in body.name:
				player_num_tmp += 1
				var distance = global_position.distance_squared_to(body.global_position)
				if distance > 10000:
					force += global_position - body.global_position
				else:
					force -= global_position - body.global_position
			elif "Virus" in body.name or "Enemy" in body.name:
				force -= global_position - body.global_position
				
	apply_central_impulse(- force * delta)
		
	
	if food_num >= 1 or tile_num >= 1:
		times_set(3)
		return
		
	if player_num != player_num_tmp:
		player_num = player_num_tmp
		match(player_num):
			0: # 挂掉
				times_set(0)
				pass
			1: # 生成 1 个
				times_set(2)
				pass
			2: # 生成 2 个
				times_set(3)
				pass
			3: # 无法起作用
				times_set(1)
				pass
			_: # 挂掉
				times_set(0)
				pass

func _on_Area2D_mouse_entered() -> void:
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
			when_pressed()

func when_pressed():
	if food_num >= 1 or tile_num >= 1:
		generate_new()
		return
	match(player_num):
		0: # 细胞挂掉
			dead()
			pass
		1: # 一次生成 1 个细胞
			generate_new()
			pass
		2: # 一次生成 2 个细胞
			generate_new()
			generate_new()
			pass
		3: # 生成一个新细胞，老细胞挂掉
			generate_new()
			dead()
			pass
		_: # 细胞挂掉
			dead()
			pass

func generate_new():
	if times < 1:
		return
		
	mouse_entered = false
	var new: MyPlayer = duplicate()
	new.global_position = global_position\
	  + Vector2(1 if randf() < 0.5 else -1, 1 if randf() < 0.5 else -1)
	z_index = new.z_index + 1
	get_parent().add_child(new)
	new._player.play("spawn")
	new.times = 1 if times == 1 else times - 1
	
	$audio_add.play()
	
	# times_set(times - 1)

func enemy_entered(enemy):
	dead()
	
func virus_entered(virus):
	match(times):
		3, 2, 1, 0:
			$audio_add.play()
			virus.generate_new()
		_:
			pass
			
	dead()
	
func dead():
	times_set(-1)
	_player.play("dead", -1, 2)
	yield(_player, "animation_finished")
	queue_free()
	
