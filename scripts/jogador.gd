extends CharacterBody2D

@export var velocidade: float = 70.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_defesa: Area2D = $AreaDefesa


func _process(_delta: float) -> void:
    # Aperte Espaço para espantar gatos próximos.
    if Input.is_action_just_pressed("defender"):
        for corpo in area_defesa.get_overlapping_bodies():
            if corpo.is_in_group("inimigo") and corpo.has_method("afastar"):
                corpo.call("afastar")


func _physics_process(_delta: float) -> void:
    # Movimentação e animações reaproveitadas do projeto original.
    var direcao := Input.get_vector("left", "right", "up", "down")
    velocity = direcao * velocidade
    move_and_slide()

    if direcao == Vector2.ZERO:
        anim.stop()
        return

    if abs(direcao.x) > abs(direcao.y):
        if direcao.x > 0:
            anim.play("direita")
        else:
            anim.play("esquerda")
    else:
        if direcao.y > 0:
            anim.play("baixo")
        else:
            anim.play("cima")
