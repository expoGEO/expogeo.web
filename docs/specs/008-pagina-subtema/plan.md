# Plano da 008. Página do subtema

- **Spec:** spec.md
- **Criado em:** 2026-11-04

## Abordagem
A `SubthemePage` deixa de consultar o Firestore e passa a ler o catálogo único, como a Home e o tema. Ela é remontada com o `PageHeader` da 007 (mais um espaço para a faixa do botão de voltar), e a parte de busca, chips, assuntos e lista vira uma seção alimentada por um store MobX próprio da página, que guarda só o estado da tela (texto, tipo, quantidade mostrada) e calcula o resto a partir do `CatalogStore`.

Toda a regra (busca sem acento, chips, assuntos, "Carregar mais") fica nesse store, testável sem widget. Os widgets só desenham. O filtro roda a cada tecla porque cada subtema tem no máximo 10 objetos.

O defeito de `/representacoes-espaciais/movimentos-terra` sai junto: a página procura o subtema na lista do tema e, sem achar, devolve a `NotFoundPage`, sem `orElse` e sem mexer no `AppRouter`.

Campo de busca, chip de filtro, caixa de estado e `foldForSearch` vêm do Observatório, adaptados aos tokens daqui. A pilha de paginação sai, porque nada mais a usa.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Tokens de busca, chips, assuntos, linha, caixa de estado |
| Alterar | `lib/core/theme/app_colors/app_colors.dart` | `stateBoxBorder` (#D4CDC3, tracejado do protótipo) |
| Alterar | `lib/core/theme/app_typography/app_text_styles.dart` | Estilo `chip` (Figtree 600, 14 px), como o do Observatório |
| Alterar | `lib/core/utils/string/string_utils.dart` | `foldForSearch` (minúsculas, sem acento, sem espaços nas pontas) |
| Alterar | `lib/core/utils/url/url_utils.dart` | Domínio para exibir e endereço abrível |
| Alterar | `lib/core/components/button/app_button.dart` | `semanticLabel` opcional, para "Voltar para {Tema}" |
| Alterar | `lib/core/components/reading/page_header.dart` | `topAction` opcional, ao lado das migalhas |
| Criar | `lib/core/components/field/app_search_field.dart` | Campo do Observatório, sem espera ao digitar |
| Criar | `lib/core/components/chip/filter_chip_button.dart` | Chip do Observatório, com a unidade da contagem como parâmetro |
| Criar | `lib/core/components/state/state_message_box.dart` | Caixa de estado com tracejado, base para a 011 |
| Criar | `lib/features/theme/presentation/stores/subtheme_objects_store.dart` (+ `.g.dart`) | Estado e regras da lista |
| Criar | `lib/features/theme/components/subtheme_lead.dart` | Frase do cabeçalho, com esqueleto e omissão |
| Criar | `lib/features/theme/components/subtheme_toolbar.dart` | Busca e chips por faixa |
| Criar | `lib/features/theme/components/subtheme_subjects.dart` | "Assuntos frequentes" |
| Criar | `lib/features/theme/components/object_row.dart` | Linha do objeto e seu esqueleto |
| Criar | `lib/features/theme/components/subtheme_objects_section.dart` | Estados, contagem, lista e "Carregar mais" |
| Alterar | `lib/features/theme/pages/subtheme_page.dart` | Nova composição, 404, reinício por subtema; mantém o construtor usado pelo `AppRouter` |
| Alterar | `lib/main.dart` | Sai o `ThemeSetup.setup()` |
| Apagar | `lib/features/theme/components/subtheme_banner.dart`, `content_grid.dart`, `content_card.dart`, `subtheme_error.dart`, `subtheme_content.dart` | Sem uso depois da troca |
| Apagar | `lib/features/theme/theme_setup.dart`, `lib/features/theme/presentation/stores/content_pagination_store.dart` (+ `.g.dart`), `content_pagination_state.dart`, `lib/features/theme/infra/` inteira | Paginação por cursor, só esta tela a usava |
| Criar | `test/core/utils/string_utils_test.dart`, `test/core/utils/url_utils_test.dart`, `test/core/components/app_search_field_test.dart`, `filter_chip_button_test.dart`, `state_message_box_test.dart` | Peças compartilhadas |
| Alterar | `test/core/components/page_header_test.dart`, `test/core/components/button/` | `topAction` e `semanticLabel` |
| Criar | `test/features/theme/subtheme_objects_store_test.dart`, `subtheme_lead_test.dart`, `subtheme_toolbar_test.dart`, `subtheme_subjects_test.dart`, `object_row_test.dart`, `subtheme_objects_section_test.dart`, `subtheme_page_test.dart` | Critérios cobertos em teste |

## Decisões técnicas
- **Store por página, não singleton.** `SubthemeObjectsStore(subtheme, catalogStore)` é criado pela página e morre com ela: é o que zera busca e tipo. Observáveis: `query`, `type` (`ContentType?`), `shown`. Computados: `items` (do catálogo, só do subtema, por `content.id`), `matches`, `typeCounts`, `visible`, `frequentSubjects`, `summary`. Ações: `setQuery`, `selectType`, `applySubject`, `clearSearch`, `reset`, `loadMore`. Alternativa `setState` na página foi descartada pelo fluxo do README (Widget → Store) e porque a regra ficaria sem teste isolado.
- **Filtro fora do `CatalogModel`.** O store usa `catalog.items.where(...)`. Assim nenhum arquivo de `features/catalog` muda nesta entrega, e a contagem vem de `items.length`.
- **Ordem dos chips em lista explícita** (`site, video, documento, aplicativo, imagem, outro`): a do enum `ContentType` tem Imagem antes de Documento.
- **Tipo que some volta a nulo em `setQuery`**, e não num computado: precisa ficar zerado mesmo se a busca voltar, como no protótipo.
- **Texto de busca indexado uma vez.** Computado com título, descrição, criador, colaborador, nota e assuntos por `foldForSearch`; palavras saem de `split(RegExp(r'\s+'))`. `foldForSearch` compara caractere a caractere, como no Observatório. Sem pacote de acentos.
- **Empate de assuntos:** `compareTo` sobre `foldForSearch`, para "Água" não ir para depois do "z".
- **Regra da ficha na página, não na linha.** `ObjectRow` recebe `detailsRoute` (`String?`) e desenha link e "Ver ficha" só com valor. A seção passa `item.route == subtheme.route ? null : item.route`. Na 009, `CatalogItem.route` muda e a condição pode sair sem tocar na linha. Teste da linha com rota; teste da seção com o nulo de hoje.
- **Título como link:** padrão do `ObjectCard`, com `Semantics(link, label, onTap, focusable, container, explicitChildNodes)` por fora, `InkWell` em `ExcludeSemantics` e o `h3` como nó de dentro, para manter o ponto de foco único. Sem rota, só o `Semantics` de `h3`.
- **`IntrinsicHeight` na linha do desktop:** ícone no topo, texto em `Expanded`, ações centralizadas (`align-self:center` do protótipo) pedem `Row` esticada. Nada de `LayoutBuilder` dentro. São no máximo 10 linhas por subtema, então a medição a mais não pesa.
- **Fundo de hover mais largo que a linha:** `Stack` com `clipBehavior: Clip.none` e fundo em `Positioned(left: -bleed, right: -bleed)`, no lugar do `margin-inline:-16px`. O `PageContent` já reserva esse espaço nas três larguras: conferir em 390.
- **Rótulo e título em `accentStrong` com a linha em hover.** `accent` sobre `surface` dá 4,48:1 (calculado), abaixo da regra. O `AppButton.ghost` já usa `accentStrong`. O protótipo não trata isso.
- **Domínio em `UrlUtils.displayDomain`**, com `Uri.tryParse`, esquema `http`/`https` e host não vazio; sem `www.`; senão devolve o texto. `UrlUtils.isOpenable` controla "Acessar". O `Uri.parse` do `openUrl` lança com endereço inválido, por isso a checagem antes.
- **`AppButton.secondary(externalUrl:)`** para "Acessar": já é link, com "abre em nova aba" e seta.
- **Faixa do cabeçalho:** `topAction` num `Wrap(alignment: spaceBetween, crossAxisAlignment: center)` dentro do `Column` esticado; sem o parâmetro, a árvore é a de hoje. Migalhas ficam `Flexible` só no sentido do `Wrap`: as que não couberem descem de linha.
- **Frase por `details`, não por `lead`:** `lead` é `String` e a frase depende do catálogo. `SubthemeLead` usa o mesmo estilo e a mesma largura de leitura. Esqueleto com a altura da linha, para o cabeçalho não pular. Em erro ou com 0 devolve `SizedBox.shrink`.
- **Reinício por subtema:** a página pública é `StatelessWidget`, acha o subtema e devolve `_SubthemeView(key: ValueKey(subtheme.type))`, que inclui o `SiteScaffold`. Assim store, controlador do campo e rolagem recomeçam mesmo se o `go_router` reaproveitar a página (rotas `/:subthemeId` iguais). Coberto por teste com `router.go`.
- **`TextEditingController` na `_SubthemeView`**, sincronizado à mão em `applySubject`, `clearSearch` e `reset`; o campo avisa o store em `onChanged`.
- **Foco do "Carregar mais":** a seção guarda um `FocusNode` para o primeiro novo, entrega ao título (com rota) ou ao "Acessar" (sem rota), e chama `requestFocus` no `addPostFrameCallback`. O botão fica onde a linha nova nasce, então ela já está à vista; conferir na tela, e usar `Scrollable.ensureVisible` se não estiver.
- **Contagem em `Semantics(liveRegion: true)`,** com o texto como `label`, para mudar junto da lista.
- **Chips em `Semantics(button, toggled, label)`** como no Observatório, dentro de um nó "Filtrar por tipo", como as migalhas fazem com "Você está em". Sem medição de largura: no desktop, busca em `Flexible` até 520 e `Wrap` à direita; se não couber, os chips quebram dentro da própria coluna.
- **`StateMessageBox` com `CustomPainter` para o tracejado:** o `Border` do Flutter não desenha tracejado. Variantes neutra e erro, `action` opcional. O anúncio da caixa como região de status fica para a 011.
- **`store` opcional** na página e nos componentes (sem valor, `GetIt`), como na 007, para os testes usarem o `FakeCatalogRepository`.
- **`SelectionContainer.disabled` nos clicáveis novos,** como no cartão: a página está sob `SelectionArea`.

## Dependências e geração de código
- Nenhum pacote novo. `flutter_staggered_grid_view` fica sem uso e sai na 016. Se o `pub get` mexer no `pubspec.lock`, não incluir em commit.
- `build_runner` na cópia ASCII depois de criar o store; trazer de volta só `subtheme_objects_store.g.dart`.
- Rotas: nenhuma; `app_router.dart` não muda. Assets: nenhum novo. Setup: sai o `ThemeSetup`; `FirebaseFirestore` segue registrado por `CatalogSetup` e `PanelSetup`, que já se protegem.

## Riscos e cuidados
- **Ano de emissão:** nenhum dos 190 objetos do dev tem `issueYear`, mas os arquivos de seed têm. Na tela do dev o ano não aparece; conferir por teste. A produção não foi consultada: se lá faltar também, ninguém verá o ano até a curadoria regravar os dados. Registrar na verificação.
- **Hoje só existem 4 tipos** no dev e nenhum subtema com mais de 10 objetos. Imagem, Outro e listas longas só por teste. Apenas Sustentabilidade (10) e subtemas de 7 a 9 mostram "Carregar mais".
- **"Ver ficha" não aparece na tela até a 009.** O critério é conferido por teste. A verificação da 009 precisa olhar de novo esta lista.
- **Catálogo carrega uma vez por visita:** quem edita no painel e volta ao subtema na mesma visita vê a lista antiga até recarregar. A paginação antiga buscava de novo. Efeito só para a curadoria; aceito pela Q-04.
- **Erro offline demora até 15 s** (`CatalogDatasource.timeout`), com o esqueleto na tela. E, com o catálogo já carregado, cortar a rede não dá erro: testar abrindo direto o endereço. Se a leitura ficar instável, usar datasource alterado só na cópia.
- **`PageHeader` e `AppButton` são compartilhados:** conferir `/sobre`, o tema e a Home; testes existentes seguem passando.
- **`IntrinsicHeight`:** asserções só aparecem em debug. Rodar uma vez com `flutter run -d web-server`, com o campo com foco, chips e "Carregar mais".
- **Remoção do `ThemeSetup`:** conferir por `grep` que nada mais lê `ContentThemeDatasource`, e abrir o painel não é possível sem credenciais. Nenhum arquivo do painel muda; ele tem `ContentDatasource` próprio.
- **Busca perdida ao voltar da ficha** quando a 009 chegar: esperado, guardar no endereço está fora do escopo.
- **Texto a 200%:** a navbar já transborda (pendência anterior). Conferir só faixa do cabeçalho, chips e linha.
- **Caminho com "ó":** `analyze`, `test` e `build_runner` na cópia ASCII. `pubspec.lock` tem alteração solta da pessoa.
- **Painel admin:** não muda; sem credenciais, fica "não conferido".

## Como conferir
- `fvm flutter analyze` e `fvm flutter test` na cópia ASCII; `fvm dart format` nos `.dart` alterados, fora os `.g.dart`.
- `git diff --stat` sem `lib/features/admin/`, `lib/features/catalog/`, `app_router.dart`, `lib/core/models/`, `lib/core/content/`, `firestore.rules`, `pubspec.*`.
- `grep` por `Color(0x`, `fontSize:` numérico, `EdgeInsets` e `SizedBox` com número, `.scale`, `GestureDetector` nos arquivos novos; por `ContentPaginationStore`, `ThemeSetup`, `ContentThemeDatasource`, `ContentCard`, `ContentGrid`, `SubthemeBanner`, `SubthemeError`, `SubthemeContent` em `lib/` e `test/`.
- `fvm flutter build web --release`, servidor Python próprio com fallback para `index.html`, navegador embutido em 390, 768 e 1280 px; uma vez em debug. Detalhe na tarefa E2.
