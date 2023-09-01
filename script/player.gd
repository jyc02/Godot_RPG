extends CharacterBody2D

var current_states = player_states.MOVE
enum player_states {MOVE, SWORD}

const speed = 70
var dir = Vector2.ZERO 
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

var enemy_inattack_range = false
var health = 100
var player_alive = true

func _ready():
	pass

func _physics_process(_delta):
	match current_states:
		player_states.MOVE:
			player_movement(_delta)
		player_states.SWORD:
			attack()
	enemy_attack()

func player_movement(_delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_down"):
		dir = Vector2(0,1)
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		dir = Vector2(0, -1)
		velocity.y += -1
	if Input.is_action_pressed("move_right"):
		dir = Vector2(1, 0)
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		dir = Vector2(-1,0)
		velocity.x += -1
	velocity = velocity.normalized() * speed
	
	anim_tree.set("parameters/idle/blend_position", dir)
	anim_state.travel("idle")
	
	if Input.is_action_just_pressed("basic_attack"):
		current_states = player_states.SWORD	
		anim_tree.set("parameters/attack/blend_position", dir)
		
	if Input.is_action_just_pressed("interact"):
		if dir.x > 0:
			$interact_pivot.rotation_degrees = 180
		elif dir.x < 0:
			$interact_pivot.rotation_degrees = 0
		elif dir.y < 0:
			$interact_pivot.rotation_degrees = 90
		elif dir.y > 0:
			$interact_pivot.rotation_degrees = 270
		
	if velocity != Vector2.ZERO:
		anim_tree.set("parameters/walk/blend_position", dir)
		anim_state.travel("walk")

	move_and_slide()
	
func attack():
	anim_state.travel("attack")
	
func attack_finished():
	current_states = player_states.MOVE

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "left_attack" or anim_name == "right_attack" or anim_name == "front_attack" or anim_name == "back_attack":
		current_states = player_states.MOVE

func enemy_attack():
	if enemy_inattack_range:
		#print("player took dmg")
		pass

func _on_hitbox_area_entered(_area):
	enemy_inattack_range = true
	print("player getting hit")

func _on_hitbox_area_exited(_area):
	enemy_inattack_range = false

