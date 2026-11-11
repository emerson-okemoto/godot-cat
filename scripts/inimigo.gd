extends CharacterBody2D

# O gato persegue a barraca, mas foge por 2 segundos ao ser espantado.
@export var velocidade: float = 40.0
@export var distancia_ataque: float = 20.0
@export var preparacao_ataque: float = 0.65
@export var duracao_susto: float = 2.0
@export var velocidade_fuga: float = 115.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var atacando: bool = false
var assustado: bool = false
var cronometro: float = 0.0
var tempo_susto_restante: float = 0.0
var direcao_fuga: Vector2 = Vector2.ZERO
var barraca: Node2D
var desvio: Vector2 = Vector2.ZERO
var tempo_desvio: float = 0.0


func _ready() -> void:
	barraca = get_tree().get_first_node_in_group("barraca") as Node2D
	anim.play("andar")


func _physics_process(delta: float) -> void:
	if not is_instance_valid(barraca):
		velocity = Vector2.ZERO
		return

	# O susto tem prioridade sobre o ataque e a perseguição.
	if assustado:
		tempo_susto_restante = maxf(0.0, tempo_susto_restante - delta)
		velocity = direcao_fuga * velocidade_fuga
		move_and_slide()
		if tempo_susto_restante <= 0.0:
			assustado = false
			velocity = Vector2.ZERO
			anim.modulate = Color.WHITE
			anim.play("andar")
		return

	if atacando:
		# O gato prepara o ataque sem depender de uma animação inexistente.
		cronometro -= delta
		velocity = Vector2.ZERO
		if cronometro <= 0.0:
			if global_position.distance_to(barraca.global_position) <= distancia_ataque + 4.0:
				var cena := get_tree().current_scene
				if cena != null and cena.has_method("receber_ataque_barraca"):
					cena.receber_ataque_barraca()
				queue_free()  # O gato leva alimento e deixa a feira.
			else:
				atacando = false
				anim.modulate = Color.WHITE
				anim.play("andar")
		return

	var distancia: float = global_position.distance_to(barraca.global_position)
	if distancia <= distancia_ataque:
		atacar()
		return

	var rumo: Vector2 = global_position.direction_to(barraca.global_position)
	tempo_desvio = maxf(0.0, tempo_desvio - delta)

	# Tenta contornar obstáculos próximos sem exigir navegação adicional.
	if tempo_desvio <= 0.0 and test_move(global_transform, rumo * 14.0):
		var lateral_a: Vector2 = rumo.rotated(PI / 2.0)
		var lateral_b: Vector2 = rumo.rotated(-PI / 2.0)
		if not test_move(global_transform, lateral_a * 14.0):
			desvio = lateral_a
			tempo_desvio = 0.75
		elif not test_move(global_transform, lateral_b * 14.0):
			desvio = lateral_b
			tempo_desvio = 0.75
	velocity = (desvio if tempo_desvio > 0.0 else rumo) * velocidade
	move_and_slide()
	anim.play("andar")


func atacar() -> void:
	atacando = true
	cronometro = preparacao_ataque
	velocity = Vector2.ZERO
	anim.stop()
	anim.modulate = Color(1.0, 0.75, 0.6, 1.0)


func afastar(posicao_jogador: Vector2) -> void:
	# Cada novo golpe renova os 2 segundos de susto.
	# Mesmo se estiver preparando um ataque, o gato foge imediatamente.
	atacando = false
	cronometro = 0.0
	assustado = true
	tempo_susto_restante = duracao_susto
	tempo_desvio = 0.0
	desvio = Vector2.ZERO

	# Corre na direção oposta à feirante que acertou a vassourada.
	direcao_fuga = (global_position - posicao_jogador).normalized()
	if direcao_fuga == Vector2.ZERO:
		# Se os dois estão exatamente no mesmo lugar, afasta-se da barraca.
		if is_instance_valid(barraca):
			direcao_fuga = (global_position - barraca.global_position).normalized()
		if direcao_fuga == Vector2.ZERO:
			direcao_fuga = Vector2.DOWN

	velocity = direcao_fuga * velocidade_fuga
	anim.modulate = Color(0.75, 0.85, 1.0, 1.0)
	anim.play("andar")
