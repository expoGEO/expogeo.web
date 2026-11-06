# Verificação da 007. Página do tema

- **Data:** 2026-11-04
- **Resultado:** aprovada com ressalvas (status da spec: `verificada com ressalvas`)
- **Escopo revisado:** código de `git diff a5ef8e8..4fe364e` (commits f80f527 e 4fe364e), não só as notas da implementação. Correções no commit `fix:` logo depois de 4fe364e.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found, antes e depois das correções |
| `fvm flutter test` (cópia em caminho ASCII) | 295 testes passaram antes das correções; 300 depois (5 novos) |
| `fvm dart format --output=none --set-exit-if-changed` nos 13 `.dart` da entrega | 0 alterados |
| `fvm flutter build web --release` (cópia ASCII, Firestore real do dev) | concluiu, antes e depois das correções |
| `fvm flutter run -d web-server` (debug, cópia ASCII, datasource alterado só nela) | nenhuma asserção, exceção nem `overflow` no console ou no log: esqueleto em 390 e 1280, erro em 390 e 1280, nova tentativa ao trocar de tema, subtema vazio em 390; depois das correções, em 600, 390, 1280 e 768 |
| Consulta somente leitura ao Firestore do dev (`runQuery` de `contents` em todas as coleções) | 190 objetos: RE 35, NMA 74, EUR 42, CP 39; os 31 subtemas iguais a `devCountsBySubtheme` |
| `grep` nos arquivos novos por `Color(0x`, `fontSize:` numérico, `EdgeInsets`/`SizedBox` com número, `Duration(`, `GestureDetector`, `num_extension` | nada |
| `grep` por `ThemeBanner`, `SubthemeGrid`, `SubthemeCard`, `subtheme_card.dart` em `lib/` e `test/` | nada (`subtheme_banner.dart` é da página do subtema, fora daqui) |
| `git diff --stat` em `lib/features/admin`, `lib/features/catalog`, `lib/core/navigation`, `lib/core/models`, `lib/core/content`, `firestore.rules`, `pubspec.yaml` | vazio |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | As 4 rotas abrem direto com cabeçalho, migalhas, descrição, contagens e medalhão; "Início" leva à Home; "Temas" é texto | passou | As 4 abertas pelo endereço (carga inteira da página). Árvore de semântica nas 4: grupo "Você está em", link "Início", texto "Temas", "{Tema}, página atual", `h1`, descrição real, "N subtemas", "N objetos digitais". Clique em "Início" → `/`. |
| 2 | Título da grade com o número certo, singular/plural | passou | `h2` "7", "12", "6" e "6 subtemas" na árvore; singular em `theme_subthemes_section_test.dart`. |
| 3 | Cartão com medalhão, nome do protótipo, "N objetos" do Firestore, link e hover | passou | Os 31 cartões das 4 rotas lidos na árvore e comparados um a um com a consulta ao Firestore, inclusive os 12 de Natureza; os 31 nomes iguais aos do protótipo. Hover em 1280: borda e nome no acento, sombra, medalhão girado. Clique em cartão e "reduzir movimento": testes `subtheme_overview_card_test.dart`. |
| 4 | Soma dos cartões = cabeçalho = Home | passou | Somas 35, 74, 42, 39 iguais ao "N objetos digitais" dos 4 cabeçalhos e aos cartões da Home na tela. |
| 5 | "Outros temas" com os 3 outros e link | passou | Na árvore das 4 rotas, sem o tema atual. Enter no chip leva à rota, com a página nova no topo; clique idem. |
| 6 | Esqueleto ao carregar; contagens somem na falha | passou | Datasource com atraso: esqueleto no cabeçalho e nos cartões, sem número na árvore (só "12 subtemas"). Com erro: "12 subtemas" sem "objetos digitais", cartões sem contagem, nomes e links mantidos. Falha na primeira consulta: ao trocar de tema pelo chip a consulta repete (2 chamadas no console) e os números aparecem. |
| 7 | Subtema sem objetos mostra "Nenhum objeto ainda" e continua clicável | passou | Datasource sem Biomas: cartão com a frase em 390, cabeçalho 67; link no teste. |
| 8 | Ilustração ausente mostra o placeholder | passou | Imagens de um tema e de um subtema retiradas da cópia servida: placeholder no medalhão do cabeçalho, no cartão e nos mini-medalhões dos chips, em 1280 (antes só por teste). |
| 9 | 2, 3 e 4 colunas, sem rolagem nem `overflow` | passou (após correção) | Na tela em 390, 768 e 1280, mais 600 e 1024; `scrollWidth` = largura em 390, 768 e 1280. Testes sem `overflow` de 320 a 1280, com texto a 100% e 200%. Em 600 havia palavras partidas (ver abaixo). |
| 10 | Teclado, foco único, contraste | passou | Tab em 1280 passa pela navbar, por "Início", pelos 12 cartões e pelos 3 chips, um ponto por item, com anel visível e a página acompanhando. Contraste calculado: inkSecondary/surface 6,45; inkSecondary/page 7,01; accent/page 4,87; ink/surface 15,71. |
| 11 | `h1`, `h2`, `h3`, "Você está em", "Temas" ativo | passou | Árvore nas 4 rotas: um `H1`, `H2` "N subtemas" e "Outros temas", `H3` dentro de cada link. "Temas" com sublinhado laranja na navbar. |
| 12 | Endereço inexistente mostra "não encontrada" | passou | `/qualquer-coisa` em 1280; `theme_page_test.dart`. |

## Pontos em aberto da implementação
- **Medalhão e migalhas no celular:** segue a spec, medalhão acima. O `.top-row{order:-2}` do protótipo só serve ao cabeçalho do subtema e está dentro de um `div`, fora da grade, sem efeito. Na aba "Tema" renderizada em 390 px, o medalhão está em y=562 e as migalhas em y=678.
- **Espaços:** árvore conferida, com os 6 cartões.
- **Natureza:** os 12 cartões conferidos. A árvore da implementação tinha 8 porque o Flutter só expõe o que está perto da janela; com a janela em 2400 px de altura saem todos.
- **Sobre:** inteira em 390, 768 e 1280, e de novo em 1280 depois das correções: igual, a descrição curta não chega à largura máxima.

## Comparação com o protótipo
A aba "Tema" foi renderizada localmente a partir do `read_artifact` e comparada lado a lado em 1280 e 390: mesma ordem, medidas e estados. Diferenças decididas na spec: colunas fixas por faixa, chips de 44 px, cabeçalho em uma coluna em 768, nome menor no tablet. O medalhão não tem o `padding` de 5 px do protótipo; vem do `AppMedallion` da Fase 0, igual ao da Home.

## Regressões
`/sobre`, Home, navbar, rodapé e página não encontrada abrem como antes. Um cartão leva à página do subtema (`/natureza-meio-ambiente/biomas`, conferido na implementação; rota inalterada).

## Problemas encontrados e correções
- **Nome do subtema partido no tablet** (ajuste). Em 600 px, "Desmatamento" e "Sustentabilidade" quebravam no meio da palavra: o cartão tem 165 px e o nome era de 18,4 px com 18 px de respiro. Corrigido na primeira tentativa: o tablet usa o nome e o respiro do celular. Conferido em 600, 768 e 1024; teste novo do tamanho por faixa.
- **Descrição do cabeçalho sem largura máxima** (detalhe). O protótipo limita o `.lead`; aqui a linha ia até o medalhão. Agora usa `readingMaxWidth` no `PageHeader`. Conferido em 1280; teste novo.

## Ressalvas
- **Nome longo parte a palavra abaixo de cerca de 346 px** (detalhe, fora das larguras exigidas). "Sustentabilidade" e "Transformação" em 320 px, e o mesmo com texto a 200% em duas colunas. O nome nunca é cortado, e o cartão cresce. Parado sem tentativa de código: qualquer saída pede uma faixa nova de largura, contra o README, ou trocar o `Text` por uma montagem palavra a palavra, e o ganho é só nessa largura.
- Fora do escopo, anteriores: a navbar transborda com texto a 200%; os títulos do rodapé são `h2`, e somam-se aos da página.

## Não conferido
- Painel admin: não muda e não há credenciais de teste.
- Texto a 200% no navegador: coberto por testes da grade, sem o cabeçalho e os chips, que quebram linha por construção.
- "Reduzir movimento" na tela: coberto por teste.
