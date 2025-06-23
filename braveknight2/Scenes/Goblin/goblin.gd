extends BaseEnemy

var direction: Vector2 = Vector2.RIGHT
var initial_pos: Vector2
var previous_state : ENEMY_STATES
@export var gravity = 1000.0
@onready var LookTimer = $LookTimer
@onready var WaitTimer = $WaitTime

func _ready(): 
	super._ready()
	current_state = ENEMY_STATES.PATROL
	initial_pos = global_position
	hp = 1

func _physics_process(delta: float) -> void:
	match current_state:
		ENEMY_STATES.RETURNING:
			nav_agent.target_position = initial_pos
			direction = to_local(nav_agent.get_next_path_position()).normalized()
			if nav_agent.is_navigation_finished():
				direction = Vector2.RIGHT
				current_state = ENEMY_STATES.PATROL
		ENEMY_STATES.FOLLOWING_PLAYER:
			if not patrol_timer.is_stopped():
				patrol_timer.stop()
			nav_agent.target_position = player_ref.global_position
			direction = to_local(nav_agent.get_next_path_position()).normalized()
		ENEMY_STATES.LOOKING_PLAYER:
			if not patrol_timer.is_stopped():
				patrol_timer.stop()
			velocity = Vector2.ZERO
			if player_ref.global_position.x > global_position.x:
				anim_sprite2d.flip_h = false
			else:
				anim_sprite2d.flip_h = true
		ENEMY_STATES.PATROL:
			if patrol_timer.is_stopped():
				patrol_timer.start()
	velocity.x = direction.x * movement_speed * delta
	if current_state != ENEMY_STATES.LOOKING_PLAYER:
		if velocity.x > 0:
			anim_sprite2d.flip_h = false 
		elif velocity.x < 0:
			anim_sprite2d.flip_h = true
		move_and_slide()
	apply_gravity(delta)

func apply_gravity(delta):
	velocity.y += gravity * delta

func _on_detection__area_entered(area: Area2D) -> void:
	current_state = ENEMY_STATES.LOOKING_PLAYER
	if LookTimer.is_stopped():
		LookTimer.start()
	print("Im looking at the player!")
	


func _on_patrol_timer_timeout() -> void:
	direction *= -1


func _on_detection_area_exited(area: Area2D) -> void:
	current_state = ENEMY_STATES.RETURNING
	LookTimer.stop()
	LookTimer.start()
	LookTimer.stop()
	if not WaitTimer.is_stopped():
		WaitTimer.stop()

func _on_look_timer_timeout() -> void:
	print("I'm gonna attack you!")
	anim_sprite2d.play("Attack")
	WaitTimer.start()

func attack():
	if player_ref == null:
		return
	ObjectMaker.create_bomb(global_position, player_ref.global_position)

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_sprite2d.animation == "Attack":
		attack()
		anim_sprite2d.play("Idle")
	if anim_sprite2d.animation == "Death":
		hitbox.monitorable = false
		hitbox.monitoring = false
		queue_free()

func _on_wait_time_timeout() -> void:
	print("Wait is Over!")
	anim_sprite2d.play("Attack")


func _on_hit_box_area_entered(area: Area2D) -> void:
	hp -= player_ref.strength
	hitbox.monitoring = false
	if hp <= 0:
		current_state = ENEMY_STATES.DEATH
		anim_sprite2d.play("Death")
	else:
		previous_state = current_state	
		current_state = ENEMY_STATES.HIT
		direction *= -1
		invicible_timer.start()
		var tween = create_tween()
		tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
		tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)
		tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
		tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)


func _on_invincible_timer_timeout() -> void:
	current_state = previous_state
	hitbox.monitoring = true
