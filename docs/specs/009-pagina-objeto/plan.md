# Plano da 009. Página do objeto digital

- **Spec:** spec.md
- **Criado em:** 2026-11-05

## Abordagem
A página nova lê o objeto do catálogo único, a partir só do endereço. Não precisa de store próprio: tudo o que mostra deriva do `CatalogStore` por duas consultas puras no `CatalogModel` (achar o objeto pelo código dentro do subtema; listar os outros do subtema). O único estado de tela é o retorno de "Copiar link", local ao componente, como no `CopyButton` do Observatório.

Quatro rotas irmãs, uma por tema, entram no `AppRouter` ao lado das de subtema, seguindo o padrão já usado ali. Elas normalizam o código num `redirect` da própria rota, antes de a página existir. A página procura tema e subtema como a `SubthemePage` e devolve a `NotFoundPage` quando não acha.

As ligações saem de uma só troca, em `CatalogItem.route`. Com ela, a condição temporária da 008 perde o sentido: sai da seção do subtema, e o ramo "sem rota" sai da `ObjectRow`. A lista do subtema é conferida de novo, em teste e na tela.

O defeito do leitor do painel (`preservationOperation`) não é corrigido aqui. O catálogo lê `preservationAction` do documento e entrega ao lado do objeto.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Tokens da coluna, do topo, da nota, da ficha, da pílula, da seção e `copyFeedbackDuration` |
| Alterar | `lib/core/utils/date/date.dart` | Datas abreviadas ("12 mar 2025", "dez 2026") |
| Alterar | `lib/core/utils/string/string_utils.dart` | `referenceCodeSlug` |
| Alterar | `lib/features/catalog/infra/models/catalog_model.dart` | `route`, `slug`, `preservation`, `find`, `othersOf` |
| Criar | `lib/core/components/card/object_card_grid.dart` | Grade de cartões, hoje privada na Home |
| Alterar | `lib/features/home/components/home_recent_section.dart` | Usa a grade compartilhada |
| Criar | `lib/core/components/reading/reference_code.dart` | Pílula do código, que 014 e 015 reusam |
| Criar | `lib/features/theme/components/subject_tag.dart` | Etiqueta de assunto, hoje `_Tag` na `object_row.dart` |
| Criar | `lib/features/theme/components/object_head.dart` | Faixa de voltar e migalhas, rótulo, título, descrição, esqueleto |
| Criar | `lib/features/theme/components/object_actions.dart` | Botões, retorno de cópia, endereço visível, falha |
| Criar | `lib/features/theme/components/object_note.dart` | Nota de conteúdo |
| Criar | `lib/features/theme/components/object_sheet.dart` | Ficha da curadoria e esqueleto |
| Criar | `lib/features/theme/components/object_related_section.dart` | "Outros objetos" |
| Criar | `lib/features/theme/pages/object_page.dart` | Composição, estados, 404, reinício por objeto |
| Alterar | `lib/core/navigation/app_router.dart` | Rotas novas e redirecionamento; sai o bloco comentado |
| Alterar | `lib/features/theme/components/object_row.dart` | `detailsRoute` obrigatório, sem ramo de título-texto, usa `SubjectTag` |
| Alterar | `lib/features/theme/components/subtheme_objects_section.dart` | Sai a condição temporária; foco no título |
| Criar | `test/core/utils/date_test.dart`, `test/core/components/object_card_grid_test.dart`, `test/core/components/reference_code_test.dart`, `test/core/navigation/object_route_test.dart` | Peças e rota |
| Criar | `test/features/theme/object_head_test.dart`, `object_actions_test.dart`, `object_note_test.dart`, `object_sheet_test.dart`, `object_related_section_test.dart`, `object_page_test.dart` | Critérios cobertos em teste |
| Alterar | `test/core/utils/string_utils_test.dart`, `test/features/catalog/catalog_model_test.dart`, `test/features/catalog/catalog_test_data.dart`, `test/features/home/home_recent_section_test.dart`, `test/features/home/home_explore_section_test.dart`, `test/features/theme/object_row_test.dart`, `test/features/theme/subtheme_objects_section_test.dart` | Destinos novos e casos novos |

## Decisões técnicas
- **Rotas irmãs, não filhas.** `GoRoute(path: '/$tema/:subthemeId/:code')` no nível de cima, numa função `_objectRoute(themeId)`. Rota filha da de subtema empilharia a `SubthemePage` por baixo. `name`: `'$tema-object'`.
- **Normalização no `redirect` da rota.** Compara `pathParameters['code']` com `referenceCodeSlug` e, se diferir, devolve `state.uri.replace(pathSegments: [tema, subtema, slug])`, que cuida da codificação e mantém a query. Corre antes do catálogo e não depende dele. Alternativa de redirecionar na página, depois dos dados, faria o endereço piscar e pediria um `addPostFrameCallback`. O `redirect` global, que consulta o Firebase, não muda.
- **`referenceCodeSlug(code) => code.trim().toLowerCase().replaceAll('_', '-')`** em `string_utils.dart`, sem mexer em acentos: os códigos são ASCII.
- **`CatalogItem.route => '${subtheme.route}/$slug'`.** `slug` é getter. Nome de campo do documento não muda.
- **`CatalogItem.preservation`** (`PreservationAction?`), preenchido em `_parse` por uma função com `try/catch` própria, separada do `fromJson` do objeto. Alternativa de injetar `preservationOperation` no mapa antes do `fromJson` faria um `updateDate` ruim derrubar o objeto inteiro do site e mudar as contagens. Comentário de uma linha com o porquê. `ContentResponseModel` não muda.
- **Consultas no `CatalogModel`.** `find(SubthemeEnum, String code)` compara slugs entre os itens do subtema; se houver dois, vale o de menor código. `othersOf(CatalogItem, int count)` filtra o subtema, tira o atual por `docId`, ordena por `content.id`, corta. Puras, testadas sem widget. `count` = 3 fica em `ObjectRelatedSection`.
- **Sem store MobX na página.** `Observer` sobre `store.state`, como `HomeRecentSection`. A `SubthemeObjectsStore` existe porque há estado de busca; aqui não há. `store` opcional na página e nos componentes (sem valor, `GetIt`), como na 007, para usar o `FakeCatalogRepository`.
- **Reinício por objeto:** `ObjectPage` é `StatelessWidget`, acha tema e subtema e devolve `_ObjectView(key: ValueKey('$subthemeId/$code'))`, com o `SiteScaffold` dentro, como `_SubthemeView`. É o que zera rolagem e "Link copiado" quando o `go_router` reaproveita a página.
- **Topo fora do `PageHeader`.** Ele tem superfície, borda e medalhão, e sempre desenha `h1`, que aqui ainda não existe ao carregar. `ObjectHead` usa `Wrap` com `spaceBetween` para botão e migalhas, igual ao `topAction`, com `AppButton.ghost` pequeno, `pageHeadBackShift` e `Breadcrumbs`. Estilos `h1` e `reading`; descrição em `inkSecondary`. A largura vem de `ConstrainedBox(maxWidth: objectColumnMaxWidth)` dentro do `PageContent` (856 de conteúdo).
- **Tamanho do ícone do topo:** reaproveita `objectCardIconBox`, `objectCardIconRadius` e `objectCardIcon` (40, 11, 19), os mesmos da `.tico` do protótipo.
- **Copiar com `Clipboard.setData`, em `try/catch`.** No web, a falha chega como `PlatformException`. Estados `idle`, `copied`, `failed`, `Timer` de `copyFeedbackDuration` (1,8 s), cancelado no `dispose`. O aviso de falha fica até a próxima tentativa, porque a pessoa precisa de tempo para copiar. Anúncio com `SemanticsService.announce`, porque `sendAnnouncement`, usado no Observatório, não existe no Flutter 3.35.5 (conferido no SDK).
- **Selecionar o endereço na falha:** o endereço fica num `SelectionArea` próprio, com `GlobalKey<SelectionAreaState>` e `FocusNode`, dentro de `SelectionContainer.disabled` por causa do `SelectionArea` da página. Na falha: `focusNode.requestFocus()` e `key.currentState!.selectableRegion.selectAll()`. API pública na 3.35.5 (conferida no SDK). Alternativa de `TextField` somente leitura mudaria a leitura de tela e o visual.
- **`AppButton` sem mudança.** "Acessar" é `AppButton.primary(externalUrl: address.trim())`, que já traz seta e "abre em nova aba". Com endereço não abrível, `isDisabled: true` sem `externalUrl`. "Copiar link" é `AppButton.secondary(leadingIcon: Icons.link)`, com `text` trocado pelo estado.
- **Largura dos botões:** `Column` esticada no celular; `Wrap` com `spacing` nas outras faixas.
- **Ficha por `Row` de `Expanded`.** Divide os pares em fatias de `min(colunas, pares)`; sem `LayoutBuilder` nem `IntrinsicHeight`, alinhados no topo. Colunas: 1, 2, 3 por faixa. O título do grupo fica numa `Row` com largura fixa `objectSheetGroupTitle` (170) em tablet e desktop, e acima no celular. Assuntos em `Wrap` fora das fatias. Vazio é `trim().isEmpty`, por uma função local que devolve o par ou nada.
- **Par:** `MergeSemantics`, sem `label` manual, para ler rótulo e valor juntos e seguir selecionável. Conferir a leitura na árvore; se o `SelectionArea` separar os nós, usar `Semantics(label: 'Rótulo: valor', excludeSemantics: true)`.
- **Títulos da ficha:** `Semantics(header: true, headingLevel: 2 ou 3)`. Grupo em `small` 13 px, peso 700, maiúsculas e `accent` sobre `page` (4,87:1). Cabeçalho em `inkSecondary` sobre `surface`.
- **Datas sem `toLocal()`.** `DateTime.parse('2026-12-01')` já é local, e com `Z` fica em UTC. Em ambos os casos os campos saem como gravados. Novas extensões `shortDate` e `monthYear`, com meses `jan`…`dez`.
- **`ObjectCardGrid`** é o `_Grid` da Home movido sem mudança de comportamento (colunas por faixa, `IntrinsicHeight`). Com menos itens que colunas, as vagas ficam em branco, como `auto-fill`.
- **`ReferenceCode`:** `styles.code`, fundo `page`, borda `line`, raio `r6`, padding 8/2. Vale para os dois lugares da ficha. `reference_code_example.dart` da 006 tem outro desenho e não muda.
- **`SubjectTag`** é o `_Tag` movido, para a ficha e a linha serem iguais.
- **`detailsRoute` obrigatório na `ObjectRow`,** com o ramo de título-texto removido. Depois desta entrega ninguém passa nulo, e deixá-lo seria código morto. O foco de "Carregar mais" passa sempre ao título; `primaryFocusNode` segue, só sem o fallback do "Acessar". Hover em `accentStrong` fica como está.
- **"Ver todos":** `AppButton.ghost` pequeno, seta à direita e `semanticLabel`, que já usa `accentStrong`.
- **Seção "Outros objetos":** `ColoredBox(surface)` em largura total, com `PageContent` e padding vertical `objectRelatedPadding` (48). Cabeçalho em `Wrap` com `spaceBetween` e `crossAxisAlignment: end`. `Observer` não é preciso: a página só a monta com o objeto achado.
- **`SelectionContainer.disabled` nos clicáveis novos,** como no cartão. `AppButton` já faz.

## Dependências e geração de código
- Nenhum pacote novo. Se o `pub get` mexer no `pubspec.lock`, não incluir em commit.
- Sem `build_runner`: nenhum store nem modelo gerado muda.
- Rotas: quatro `GoRoute` novas, uma por tema, formando `/:tema/:subtema/:codigo`. Nenhuma existente muda. Sai o bloco comentado "Rotas de conteúdo".
- Sem assets e sem `*_setup.dart` novos.

## Riscos e cuidados
- **Preservação na produção:** o leitor no catálogo foi visto só com dados do dev. Sem o campo lá, os dois itens somem sem erro. A ressalva vale até o painel corrigir o leitor (014, 015). Hoje o formulário de edição do painel abre com a preservação em branco; o `update` não apaga o campo porque a chave fica de fora do JSON, mas quem preencher ali sobrescreve. Nenhuma mudança aqui.
- **Lista do subtema muda de aparência:** "Ver ficha" e título-link aparecem pela primeira vez com dados reais. Em desktop as ações ocupam mais largura; dentro do `IntrinsicHeight` da linha, olhar em debug. Testes da seção e da linha mudam: hoje afirmam que não há "Ver ficha" e que o foco vai ao "Acessar". Conferir 390, 768 e 1280 e `Carregar mais` em Sustentabilidade.
- **Histórico no redirecionamento:** abrir `…/NMA_BH_03` e usar o voltar não pode cair num laço. Olhar na tela (E2): em `go_router` o `redirect` não deve deixar entrada própria.
- **Endereço de 3 segmentos no servidor:** o `.htaccess` do dev fica só no servidor e o da produção não está no repositório. Links de 2 segmentos já funcionam, mas a reescrita para 3 só se confere depois do deploy em `dev.expogeo.com.br`. Registrar na verificação como não conferido; o servidor local do Python usa fallback próprio.
- **Área de transferência no navegador embutido:** pode negar a permissão. A falha é coberta por teste e, se precisar, por um `Clipboard` forçado a falhar só na cópia ASCII.
- **`SelectionArea` aninhado:** assegurar que o texto do endereço segue selecionável e sem exceção em debug. Se falhar na cópia ASCII, voltar ao `SelectableText` e registrar.
- **Dados que o dev não mostra:** ano de emissão, regras vazias, objeto sem nota, sem colaborador, tipos Imagem e Outro, endereço inválido e subtema de 1 objeto só por teste ou datasource alterado na cópia (nunca commitado).
- **`ObjectCardGrid` e `SubjectTag` são movidos:** conferir Home e subtema. Os testes existentes devem passar sem mudança, fora os de destino.
- **Testes do `AppRouter`:** `AppRouter.router` consulta o Firebase no `redirect` global. Usar só a rota, como `about_route_test.dart`, com um `CatalogStore` falso no `GetIt`.
- **Offline demora até 15 s** (`CatalogDatasource.timeout`) e, com o catálogo já carregado, cortar a rede não dá erro: testar abrindo direto, com datasource com falha na cópia.
- **Texto a 200%:** a navbar já transborda (pendência anterior). Conferir só a ficha e os botões, por teste.
- **Caminho com "ó":** `analyze` e `test` na cópia ASCII. `pubspec.lock` tem alteração solta da pessoa.
- **Painel admin:** não muda; sem credenciais, fica "não conferido".

## Como conferir
- `fvm flutter analyze` e `fvm flutter test` na cópia ASCII; `fvm dart format` nos `.dart` alterados.
- `git diff --stat` sem `lib/features/admin/`, `lib/core/models/`, `lib/core/content/`, `firestore.rules`, `pubspec.*`.
- `grep` por `Color(0x`, `fontSize:` numérico, `EdgeInsets` e `SizedBox` com número, `.scale`, `Duration(`, `GestureDetector`, `num_extension` nos arquivos novos.
- `fvm flutter build web --release`, servidor Python próprio com fallback para `index.html`, navegador embutido em 390, 768 e 1280 px; uma vez em debug. Detalhe na tarefa E2.
