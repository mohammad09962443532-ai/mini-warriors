extends CharacterBody2D

var bullet_scene
var health := 100
var speed := 330.0
var jump_velocity := -520.0
var gravity := 1250.0
var facing := 1
var fire_cooldown := 0.0
var mobile_left := false
var mobile_right := false
var mobile_jump := false
var mobile_jet := false
var mobile_fire := false
var jet_fuel := 100.0
var invulnerability := 0.0

func _ready():
    collision_layer = 1
    collision_mask = 1
    var shape = CollisionShape2D.new()
    var capsule = CapsuleShape2D.new()
    capsule.radius = 15
    capsule.height = 48
    shape.shape = capsule
    add_child(shape)

func _physics_process(delta):
    fire_cooldown = maxf(0.0, fire_cooldown - delta)
    invulnerability = maxf(0.0, invulnerability - delta)
    var direction := 0.0
    if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT) or mobile_left:
        direction -= 1.0
    if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT) or mobile_right:
        direction += 1.0
    if direction != 0:
        facing = int(sign(direction))
    velocity.x = direction * speed
    if not is_on_floor():
        velocity.y += gravity * delta
    if (Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or mobile_jump) and is_on_floor():
        velocity.y = jump_velocity
    var jet_pressed = Input.is_key_pressed(KEY_SHIFT) or mobile_jet
    if jet_pressed and jet_fuel > 0:
        velocity.y = maxf(velocity.y - 1150.0 * delta, -410.0)
        jet_fuel = maxf(0.0, jet_fuel - 30.0 * delta)
    else:
        jet_fuel = minf(100.0, jet_fuel + 12.0 * delta)
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or mobile_fire:
        _shoot()
    move_and_slide()
    queue_redraw()

func _shoot():
    if fire_cooldown > 0 or bullet_scene == null:
        return
    fire_cooldown = 0.18
    var bullet = bullet_scene.new()
    bullet.position = global_position + Vector2(facing * 28, -5)
    bullet.direction = Vector2(facing, 0)
    bullet.owner_team = "player"
    get_tree().current_scene.add_child(bullet)

func take_damage(amount: int):
    if invulnerability > 0:
        return
    health -= amount
    invulnerability = 0.45
    if health <= 0:
        health = 100
        position = Vector2(180, 480)

func _draw():
    var body_color = Color("#63c9a5") if invulnerability <= 0 else Color("#f4f4f4")
    draw_circle(Vector2(0, -17), 13, Color("#f0c7a0"))
    draw_rect(Rect2(-13, -7, 26, 28), body_color)
    draw_rect(Rect2(-15, 18, 11, 17), Color("#27394c"))
    draw_rect(Rect2(4, 18, 11, 17), Color("#27394c"))
    draw_rect(Rect2(7 if facing > 0 else -30, -3, 25, 6), Color("#d9e4e8"))
    draw_rect(Rect2(-9, -22, 18, 4), Color("#344b5c"))
    if Input.is_key_pressed(KEY_SHIFT) or mobile_jet:
        draw_colored_polygon(PackedVector2Array([Vector2(-7, 25), Vector2(0, 42), Vector2(7, 25)]), Color("#ff9b45"))
