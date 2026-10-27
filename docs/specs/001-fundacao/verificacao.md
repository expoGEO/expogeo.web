# Verificação da 001. Fundação visual (tokens, fontes e breakpoints)

- **Data:** 2026-10-27
- **Resultado:** aprovada

Verificação feita em modo autônomo, sobre os commits `c708384`, `10fa5f4` e `052fa83`, com leitura do código (não só do `tasks.md`). `analyze`, `test` e os builds rodaram numa cópia do projeto em caminho ASCII (o "ó" do caminho original quebra o `analyze`).

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` | No issues found! (antes e depois da correção) |
| `fvm flutter test` | 14 testes passando (`test/core/utils/screen/breakpoint_test.dart`) |
| `fvm dart format --output=none --set-exit-if-changed` nos 9 `.dart` da entrega | 0 arquivos alterados |
| `fvm flutter build web --release -t lib/dev/foundation_preview_main.dart` | concluído |
| `fvm flutter build web --release` (app normal) | concluído |
| `fvm flutter run -d web-server` (tela de teste em debug) | abriu em 390, 768 e 1280 px; nenhuma exceção, asserção ou overflow no log nem no console |
| `cmp` das 18 capturas antes/depois (Home, tema, subtema, Contato, 404 e login em 390/768/1280) | 18 de 18 idênticas byte a byte |
| `cmp` dos 7 `.ttf` com os de `../observatorio_geo_hist/assets/fonts/` | 7 de 7 idênticos |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | O app compila; `analyze` sem avisos novos | passou | builds release do app e da tela de teste concluídos; `analyze` sem avisos |
| 2 | Telas atuais e painel idênticos | passou (painel na tela: não conferido) | `git diff 0d716ce..HEAD -- lib` só tem linhas acrescentadas (264+, 0−) e nenhum arquivo de tela, navbar, rodapé ou painel; 18 capturas antes/depois idênticas byte a byte; Home aberta de novo no build atual com a Aleo de sempre. A rota `/admin` sem login (tela de entrada) está entre as capturas; o painel logado não foi aberto (sem credenciais de teste) |
| 3 | Cores da tabela e degradê no tema | passou | `app_colors.dart` linhas 45–67: as 16 cores com os hex da spec; `app_gradients.dart`: `brand` `#F97316 → #FB923C → #FACC15`, paradas 0/0,45/1, igual ao `--geo-grad` do protótipo (`linear-gradient(120deg,#f97316,#fb923c 45%,#facc15)`); amostras conferidas na tela de teste |
| 4 | Espaçamentos, raios, sombras e foco no tema; sem valor solto | passou | `app_dimensions.dart`: `SpacingScale` 4–96, `RadiiScale` 6–20 e `pill`, `ShadowStyle.soft/elevated` (mesmos valores do Observatório), `FocusStyle` 3 px / 2 px / `accent`; `PageContent` e `contentMargin` usam só tokens |
| 5 | Fontes em `assets/fonts/`, no `pubspec.yaml`, com licença, sem Google Fonts | passou | 7 `.ttf` + `licenses/OFL-*.txt`; famílias `BricolageGrotesque` e `Figtree` no `pubspec.yaml`; rede da tela de teste: os `.ttf` vêm de `assets/assets/fonts/`, nenhuma requisição a `fonts.googleapis.com` nem `fonts.gstatic.com` |
| 6 | Estilos novos sem `google_fonts` nem `num_extension` | passou | `grep` em `app_text_styles.dart` e `page_content.dart` sem `google_fonts`, `GoogleFonts`, `num_extension` ou `.fontSize(` |
| 7 | Tela de teste mostra cada estilo em 390/768/1280 com os tamanhos da tabela | passou | 390: h1 32, h2 26, h3 18, reading 17, regular 16, small 14, label 12,5; 768: 40/30/20/18/16/14/12,5; 1280: 52/36/20/18/16/14/13; `code` 13,5 (Figtree 600, tabular) em todas |
| 8 | Faixas certas em 390, 599, 600, 768, 1023, 1024, 1280 | passou | teste unitário (7 casos de `Breakpoint.fromWidth` e 7 das funções antigas com `MediaQuery` simulado); rodapé da tela de teste: 390 mobile, 768 tablet, 1280 desktop |
| 9 | Conteúdo novo em 1120 px com margens 20/32 | passou | `ScreenUtils.contentMaxWidth = 1120`; tela de teste: 390 "margem 20 px · caixa 390 px", 768 "margem 32 px", 1280 "margem 32 px · caixa 1120 px", caixa centrada; sem rolagem horizontal |
| 10 | Contraste ≥ 4,5:1 anotado | passou | tabela abaixo, recalculada por script (WCAG 2.1) |

### Contraste (WCAG 2.1)
| Par | Razão |
|---|---|
| `ink` #1F1B18 sobre branco | 17,10:1 |
| `inkSecondary` #5E5852 sobre branco | 7,01:1 |
| `accent` #C94400 sobre branco | 4,87:1 |
| `inkSecondary` sobre `surface` #F7F5F2 | 6,45:1 |
| `footerText` #D8D2CA sobre `footerBackground` #1C1917 | 11,65:1 |
| `footerHighlight` #FF9A62 sobre `footerBackground` | 8,37:1 |
| `error` #B3261E sobre branco | 6,54:1 |
| `success` #1C6B34 sobre `successSurface` #E4F3E8 | 5,71:1 |
| `accentStrong` #A33600 sobre `surface` | 6,26:1 |
| `accentStrong` sobre `accentSoft` #FFF0E6 | 6,11:1 |
| (referência) `accent` sobre `surface` | 4,48:1, abaixo; por isso a regra do acento forte |

O protótipo anota "5,0:1" para o acento e "6,9:1" para o texto secundário; os valores calculados acima (4,87 e 7,01) são os corretos e os dois passam.

## Problemas encontrados
- Comentário do `AppGradients.brand` citava o CSS do protótipo para explicar o ângulo, contra as regras de comentário. Detalhe. **Corrigido** (`d707181`), `analyze` limpo depois.

## Observações (sem correção, fora do escopo)
- A página Contato e a 404 abrem cinza a 1280 px por um `GoError` anterior à fase; as capturas antes/depois são idênticas, então não é regressão. Fica para a spec da Contato.
- As 7 fontes novas (cerca de 420 KB) são baixadas na abertura mesmo pelas telas antigas; risco aceito no plano até a limpeza da Aleo.

## Não conferido
- Painel admin logado: sem credenciais de teste. Garantia estrutural: nenhum arquivo do painel mudou e nenhum token antigo foi alterado.

## Tela de teste
`lib/dev/foundation_preview_main.dart` (fora do git) foi apagada ao fim desta verificação, conforme o plano.
