extends CharacterBody2D


const speed = 30
var player_chase = false
var player = null
var pos = position
var counter = 0
var die = "false"
var direction
var slime_state = "move"

func _ready():
	pos = position
func _physics_process(_delta):
	match slime_state:
		"die":
			queue_free()
		"move":
			movement(_delta)
		"attack":
			attack()

func movement(_delta):
	velocity = Vector2.ZERO
	
	if player_chase:
		
		var posDif = (player.position - position)
		direction = (player.position - position).normalized()
		
		#when slime get close to player, it stops moving
		if posDif.y < 13.1 and posDif.y > -9.1 and posDif.x < 13 and posDif.x > -13:
			pass
			
		else:
			
			if posDif.x < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
				
			$AnimatedSprite2D.play("walk")
			velocity = direction * speed
			move_and_slide()
	else:
		
		if counter == 300:
			direction = (pos - position).normalized()
			velocity = direction * speed
			
			if velocity.x > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
				
			$AnimatedSprite2D.play("walk")
			
			if abs(pos.x - position.x) < 1 and abs(pos.y - position.y) < 1:
				counter = 0
				
			move_and_slide()
				
		if counter < 300:
			counter += 1
			
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false


func _on_hurtbox_area_entered(_area):
	$AnimatedSprite2D.play("death")
	slime_state = "die"




func _on_attack_hitbox_area_entered(area):
	slime_state = "attack"


func _on_attack_hitbox_area_exited(area):
	slime_state = "move"

func attack():
	$AnimatedSprite2D.play("attack")


func _on_animated_sprite_2d_animation_finished():
	if slime_state == "attack":
		print("attacked")
	elif slime_state == "die":
		queue_free()
			
