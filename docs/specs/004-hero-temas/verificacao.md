# Verificação da 004. Home: hero, contagens e cartões dos temas

- **Data:** 2026-11-03
- **Resultado:** aprovada com ressalvas (status da spec: `verificada com ressalvas`)

Código revisado no `git diff 3575d95..HEAD` (commits 3d5d65e, da3114b e f850e91), não só no relatório da implementação. A única ressalva é externa ao código: a regra de leitura por grupo de coleções ainda não está publicada no dev, então o critério 4 com dados reais fica para depois da publicação.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found |
| `fvm flutter test` | 143 testes passaram; depois da correção, nenhum aviso de toque fora do alvo |
| `fvm dart format --set-exit-if-changed` nos 24 `.dart` alterados (fora `*.g.dart`) | 0 arquivos alterados |
| `fvm flutter build web --release` (dados reais e, numa segunda cópia, datasource simulado) | concluiu sem erro |
| `fvm flutter run -d web-server` (debug) em 390 e 1280 | sem asserção, exceção nem `overflow` no log e no console |
| `grep` por `Color(0x`, `fontSize:` numérico, `EdgeInsets`/`SizedBox` com número e `Duration(milliseconds` em `lib/features/home`, `lib/features/catalog` e no esqueleto | só `logo.dart` (antigo, fora de uso, fora do diff) |
| `git diff --stat 3575d95..HEAD` | nada em `lib/features/admin/`, `app_router.dart`, `lib/core/models/`, `pubspec.*`; `firestore.rules` só com o bloco de leitura |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Hero com rótulo, título, texto, dois botões e as três contagens | passou | Tela em 1280, 768 e 390 igual à aba "Home" do protótipo (`.hero-x`, `.stats-row`); rótulo e destaque em `accentStrong` (decisão do plano) |
| 2 | "Explorar os temas" rola até "Por onde começar" e move o foco | passou | Clique rola até a seção; o Tab seguinte acende o anel do primeiro cartão e o próximo, o do segundo (`home_page.dart`, `_exploreThemes`) |
| 3 | "Como fazemos a curadoria" leva a `/sobre` | passou | Abre a página "não encontrada" com "Sobre" marcado na navbar. A barra de endereço continua em `/` porque o GoRouter não troca a URL quando cai no `errorBuilder`; o link "Sobre" da navbar faz o mesmo hoje e a rota nasce na 006 |
| 4 | Contagens batem com o ambiente (190, 31, 4; 35, 74, 42, 39) | pendente da publicação da regra | Com datasource simulado (só na cópia de conferência, com 3 objetos em Movimentos da Terra): 190 / 31 / 4 no hero e 35, 74, 42, 39 nos cartões; `catalog_model_test.dart` confere os mesmos totais. Com o Firestore real a consulta é negada. **Conferir após publicar a regra** |
| 5 | Catálogo numa consulta só; voltar à Home não repete | passou | `catalog_datasource.dart` faz uma `collectionGroup('contents').get()`; com o datasource simulado, abrir um tema e voltar pela marca deixou um único `fetchAll` no console e o 190 apareceu na hora; `catalog_store_test.dart` cobre chamadas simultâneas |
| 6 | `firestore.rules` com a leitura por grupo; gravação igual | passou | Diff do arquivo só acrescenta `match /{path=**}/contents/{contentId} { allow read: if true; }`. Não publicado (fica com a pessoa) |
| 7 | Anel com 4 medalhões, cada um leva ao tema, com nome acessível | passou | Árvore de acessibilidade: 4 links com o nome do tema; anel, tracejado e símbolo fora dela; hover aumenta o medalhão; `themes_orbit_test.dart` |
| 8 | Cartões com faixa, medalhão, nome, descrição, contagens e até 4 subtemas + "+N" | passou (contagens de objetos com dados simulados) | Tela: faixa em degradê, medalhão 116/68 px, "+3", "+8", "+2", "+2"; `theme_overview_card_test.dart` |
| 9 | Cartão inteiro clicável; foco passa uma vez por cartão | passou | Enter no cartão focado abre o tema; clique no meio do cartão abre o tema; Tab vai de um cartão ao outro sem parar no título; h3 continua cabeçalho dentro do link |
| 10 | Esqueleto ao carregar; contagens somem sem quebrar a Home na falha | passou | Datasource simulado com 4 s: esqueleto no número de objetos (hero e cartões). Com o Firestore real (`PERMISSION_DENIED`): ficam "31 subtemas" e "4 temas", cartões só com "N subtemas", sem erro na tela. Sem rede o limite de 15 s leva ao mesmo estado (`catalog_repository.dart`) |
| 11 | Ilustração ausente mostra o placeholder | passou | Testes de widget com pacote de assets que falha (`themes_orbit_test.dart`, `theme_overview_card_test.dart`) |
| 12 | Sem carrossel nem texto de boas-vindas | passou | `themes_row.dart` e `theme_card.dart` apagados; `HomeBanner` fora da `HomePage` (arquivo mantido para a 006) |
| 13 | 390, 768 e 1280 sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1 | passou | `scrollWidth` igual à largura nas três; debug sem `overflow`. Contrastes: inkSecondary/surface 6,45; inkSecondary/branco 7,01; accentStrong/surface 6,26; accent/branco 4,87; branco/accent 4,87 |

## Problemas encontrados
- Números das contagens do hero com altura de linha e espaçamento de letras escritos no código (`hero_counts.dart`). Ajuste. **Corrigido:** tokens `heroCountLineHeight` e `heroCountLetterSpacing` no `ComponentSizes`.
- Dois comentários que só descreviam o código (`_HeroCirclesPainter`, `ThemesOrbit`). Detalhe. **Corrigido:** removidos.
- Testes de toque no cartão emitiam três avisos "would not hit test" (o toque cai na camada clicável por cima, de propósito). Detalhe. **Corrigido:** `warnIfMissed: false` com o porquê.

## Não conferido
- Critério 4 com dados reais: depende da publicação da regra no `expogeo-dev` (e na produção antes do merge na `main`).
- Ferramenta de rede do navegador não mostra o canal do Firestore; a consulta única foi conferida com o datasource simulado e pelo código.
- Painel admin na tela: sem credenciais de teste. Nenhum arquivo dele mudou.
