extends CharacterBody2D


@export var speed = 250.0
@export var throw_speed = -200.0
@export var bomb_gravity = 400.0
@onready var explode_timer = $ExplodeTimer
@onready var anim_sprite_2d = $AnimatedSprite2D
@onready var explosion_hitbox = $ExplosionArea
var has_landed = false

func setup(direction: Vector2):
	var bomb_direction = (direction - global_position).normalized()
	velocity.x = bomb_direction.x * speed
	velocity.y = throw_speed

func _physics_process(delta):
	velocity.y += bomb_gravity * delta
	if is_on_floor() and not has_landed:
		velocity.x = 0
		has_landed = true
		explode_timer.start()
	move_and_slide()

func explode_bomb():
	anim_sprite_2d.stop()
	anim_sprite_2d.play("Before_explosion")
	

func _on_explode_timer_timeout() -> void:
	print("bomb is gonna explode")
	explode_bomb()
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_sprite_2d.animation == "Explode":
		queue_free()
	if anim_sprite_2d.animation == "Before_explosion":
		explosion_hitbox.set_deferred("monitorable", true)
		explosion_hitbox.set_deferred("monitoring", true)
		anim_sprite_2d.play("Explode")


func _on_explosion_area_body_entered(body: Node2D) -> void:
	print("something detected")
	if body.is_in_group("player"):
		body.get_hit(velocity)
