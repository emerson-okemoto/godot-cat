DEVLOG | Feira de Rua com Gatos Famintos

Disciplina: Jogos Digitais II
Projeto: Feira de Rua com Gatos Famintos
Engine: Godot
Linguagem: GDScript
Tipo de jogo: Defesa
Modo: Horda (visão de cima)

Aula 08 | 07/10/2026

O que fiz: Criei o projeto na Godot, montei o cenário inicial utilizando TileMap e TileSet e implementei a movimentação da personagem nas quatro direções.

O que travou: Tive dificuldades para configurar as colisões do cenário, pois a personagem conseguia atravessar alguns obstáculos.

Como resolvi: Revisei as camadas de física do TileSet, configurei as colisões dos objetos e ajustei a movimentação utilizando CharacterBody2D e move_and_slide().

Aula 09 | 21/10/2026

O que fiz: Implementei a mecânica de defesa da barraca, o cronômetro de três minutos, o contador de ataques e as condições de vitória e derrota.

O que travou: O contador de danos não estava funcionando corretamente e, em alguns testes, a partida continuava mesmo depois de atingir o limite de cinco ataques.

Como resolvi: Organizei o controle de danos no script vila.gd, adicionei uma variável para verificar o encerramento da partida e configurei as transições para as cenas de vitória e derrota.

Aula 10 | 28/10/2026

O que fiz: Desenvolvi a inteligência dos gatos, permitindo que apareçam no cenário, persigam a barraca, desviem de obstáculos e realizem ataques.

O que travou: Alguns gatos ficavam presos nos obstáculos ou continuavam tentando atacar mesmo quando eram afastados pela personagem.

Como resolvi: Ajustei a movimentação dos inimigos e organizei seus comportamentos em estados de perseguição, ataque e susto, utilizando verificações de distância e temporizadores.

Aula 11 | 04/11/2026

O que fiz: Substituí o cenário inicial por uma feira de rua em pixel art, adicionei barracas, alimentos, elementos decorativos e novas animações para a feirante e os gatos.

O que travou: Alguns sprites apresentavam tamanhos diferentes, causando problemas de proporção e alinhamento das animações.

Como resolvi: Ajustei a escala dos sprites, organizei os recursos gráficos e configurei as animações com AnimatedSprite2D, procurando manter a identidade visual do tileset Tiny Town.

Aula 12 | 11/11/2026

O que fiz: Melhorei o ataque com a vassoura nas quatro direções e implementei a reação dos gatos, que fogem durante dois segundos antes de voltar a perseguir a barraca.

O que travou: A área de defesa não acompanhava corretamente a direção da personagem e alguns gatos continuavam atacando mesmo depois de receberem uma vassourada.

Como resolvi: Ajustei a posição da Area2D conforme a direção da personagem e modifiquei o script dos inimigos para interromper o ataque e priorizar o estado de susto.

Aula 13 | 18/11/2026

O que fiz: Realizei ajustes finais na jogabilidade, revisei o funcionamento do cronômetro, das animações e das condições de vitória e derrota. Também organizei a documentação do projeto no GitHub.

O que travou: Durante os testes, percebi que precisava evitar a execução simultânea das condições de vitória e derrota quando o tempo terminava próximo de um ataque dos gatos.

Como resolvi: Revisei a lógica de encerramento da partida, utilizei uma variável de controle para impedir múltiplas finalizações e organizei os arquivos para a apresentação.


### Criação dos sprites de ataque com vassoura

Utilizei inteligência artificial generativa para criar os sprites da animação de ataque com vassoura. A animação mostra a feirante usando a vassoura para espantar os gatos que se aproximam da barraca de peixes.