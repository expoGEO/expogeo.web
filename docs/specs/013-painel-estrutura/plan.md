# Plano da 013. Painel: estrutura, menu e consulta de temas e subtemas

- **Spec:** spec.md
- **Criado em:** 2026-11-08

## Abordagem
A moldura vem do painel do Observatório (`lib/app/features/admin/panel/presentation/pages/panel_page.dart`, `panel_top_bar.dart`, `panel_user_badge.dart`, `panel_section_header.dart` e o menu de `lib/app/features/admin/sidebar/`), adaptada à expoGEO: um só grupo "Curadoria", sem perfis, com as contagens do catálogo único. A barra, o menu e a gaveta ficam numa **casca** (`ShellRoute` do go_router) que envolve as duas vistas, `/admin/painel/objetos` e `/admin/painel/temas`; assim trocar de vista não recria a barra nem fecha estados da moldura, e cada vista tem endereço próprio. `/admin/painel` continua existindo (é o destino do login) e redireciona para `/admin/painel/objetos`.

A vista "Objetos digitais" é a moldura em volta da área de objetos atual (seletor, "Novo Conteúdo", tabela, formulário e exclusão), extraída de `panel_page.dart` para um componente próprio sem mudar o que faz. O tema e o subtema do endereço chegam a ela por parâmetro e viram uma ação nova da `ContentStore`, que escolhe os dois e carrega a tabela. A 014 troca esse componente pela lista nova.

As contagens saem do `CatalogStore` (spec 004), que ganha `refresh()`: busca de novo e troca o catálogo só quando a busca dá certo, mantendo os números anteriores visíveis enquanto isso. A casca chama `refresh()` ao abrir e depois de cada gravação da área de objetos (a `ContentStore` passa a contar as gravações bem-sucedidas).

As três peças compartilhadas da fase nascem em `lib/core/`, portadas do Observatório: o `Messenger` vira o aviso curto em fundo escuro (anunciado por `SemanticsService.announce`), o `AppIconButton` passa a exigir dica (hover e foco do teclado) e nome acessível, e `showConfirmDialog` vira o diálogo de confirmação. `AppButton` ganha o tipo `danger` para a ação destrutiva do diálogo. Hoje as três só são usadas pelo painel, então nenhuma tela pública muda.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Tokens do painel (valores do Observatório e do protótipo): `panelTopBarHeight` 64, paddings/gaps da barra por faixa, `panelAvatar` 36, `panelSidebarWidth` 248, paddings e gaps dos itens do menu e do submenu, recuo do submenu 21, `panelCollapseWidth` 900, gaveta `panelDrawerMaxWidth` 300 / fator 0,86, `panelMainPaddingH`/`Top` por faixa, cabeçalho de vista, medalhão de subtema 48, linha de subtema (padding 14/16, gap 16); `toast*` (largura máx. 560, margem 16, paddings 12/18, ícone 18, gap 10, duração 3 s e 6 s no erro); `tooltip*` (largura máx. 260, paddings 10/7, distância 8); `confirmDialog*` (largura 420, padding 24, gaps 8/20/10) |
| Alterar | `lib/core/theme/app_colors/app_colors.dart` | `scrim` (`#1C1917` a 45%), `toastIcon` (`#9FD8AE`), `errorStrong` (`#8F1D17`, hover do botão de perigo), `rowHover` (`#FCFBF9`) |
| Alterar | `lib/core/theme/app_typography/app_text_styles.dart` | `toast` (Figtree 600, 14,5), `tooltip` (Figtree 600, 13), `panelNav` (600, 15) e `panelNavSub` (500, 14), `panelCount` (600, 12,5, algarismos tabulares), `panelGroupLabel` (700, 12, caixa alta, 0,09 em), `panelTitle` (Bricolage 800, 25,6 → 33,6), `panelBlockTitle` (Bricolage 700, 20), `panelRowTitle` (650, 16,8), `panelMeta` (13,5), `panelDialogTitle` (Bricolage 700, 20,8) |
| Alterar | `lib/core/utils/messenger/messenger.dart` | Aviso curto do Observatório: `showSuccess`/`showInfo` em `ink`, `showError` em `error` com fechar; anúncio por `SemanticsService.announce`; troca o aviso anterior |
| Alterar | `lib/core/components/button/app_icon_button.dart` | Versão do Observatório: `tooltip` obrigatório, `label`, `isDisabled`, `focusNode`, `AppFocusRing`, alvo de 44 px, dica também no foco do teclado, Esc fecha só a dica; sem `num_extension` |
| Alterar | `lib/core/components/button/app_button.dart` | `AppButtonKind.danger` (fundo `error`, hover `errorStrong`, texto branco) |
| Criar | `lib/core/components/dialog/confirm_dialog.dart` | `showConfirmDialog(context, title, message, confirmText, destructive)` → `Future<bool>`; foco inicial em "Cancelar", Esc e fora fecham, foco volta ao botão de origem (comportamento do `showDialog`), semântica de alerta |
| Alterar | `lib/features/catalog/presentation/stores/catalog_store.dart` (+ `.g.dart`) | `refresh()`: sem catálogo, igual a `ensureLoaded`; com catálogo, busca de novo e troca só no sucesso; ignora chamada com busca em andamento |
| Alterar | `lib/features/admin/panel/presentation/stores/content_store.dart` (+ `.g.dart`) | `selectFromAddress(theme, subtheme)` (escolhe os dois e carrega a tabela; sem tema, limpa a escolha e a tabela) e `@observable int savedCount`, incrementado em criar, editar e excluir bem-sucedidos |
| Criar | `lib/features/admin/panel/presentation/panel_address.dart` | `PanelView { objects, themes }`, leitura de `?tema`/`?subtema` (valores de `ThemeEnum.value`/`SubthemeEnum.value`, subtema só se for do tema, Movimentos da Terra fora) e montagem dos endereços; `initialsOf(email)` |
| Criar | `lib/features/admin/panel/presentation/components/panel_top_bar.dart` | Barra: botão da gaveta (abaixo de 900), `AppBrand(tagline: 'Painel')` (só símbolo no celular) que leva a objetos, "Ver site" (`AppButton.ghost` pequeno, ícone de abrir fora, `UrlUtils.openUrl('/')` em aba nova; fora no celular) e `PanelUserBadge` |
| Criar | `lib/features/admin/panel/presentation/components/panel_user_badge.dart` | Círculo com iniciais (`ink` sobre `surface` com borda `line`, contraste ≥ 4,5:1) e e-mail cortado com reticências (só no desktop); `Tooltip` e nome "Conectado como {e-mail}" |
| Criar | `lib/features/admin/panel/presentation/components/panel_sidebar.dart` | `Semantics` de navegação "Seções do painel"; rótulo "CURADORIA"; "Objetos digitais" + total, submenu dos 4 temas + contagens, "Temas e subtemas" + 31; "Ver site" (só na gaveta do celular) e "Sair" no pé; item atual em `accentSoft`/`accentStrong`, pai em `accentStrong`; esqueleto curto no lugar do número carregando, nada no erro; `onNavigate` para fechar a gaveta |
| Criar | `lib/features/admin/panel/presentation/components/panel_nav_item.dart` | Item do menu (`InkWell` + `AppFocusRing`, `Semantics(button, selected)`, nome com a contagem) |
| Criar | `lib/features/admin/panel/presentation/components/panel_section_header.dart` | Rótulo "CURADORIA", título (`header`) e texto de apoio opcional |
| Criar | `lib/features/admin/panel/presentation/pages/panel_shell.dart` | Casca: barra + `Scaffold` com gaveta abaixo de 900 e menu fixo acima; foco volta ao botão quando a gaveta fecha sem escolha; `CatalogStore.refresh()` ao abrir e numa `reaction` a `savedCount`; reações de sessão (sem usuário → `/admin`) e de falha do "Sair" (aviso curto) |
| Criar | `lib/features/admin/panel/presentation/pages/panel_objects_view.dart` | Cabeçalho + área de objetos; chama `selectFromAddress` ao abrir e quando tema/subtema do endereço mudam |
| Criar | `lib/features/admin/panel/presentation/components/legacy_objects_area.dart` | A área de objetos que estava em `panel_page.dart` (seletor com `key` pela escolha, "Novo Conteúdo", tabela, formulário), com a exclusão por `showConfirmDialog` (textos de hoje, `destructive`) e sem `num_extension` no que muda; avisos de erro pelo `Messenger` novo |
| Criar | `lib/features/admin/panel/presentation/pages/panel_themes_view.dart` | "Temas e subtemas": cabeçalho, um bloco por tema de `ThemeDataModel.themes` ("N subtemas · N objetos"), linhas de subtema; `StateErrorInline` com "Tentar de novo" no erro |
| Criar | `lib/features/admin/panel/presentation/components/subtheme_row.dart` | `AppMedallion` 48, nome (até 2 linhas), caminho `SubthemeEnum.route`, selo "N objetos"/"1 objeto" (esqueleto carregando, nada no erro), `AppIconButton` "Ver objetos de {subtema}" com dica "Ver os objetos deste subtema"; empilhada no celular |
| Alterar | `lib/features/admin/panel/presentation/components/content_list.dart` | `AppIconButton` com `tooltip`/`label`: "Editar a ficha deste objeto" / "Excluir: pede confirmação antes de apagar" |
| Apagar | `lib/features/admin/panel/presentation/pages/panel_page.dart` | Substituída pela casca e pelas vistas |
| Alterar | `lib/core/navigation/app_router.dart` | Constantes `adminPanelObjects` e `adminPanelThemes`; `/admin/painel` (subrota de `/admin`) só com `redirect` para objetos; `ShellRoute` com `/admin/painel/objetos` (lê `tema`/`subtema`) e `/admin/painel/temas`; `adminRedirect` cobre `/admin/painel` e tudo abaixo e manda `/admin` com sessão para objetos |
| Alterar | `README.md` | Linha "Componentes" do Design System: `showConfirmDialog`, `AppIconButton` com dica, `Messenger` como aviso curto, `AppButton.danger` |
| Criar | `test/core/components/button/app_icon_button_test.dart`, `test/core/components/dialog/confirm_dialog_test.dart`, `test/core/utils/messenger_test.dart` | Peças compartilhadas |
| Alterar | `test/core/components/button/app_button_test.dart` | `danger` |
| Alterar | `test/features/catalog/catalog_store_test.dart` | `refresh()` |
| Criar | `test/features/admin/panel/panel_address_test.dart`, `content_store_test.dart`, `panel_sidebar_test.dart`, `panel_top_bar_test.dart`, `panel_themes_view_test.dart`, `panel_shell_test.dart` | Endereços, iniciais, store, menu, barra, vista, gaveta |
| Alterar | `test/core/navigation/admin_redirect_test.dart` | Subrotas do painel e novo destino de `/admin` |
| Reusar | `test/features/catalog/catalog_test_data.dart` | Registros com contagens conhecidas para os testes do menu e da vista |

## Decisões técnicas
- **`ShellRoute` em vez de uma rota com parâmetro de vista:** mantém barra, menu e gaveta montados entre as vistas e dá endereços limpos. As rotas da casca são de nível superior (`/admin/painel/objetos`); `/admin/painel` continua subrota de `/admin` só com redirecionamento, para o destino do login (012) não mudar. Alternativa (subrotas de `/admin/painel` com builder) recriaria o login por baixo e a página a cada troca.
- **`adminRedirect`** passa a tratar `path == /admin/painel || path.startsWith('/admin/painel/')`. Sem sessão → `/admin`. `/admin` com sessão → `/admin/painel/objetos` direto (evita duas voltas). Endereço desconhecido abaixo de `/admin/painel/` com sessão cai no `errorBuilder` (404 do site).
- **Parâmetros inválidos** são ignorados na leitura (`panel_address.dart`), sem reescrever o endereço: mais simples e a spec só exige ignorar.
- **Área de objetos antiga dentro da moldura** (decisão da spec): extrair sem reescrever minimiza risco para criar/editar/excluir, que a 014 e a 015 refazem. Só muda o que a spec pede (dicas, diálogo, aviso curto) e o necessário para compilar sem `num_extension` nas linhas tocadas; o resto do arquivo antigo (formulário, tabela) fica como está.
- **`selectFromAddress`** na `ContentStore` porque `loadContentsBySubtheme` não guarda o tema e o "Novo Conteúdo" depende dos dois. O seletor recebe `key` pela escolha, porque hoje ele só copia o valor inicial quando não é nulo.
- **Contagens por `CatalogStore.refresh()`**, não por `count()` no Firestore: são as mesmas do site (critério 2) e já respeitam as regras de leitura publicadas. Manter o catálogo antigo durante a recarga evita piscar o esqueleto em toda gravação e não afeta as telas públicas, que só leem `catalog`.
- **Gatilho de recarga por `savedCount`** em vez de observar `ContentState`: o estado passa por sucesso também nas leituras, o que dispararia recargas a cada troca de tema.
- **Gaveta pelo `Scaffold.drawer`**, como no Observatório: barreira, Esc e foco na gaveta vêm do Material; o retorno do foco ao botão é feito em `onDrawerChanged`.
- **Corte de 900 px** por token próprio (`panelCollapseWidth`), igual ao `navbarCollapseWidth`, para a navbar e o painel poderem mudar separadamente. Abaixo de 600 usa a faixa `Breakpoint.mobile`.
- **Iniciais em `ink` sobre `surface` com borda**: o protótipo usa cor sólida por pessoa, mas não há nome nem foto; uma cor fixa de contraste conhecido evita escolher cores por e-mail.
- **"Ver site" por `UrlUtils.openUrl('/')`** (aba nova). Fica um botão, não `InlineLink`, por causa do problema de `linkUrl` externo com semântica ligada (lição da 010).

## Dependências e geração de código
- Nenhum pacote novo; `pubspec.lock` não deve mudar (restaurar com `git restore pubspec.lock` se o `pub get` mexer).
- `fvm dart run build_runner build --delete-conflicting-outputs` depois de mudar `CatalogStore` e `ContentStore`.
- Rotas novas no `app_router.dart` (`/admin/painel/objetos`, `/admin/painel/temas`); `/admin` e `/admin/painel` continuam.
- Nada novo nos `*_setup.dart`: `CatalogStore` já está no `GetIt` (o painel usa `GetIt.I<CatalogStore>()`); `ContentStore` e `AuthStore` como hoje.

## Riscos e cuidados
- **`AppIconButton`, `Messenger` e `AppButton` são compartilhados:** hoje os dois primeiros só aparecem no painel, mas conferir com `grep` antes de mudar a API; `AppButton` é usado em Home, Sobre, Contato, 404 e login: o tipo novo não pode mudar os existentes (testes atuais e olhar Home, Contato e login em 1280).
- **`refresh()` no catálogo compartilhado:** a Home e as páginas de tema/subtema usam `ensureLoaded`; nada muda para elas, mas o teste do `refresh` precisa cobrir "erro mantém o catálogo anterior" e "chamada durante busca é ignorada".
- **Sessão no `ShellRoute`:** o `redirect` global continua valendo para as rotas da casca; conferir `/admin/painel/temas` sem sessão em teste e no navegador.
- **Foco preso na gaveta e Esc da dica:** Esc numa dica aberta dentro da gaveta não pode fechar a gaveta (o `AppIconButton` só consome o Esc se havia dica).
- **Movimentos da Terra:** está no `SubthemeEnum`, mas não no `ThemeDataModel`; a vista e o total (31) seguem o `ThemeDataModel`, e `?subtema=movimentos-terra` é ignorado.
- **Sem credenciais:** a sessão só pode ser simulada na cópia ASCII (nunca no worktree), sem gravar no Firestore; criar/editar/excluir de verdade fica como "não conferido" ou com datasource de conteúdo falso também na cópia.
- **Rolagem horizontal:** a `DataTable` da área antiga já fica numa rolagem horizontal própria (`content_list.dart`); conferir em 390 que só ela rola de lado e a página não.

## Como conferir
- Na cópia em caminho ASCII do scratchpad (rsync sem `build/` e `.dart_tool/`, `fvm flutter pub get`): `fvm flutter analyze`, `fvm flutter test`, `fvm dart format` nos `.dart` alterados.
- `fvm flutter build web --release`, servidor Python próprio com fallback de SPA, navegador embutido em 390, 768 e 1280 px, comparando com a aba "Painel" do protótipo; ao menos uma vez `fvm flutter run -d web-server` em modo debug para ver asserções e `overflow`.
- Telas com sessão só com `AuthRepository` (e, se preciso, `ContentDatasource`) simulados na cópia ASCII; catálogo real do dev (somente leitura).
- Parar os próprios servidores por PID; voltar o navegador ao preset desktop.
