extends Area2D

var direction := Vector2.RIGHT
var speed := 850.0
var damage := 20
var owner_team := "player"
var life := 1.4

func _ready():
    var shape = CollisionShape2D.new()
    var circle = CircleShape2D.new()
    circle.radius = 4
    shape.shape = circle
    add_child(shape)
    body_entered.connect(_on_body_entered)
    area_entered.connect(_on_area_entered)

func _physics_process(delta):
    position += direction.normalized() * speed * delta
    life -= delta
    if life <= 0:
        queue_free()
    queue_redraw()

func _on_body_entered(body):
    _try_hit(body)

func _on_area_entered(area):
    _try_hit(area)

func _try_hit(target):
    if owner_team == "player" and target.has_method("take_damage") and target != get_parent().get_node_or_null("Player"):
        if target.has_method("_shoot") and target.get_script() == load("res://bot.gd"):
            target.take_damage(damage)
            queue_free()
    elif owner_team == "bot" and target.has_method("take_damage") and target.get_script() == load("res://player.gd"):
        target.take_damage(damage)
        queue_free()

func _draw():
    draw_circle(Vector2.ZERO, 4, Color("#ffd36b"))
    draw_line(Vector2(-9, 0), Vector2(-3, 0), Color("#ff8a4d"), 2)
