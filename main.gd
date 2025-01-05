extends Node2D


## Clock to be spawned.
@export var clock_scene: PackedScene

## Radius of the clock, in pixels.
@export var clock_radius := 128.0

@export_group("Clock Instances")
@export_range(0.1, 1.0) var scale_min := 0.25
@export_range(0.1, 1.0) var scale_max := 1.0
@export var time_scale_min := -10.0
@export var time_scale_max := 10.0

@export_group("Nodes")
@export var bottom: Node2D
@export var ground: Node2D

var _window_width: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().size_changed.connect(_on_size_changed)
	_on_size_changed()

func _on_size_changed() -> void:
	var window_size := get_window().size
	_window_width = window_size.x
	bottom.position.y = window_size.y + clock_radius * 2.0
	ground.scale = Vector2(window_size.x, clock_radius)
	ground.position = Vector2(
		window_size.x * 0.5,
		window_size.y + clock_radius * 0.5
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bottom_body_entered(body: Node2D) -> void:
	body.queue_free()


func _on_spawn_timer_timeout() -> void:
	var clock := clock_scene.instantiate() as Clock
	
	clock.start_time = Clock.StartTimeMode.RANDOM_TIME
	clock.time_scale = randf_range(time_scale_min, time_scale_max)
	clock.set_uniform_scale(randf_range(scale_min, scale_max))
	
	clock.position = Vector2(
		randf_range(clock_radius, _window_width - clock_radius), 
		clock_radius * -3.0
	)
	add_child(clock)
