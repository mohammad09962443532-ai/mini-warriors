extends Node2D

const PLAYER_SCRIPT = preload("res://player.gd")
const BOT_SCRIPT = preload("res://bot.gd")
const BULLET_SCRIPT = preload("res://bullet.gd")

var player
var bots: Array[Node2D] = []
var platforms: Array[Rect2] = []
var world_width := 2600.0
var world_height := 1100.0
var camera: Camera2D
var score := 0
var status_label: Label
var touch_left := false
var touch_right := false
var touch_jump := false
var touch_fire := false
var touch_jet := false

func _ready():
    randomize()
    _build_level()
    player = PLAYER_SCRIPT.new()
    player.position = Vector2(180, 480)
    player.bullet_scene = BULLET_SCRIPT
    add_child(player)
    camera = Camera2D.new()
    camera.position_smoothing_enabled = true
    camera.position_smoothing_speed = 5.0
    player.add_child(camera)
    camera.position = Vector2.ZERO
    camera.limit_left = 0
    camera.limit_top = 0
    camera.limit_right = int(world_width)
    camera.limit_bottom = int(world_height)
    for i in range(6):
        var bot = BOT_SCRIPT.new()
        bot.position = Vector2(650 + i * 300, 350 + (i % 3) * 80)
        bot.bullet_scene = BULLET_SCRIPT
        add_child(bot)
        bots.append(bot)
    _build_ui()

func _build_level():
    platforms = [
        Rect2(0, 640, 2600, 80),
        Rect2(260, 500, 220, 24),
        Rect2(600, 420, 190, 24),
        Rect2(900, 530, 250, 24),
        Rect2(1260, 440, 200, 24),
        Rect2(1600, 350, 240, 24),
        Rect2(1970, 490, 240, 24),
        Rect2(400, 300, 140, 20),
        Rect2(1050, 280, 160, 20),
        Rect2(1800, 220, 170, 20)
    ]

func _build_ui():
    var canvas = CanvasLayer.new()
    add_child(canvas)
    status_label = Label.new()
    status_label.position = Vector2(18, 14)
    status_label.add_theme_font_size_override("font_size", 24)
    status_label.text = "MINI WARRIORS   |   HP: 100   |   SCORE: 0"
    canvas.add_child(status_label)
    var hint = Label.new()
    hint.position = Vector2(18, 48)
    hint.add_theme_font_size_override("font_size", 16)
    hint.text = "Keyboard: A/D move • Space jump • Shift jetpack • Mouse click fire"
    canvas.add_child(hint)
    _make_button(canvas, "◀", Vector2(30, 560), "left")
    _make_button(canvas, "▶", Vector2(112, 560), "right")
    _make_button(canvas, "JUMP", Vector2(930, 565), "jump")
    _make_button(canvas, "JET", Vector2(1035, 565), "jet")
    _make_button(canvas, "FIRE", Vector2(1135, 565), "fire")

func _make_button(parent: Node, label_text: String, pos: Vector2, action: String):
    var b = Button.new()
    b.text = label_text
    b.position = pos
    b.size = Vector2(76, 64)
    b.add_theme_font_size_override("font_size", 20)
    b.button_down.connect(func(): _set_touch(action, true))
    b.button_up.connect(func(): _set_touch(action, false))
    parent.add_child(b)

func _set_touch(action: String, value: bool):
    match action:
        "left": touch_left = value
        "right": touch_right = value
        "jump": touch_jump = value
        "jet": touch_jet = value
        "fire": touch_fire = value

func _process(_delta):
    if not is_instance_valid(player):
        return
    player.mobile_left = touch_left
    player.mobile_right = touch_right
    player.mobile_jump = touch_jump
    player.mobile_jet = touch_jet
    player.mobile_fire = touch_fire
    status_label.text = "MINI WARRIORS   |   HP: %d   |   SCORE: %d" % [player.health, score]
    queue_redraw()
    for bot in bots:
        if is_instance_valid(bot) and bot.health <= 0:
            score += 1
            bot.queue_free()
    bots = bots.filter(func(b): return is_instance_valid(b))
    if bots.size() < 4:
        var bot = BOT_SCRIPT.new()
        bot.position = Vector2(randf_range(500, world_width - 100), randf_range(250, 500))
        bot.bullet_scene = BULLET_SCRIPT
        add_child(bot)
        bots.append(bot)

func _draw():
    draw_rect(Rect2(0, 0, world_width, world_height), Color("#182638"))
    # distant sky lights and stars
    for i in range(75):
        var x = float((i * 173) % int(world_width))
        var y = float((i * 89) % 560)
        draw_circle(Vector2(x, y), 1.8, Color(0.55, 0.72, 0.85, 0.55))
    # industrial skyline
    for i in range(18):
        var x = i * 155.0
        var h = 90.0 + float((i * 47) % 160)
        draw_rect(Rect2(x, 640 - h, 90, h), Color("#25394a"))
        draw_rect(Rect2(x + 12, 640 - h + 20, 9, 15), Color("#e8b85b"))
        draw_rect(Rect2(x + 36, 640 - h + 20, 9, 15), Color("#e8b85b"))
    for p in platforms:
        draw_rect(p, Color("#526b78"))
        draw_rect(Rect2(p.position.x, p.position.y, p.size.x, 5), Color("#9fb8bd"))
    # floor hazard stripes
    for x in range(0, 2600, 55):
        draw_line(Vector2(x, 640), Vector2(x + 25, 640), Color("#f0bd55"), 4)

func get_platforms() -> Array[Rect2]:
    return platforms
