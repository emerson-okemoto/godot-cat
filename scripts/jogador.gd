extends CharacterBody2D

# A vassoura assusta os gatos e os faz fugir, sem causar dano.
@export var velocidade: float = 70.0
@export var intervalo_ataque: float = 0.65

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_defesa: Area2D = $AreaDefesa
@onready var colisao_defesa: CollisionShape2D = $AreaDefesa/CollisionShape2D

var olhando: String = "down"
var atacando: bool = false
var recarga: float = 0.0
var atingidos: Dictionary = {}


func _ready() -> void:
    anim.animation_finished.connect(_ao_terminar_animacao)
    _posicionar_vassoura()
    anim.play("baixo")
    anim.stop()


func _physics_process(delta: float) -> void:
    recarga = maxf(0.0, recarga - delta)

    var direcao := Input.get_vector("left", "right", "up", "down")
    velocity = direcao * velocidade
    move_and_slide()

    # A direção só muda quando não há um golpe em andamento.
    if not atacando:
        if direcao != Vector2.ZERO:
            _guardar_direcao(direcao)
        if Input.is_action_just_pressed("defender") and recarga <= 0.0:
            _comecar_ataque()
        else:
            _animar_passos(direcao)
    elif anim.frame >= 2 and anim.frame <= 4:
        # O alcance só tem efeito na parte ativa da varredura.
        for corpo in area_defesa.get_overlapping_bodies():
            if corpo.is_in_group("inimigo") and corpo.has_method("afastar"):
                var id: int = corpo.get_instance_id()
                if not atingidos.has(id):
                    atingidos[id] = true
                    corpo.afastar(global_position)


func _guardar_direcao(direcao: Vector2) -> void:
    if absf(direcao.x) > absf(direcao.y):
        olhando = "right" if direcao.x > 0.0 else "left"
    else:
        olhando = "down" if direcao.y > 0.0 else "up"
    _posicionar_vassoura()


func _posicionar_vassoura() -> void:
    match olhando:
        "left":
            colisao_defesa.position = Vector2(-23, 0)
            colisao_defesa.rotation = PI / 2.0
        "right":
            colisao_defesa.position = Vector2(23, 0)
            colisao_defesa.rotation = PI / 2.0
        "up":
            colisao_defesa.position = Vector2(0, -23)
            colisao_defesa.rotation = 0.0
        _:
            colisao_defesa.position = Vector2(0, 23)
            colisao_defesa.rotation = 0.0


func _comecar_ataque() -> void:
    atacando = true
    recarga = intervalo_ataque
    atingidos.clear()
    anim.scale = Vector2(0.5, 0.5)  # O novo atlas usa células de 96x96.
    anim.play("attack_" + olhando)


func _ao_terminar_animacao() -> void:
    if not atacando:
        return
    atacando = false
    anim.scale = Vector2(0.1, 0.1)  # Escala original da caminhada.
    _animar_passos(Input.get_vector("left", "right", "up", "down"))


func _animar_passos(direcao: Vector2) -> void:
    var nome: String = ""
    match olhando:
        "up":
            nome = "cima"
        "left":
            nome = "esquerda"
        "right":
            nome = "direita"
        _:
            nome = "baixo"

    if anim.animation != nome or not anim.is_playing():
        anim.play(nome)
    if direcao == Vector2.ZERO:
        anim.stop()
        anim.frame = 0
