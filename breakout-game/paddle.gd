class_name Paddle
extends CharacterBody2D

enum State {IDLE, RISING, RETURNING}

@export var speed := 600.0
@export var push_speed := 900.0
@export var return_speed := 400.0
@export var push_height := 5.0

@export var shape_size = Vector2(120, 20)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


var state := State.IDLE
var home_y: float

func _ready() -> void:
	var shape := RectangleShape2D.new()
	shape.size = shape_size
	collision_shape.shape = shape
	home_y = position.y
	
func _draw() -> void:
	draw_rect(Rect2(-shape_size*0.5, shape_size),Color.ORANGE_RED)

func _physics_process(delta: float) -> void:
		velocity.x = Input.get_axis("move_left", "move_right") * speed
		
		match state:
			State.IDLE:
				velocity.y = 0.0
				if Input.is_action_just_pressed("move_up"):
					state = State.RISING
			State.RISING:
				velocity.y = -push_speed
				if position.y <= home_y - push_height:
					position.y = home_y - push_height
					state = State.RETURNING
			State.RETURNING:
				velocity.y = return_speed
				if position.y >= home_y:
					position.y = home_y
					velocity.y = 0.0
					state = State.IDLE
		
		move_and_slide()
