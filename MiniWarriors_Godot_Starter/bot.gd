extends CharacterBody2D

var bullet_scene
var health := 100
var speed := 115.0
var gravity := 1200.0
var fire_cooldown := 0.8
var facing := -1
var wander_timer := 0.0

func _ready():
    collision_layer = 1
    collision_mask = 1
    var shape = CollisionShape2D.new()
    var capsule = CapsuleShape2D.new()
    capsule.radius = 15
    capsule.height = 46
    shape.shape = capsule
    add_child(shape)

func _physics_process(delta):
    if health <= 0:
        return
    var target = get_tree().get_first_node_in_group("player")
    if target == null:
        target = _find_player()
    if target:
        var dx = target.global_position.x - global_position.x
        facing = 1 if dx > 0 else -1
        if absf(dx) > 230:
            velocity.x = signf(dx) * speed
        else:
            velocity.x = 0
            fire_cooldown -= delta
            if fire_cooldown <= 0:
                _shoot()
                fire_cooldown = randf_range(0.8, 1.5)
    if not is_on_floor():
        velocity.y += gravity * delta
    move_and_slide()
    queue_redraw()

func _find_player():
    for n in get_tree().current_scene.get_children():
        if n.get_script() == load("res://player.gd"):
            return n
    return null

func _shoot():
    if bullet_scene == null:
        return
    var bullet = bullet_scene.new()
    bullet.position = global_position + Vector2(facing * 24, -4)
    bullet.direction = Vector2(facing, 0)
    bullet.owner_team = "bot"
    get_tree().current_scene.add_child(bullet)

func take_damage(amount: int):
    health -= amount
    if health <= 0:
        queue_free()

func _draw():
    draw_circle(Vector2(0, -16), 12, Color("#d9a987"))
    draw_rect(Rect2(-13, -6, 26, 26), Color("#d76c5a"))
    draw_rect(Rect2(-14, 18, 11, 15), Color("#34465b"))
    draw_rect(Rect2(4, 18, 11, 15), Color("#34465b"))
    draw_rect(Rect2(7 if facing > 0 else -28, -2, 23, 5), Color("#dbe5e8"))
