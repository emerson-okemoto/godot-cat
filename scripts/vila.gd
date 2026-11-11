extends Node2D

@export var cena_inimigo: PackedScene

const ATAQUES_MAXIMOS: int = 5
var vida_barraca: int = ATAQUES_MAXIMOS
var terminou: bool = false

@onready var horda: Timer = $Horda
@onready var relogio: Timer = $Relogio
@onready var barraca: Sprite2D = $Barraca
@onready var impacto: Sprite2D = $Barraca/Impacto
@onready var barra_vida: Sprite2D = $HUD/BarraVida
@onready var texto_vida: Label = $HUD/Vida
@onready var texto_tempo: Label = $HUD/Tempo


func _process(_delta: float) -> void:
    var ataques: int = ATAQUES_MAXIMOS - vida_barraca
    texto_vida.text = "Ataques na barraca: %d/%d" % [ataques, ATAQUES_MAXIMOS]
    var segundos: int = int(ceil(relogio.time_left))
    var minutos: int = int(segundos / 60.0)
    texto_tempo.text = "Tempo: %02d:%02d" % [minutos, segundos % 60]


func _on_horda_timeout() -> void:
    if terminou or cena_inimigo == null:
        return

    var marcadores := $Nascedouros.get_children()
    if marcadores.is_empty():
        return
    var ponto: Marker2D = marcadores.pick_random() as Marker2D
    var inimigo := cena_inimigo.instantiate() as Node2D
    add_child(inimigo)
    inimigo.global_position = ponto.global_position
    horda.wait_time = maxf(3.0, horda.wait_time * 0.98)


func receber_ataque_barraca() -> void:
    if terminou:
        return
    # Ao terminar os 180 segundos, o jogador vence mesmo se um gato
    # estiver iniciando sua investida no mesmo instante.
    if relogio.is_stopped():
        vencer()
        return

    vida_barraca -= 1
    var quadro: int = ATAQUES_MAXIMOS - vida_barraca
    barraca.frame = quadro
    barra_vida.frame = quadro
    impacto.show()
    $TemporizadorImpacto.start()

    if vida_barraca <= 0:
        perder()


func _on_temporizador_impacto_timeout() -> void:
    impacto.hide()


func _on_relogio_timeout() -> void:
    if not terminou:
        vencer()


func vencer() -> void:
    if terminou:
        return
    terminou = true
    horda.stop()
    relogio.stop()
    get_tree().change_scene_to_file.call_deferred("res://scenes/vitoria.tscn")


func perder() -> void:
    if terminou:
        return
    terminou = true
    horda.stop()
    relogio.stop()
    get_tree().change_scene_to_file.call_deferred("res://scenes/derrota.tscn")
