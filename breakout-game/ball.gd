extends CharacterBody2D

@export var radius := 8.0
@export var speed := 400.0
@export var max_bounce_radius := 60.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	var shape := CircleShape2D.new()
	shape.radius = radius
	collision_shape.shape = shape
	velocity = Vector2(1, -1).normalized() * speed
	
func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)
	
func _physics_process(delta: float) -> void:
	var hit := move_and_collide(velocity * delta)
	if not hit:
		return
	
	var collider := hit.get_collider()
	var paddle := collider as Paddle #Este "as" setea el paddle como un null cuando el collider no es un Paddle.
	
	if collider is Paddle:
		var offset : float = (global_position.x - collider.global_position.x) / (collider.shape_size.x * 0.5)
		offset = clampf(offset, -1, 1)
		
		var angle := offset * deg_to_rad(max_bounce_radius)
		velocity = Vector2(sin(angle), -cos(angle)) * speed
	else:
		velocity = velocity.bounce(hit.get_normal())
	
	if collider.has_method("hit"):
		collider.hit()
		
		
		
		
	
