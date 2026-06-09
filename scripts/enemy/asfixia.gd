extends EnemyBase

var min_scale: float = 0.05
var max_scale: float = 3.5 
var growth_rate: float = 0.02 
var can_grow: bool = true 
var base_damage: int = 5       # Con cuánto daño empieza a asfixiar
var current_damage: int = 1     # El daño real que irá subiendo
var damage_increment: int = 1   # Cuánto daño extra suma cada segundo

# Conexiones a los nodos de tu escena
@onready var smoke_sprite = $SpriteHumo
@onready var drain_aura = $AreaDrenaje
@onready var drain_aura_collision = $AreaDrenaje/CollisionShape2D
@onready var core_node = $AreaDanio

var player_inside: Node2D = null
var damage_timer: Timer

func _ready():
	super._ready()
	add_to_group("asfixia") 
	
	# 1. Configurar el reloj de daño por asfixia
	damage_timer = Timer.new()
	damage_timer.wait_time = 0.2 
	damage_timer.timeout.connect(_drain_health)
	add_child(damage_timer)
	
	# 2. Conectar las señales del radar de humo
	drain_aura.body_entered.connect(_on_body_entered)
	drain_aura.body_exited.connect(_on_body_exited)
	
	# 3. Independizar la colisión para que los 3 enemigos no se afecten entre sí
	drain_aura_collision.shape = drain_aura_collision.shape.duplicate()
	
	# 4. Encogemos el dibujo a la escala mínima
	smoke_sprite.scale = Vector2(min_scale, min_scale)
	
	# 5. Encogemos la colisión azul inmediatamente para que coincida en el primer instante
	var current_texture = smoke_sprite.sprite_frames.get_frame_texture(smoke_sprite.animation, smoke_sprite.frame)
	var actual_width = current_texture.get_width() * min_scale
	drain_aura_collision.shape.radius = (actual_width / 2.0) * 0.60
	
	# 6. Iniciar el movimiento del núcleo
	_move_core()

func _process(delta):
	# Solo crecemos si no hemos llegado al límite Y no hemos tocado una pared
	if smoke_sprite.scale.x < max_scale and can_grow:
		# A. Crecimiento visual (Animación)
		var growth = Vector2(growth_rate, growth_rate) * delta
		smoke_sprite.scale += growth
		
		# B. Crecimiento físico (La colisión azul)
		var current_texture = smoke_sprite.sprite_frames.get_frame_texture(smoke_sprite.animation, smoke_sprite.frame)
		var actual_width = current_texture.get_width() * smoke_sprite.scale.x
		
		# RESTRICCIÓN 1: El círculo azul solo cubre el 60% del humo (el centro denso)
		drain_aura_collision.shape.radius = (actual_width / 2.0) * 0.60

# --- DETECCIÓN DE JUGADOR Y PAREDES ---
func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = body
		
		current_damage = base_damage 
		
		damage_timer.start() 
		_drain_health()       
	else:
		can_grow = false

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
		damage_timer.stop() 
		
		current_damage = base_damage 

func _drain_health():
	if is_instance_valid(player_inside) and player_inside.has_method("take_damage"):
		player_inside.take_damage(current_damage, Color.DARK_GRAY)
		
		current_damage += damage_increment

# --- LÓGICA DEL NÚCLEO ESCURRIDIZO ---
func _move_core():
	if not is_instance_valid(self): return 
	
	var current_radius = drain_aura_collision.shape.radius
	
	var safe_zone = current_radius * 0.60 
	
	var random_angle = randf() * TAU
	var random_distance = randf_range(0.0, safe_zone) 
	
	var new_position = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	
	var tween = create_tween()
	var travel_time = randf_range(0.5, 1.0)
	tween.tween_property(core_node, "position", new_position, travel_time).set_trans(Tween.TRANS_SINE)
	
	tween.finished.connect(func():
		if is_instance_valid(self):
			get_tree().create_timer(randf_range(0.1, 0.2)).timeout.connect(_move_core)
	)
