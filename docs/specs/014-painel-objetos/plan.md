# Plano da 014. Painel: lista de objetos, filtros e exclusão

- **Spec:** spec.md
- **Criado em:** 2026-11-09

## Abordagem
A lista sai do **catálogo único** (`CatalogStore`, spec 004), o mesmo das contagens do menu, que a casca da 013 já recarrega ao abrir o painel e a cada gravação. Uma store nova da vista, `PanelObjectsStore` (MobX, no molde da `SubthemeObjectsStore` da 008), guarda os filtros (tema, subtema, tipo, busca), o quanto está à mostra e os objetos excluídos ainda não refletidos no catálogo, e calcula resultados, resumo e rodapé. O **endereço é a fonte da verdade** dos filtros: a vista lê `?tema&subtema&tipo&q` (via `PanelSelection`) e repassa à store; mudar um filtro na tela monta o endereço novo e navega (a busca com `Router.neglect`, para não criar uma entrada de histórico por letra). Assim recarregar, o menu e "Ver objetos" funcionam pelo mesmo caminho.

A tela é montada com peças portadas da lista do painel do Observatório (`list/panel_filter_bar.dart`, `panel_list_row.dart`, `panel_list_footer.dart`, `panel_list_skeleton.dart`) e do select de filtros da biblioteca (`library_filter_select.dart`), com os tokens da expoGEO e o que a 013 já trouxe (`PanelSectionHeader`, `AppIconButton` com dica, `showConfirmDialog`, `Messenger`, `AppMedallion`, `AppSearchField`, `StateMessageBox`, `AppSkeleton`). O código de referência reaproveita o estilo `code` (Figtree 600, algarismos tabulares) em pílula, como o `ReferenceCode` da página do objeto.

Criar e editar continuam no `ContentFormDialog`, sem mudar o diálogo (decisão da spec). A `ContentStore` perde a parte de listar (seletor, tabela) e fica só com gravar e excluir, recebendo o subtema do próprio objeto, e passa a publicar o **resultado** de cada operação, que a vista transforma nos avisos curtos da spec. A área antiga (seletor, tabela, estados antigos) é apagada.

Na leitura dos dados, duas correções pequenas que não mudam o que é gravado: `ContentResponseModel.fromJson` passa a ler a preservação da chave `preservationAction` (tolerando valor malformado), e `ContentType.fromString`/`ContentFormat.fromString` aceitam o nome ou o rótulo. O catálogo deixa de ler a preservação à parte.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/models/content_model.dart` | `ContentType.fromString` e `ContentFormat.fromString`: procuram pelo `name` e, sem achar, pelo `value` (rótulo); só então `outro`. Nada muda em `toJson` |
| Alterar | `lib/features/admin/panel/infra/models/content_response_model.dart` | Preservação lida de `json['preservationAction']`, com `try` que devolve `null` se o valor não for um mapa válido (um valor ruim não derruba o objeto) |
| Alterar | `lib/features/catalog/infra/models/catalog_model.dart` | `CatalogItem.preservation` passa a vir de `content.preservationAction`; sai `_preservationOf` e o comentário sobre a outra chave |
| Alterar | `lib/core/models/content_type_display.dart` | `contentTypeOrder` (Site, Vídeo, Documento, Aplicativo, Imagem, Outro), hoje privado em `subtheme_objects_store.dart`, para o filtro do painel e o site usarem a mesma ordem |
| Alterar | `lib/features/theme/presentation/stores/subtheme_objects_store.dart` | Usa `contentTypeOrder` (sem mudança de comportamento) |
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Tokens da lista (valores do protótipo/Observatório): `panelFilterPadding` 12, `panelFilterGap` 10, `panelFilterRadius` 14, `panelFilterMarginBottom` 16, `panelFilterSearchMinWidth` 220, `panelFilterHeight` 42, `filterSelect*` (padding 14/38, ícone 16, deslocamento do menu 6, largura mínima), `panelObjectMedallion` 48, `panelTypeBadgePadding` 3/10, `panelTypeBadgeIcon` 14, `panelTypeBadgeGap` 5, `panelCodePadding` 2/8, `panelRowActionsGap` 2, `panelRowDash` 4 / `panelRowDashGap` 4, `panelRowActionsTop` 6, `panelListFootPaddingV` 10 / `H` 16, `panelListFootMinHeight` 52, `panelSkeletonRows` 4, `panelSkeletonLine1Factor` 0,6 / `Line2Factor` 0,4, `panelSkeletonLineHeights` 16/12, `panelObjectsPageSize` 12, `panelHeadButtonGap` 16 |
| Alterar | `lib/core/theme/app_typography/app_text_styles.dart` | `filterSelect` (Figtree 600, 14,5), `panelSummary` (14,5), `panelListFoot` (14) se os estilos existentes (`panelMeta`, `panelBadge`) não servirem; `code` já existe |
| Criar | `lib/core/components/field/app_filter_select.dart` | Porte do `LibraryFilterSelect` do Observatório (`MenuAnchor`, opções com rótulo, nome acessível, `AppFocusRing`, desativado lido como indisponível, altura por token, `expand` para ocupar a coluna) |
| Criar | `lib/features/admin/panel/presentation/components/panel_filter_bar.dart` | Faixa de filtros: desktop numa linha (busca expande); 768 busca numa linha e 3 selects na de baixo; 390 busca e grade de 2 colunas (Tema, Subtema / Tipo). Recebe a busca e os selects prontos |
| Criar | `lib/features/admin/panel/presentation/components/panel_object_row.dart` | Linha/cartão do objeto (porte do `PanelListRow`): medalhão do subtema, título (até 2 linhas, link para editar, `InkWell` + foco), detalhes (pílula do código · subtema · criador · "inserido em {shortDate}", em `Wrap`), selo do tipo (`cardIcon` + `value`), ações `AppIconButton` (abrir recurso, desativado com dica se `!UrlUtils.isOpenable`; editar; excluir em `error`), nomes com o título; `Semantics(container, label: título)`; hover `rowHover`; no celular, ações numa faixa com linha tracejada |
| Criar | `lib/features/admin/panel/presentation/components/panel_objects_list.dart` | Bloco com borda: linhas, rodapé "Mostrando X de Y" + "Mostrar mais" (`AppButton.ghost` pequeno), esqueleto de 4 linhas (círculo + duas linhas) |
| Criar | `lib/features/admin/panel/presentation/stores/panel_objects_store.dart` (+ `.g.dart`) | Filtros observáveis, `applySelection(PanelSelection)` (zera `shown` quando muda filtro), índice de busca com `foldForSearch(id + slug + título + criador + assuntos)`, `results` ordenados (data desc, código asc), `visible`, `hasMore`, `showMore()`, `summary` ("N objetos" + " com os filtros atuais"), `hide(docId)` e limpeza dos escondidos quando o catálogo troca; estados derivados do `CatalogStore` (carregando sem catálogo, erro, vazio total, vazio com filtros) |
| Alterar | `lib/features/admin/panel/presentation/panel_address.dart` | `PanelSelection` ganha `type` (`ContentType` pelo `name`, desconhecido ignorado) e `query` (texto aparado, vazio vira nulo); `==`/`hashCode`; `PanelAddress.objectsOf(theme, subtheme, type, query)` monta `tema`, `subtema`, `tipo`, `q` na ordem |
| Alterar | `lib/features/admin/panel/presentation/stores/content_store.dart` (+ `.g.dart`) | Sai `contents`, `selectedTheme/Subtheme`, `loadContentsBy*`, `loadAllContents`, `selectFromAddress`, `reset` e o recarregar depois de gravar. Ficam `createContent`/`updateContent`/`deleteContent` com subtema explícito, `savedCount`, `isBusy` e `@observable ContentOutcome? outcome` (`created`, `updated`, `deleted(docId)`, `saveFailed`, `deleteFailed`) |
| Alterar | `lib/features/admin/panel/presentation/pages/panel_objects_view.dart` | A vista nova: `PanelSectionHeader` (título do tema, resumo anunciado, "Novo objeto"), `PanelFilterBar` ligada ao endereço, `PanelObjectsList` e estados (`StateMessageBox` vazio/sem objetos, erro com "Tentar de novo" → `CatalogStore.ensureLoaded`); diálogo de cadastro/edição; exclusão com `showConfirmDialog` e textos novos; `reaction` ao `outcome` → `Messenger` + foco; foco no primeiro item novo depois de "Mostrar mais" |
| Alterar | `lib/features/admin/panel/presentation/components/panel_section_header.dart` | Parâmetros `summary` como região anunciada e `action` (botão à direita / em largura total no celular); `focusTitleOnChange` para não roubar o foco do filtro de tema quando o título muda por ele |
| Alterar | `lib/features/admin/panel/presentation/pages/panel_shell.dart` | `_navigate` para o mesmo endereço não chama mais `selectFromAddress` (removido); continua o `refresh` por `savedCount` |
| Alterar | `lib/features/admin/panel/presentation/components/content_form_dialog.dart` | Só o necessário para compilar com a `ContentStore` nova (as chamadas já passam o subtema); visual e campos intactos |
| Apagar | `lib/features/admin/panel/presentation/components/legacy_objects_area.dart`, `content_list.dart`, `theme_subtheme_selector.dart`, `content_empty.dart`, `content_error.dart` | Área antiga substituída |
| Alterar | `README.md` | Linha "Componentes" do Design System: `AppFilterSelect` |
| Alterar | `test/features/catalog/catalog_model_test.dart`, `test/features/catalog/catalog_test_data.dart` | Preservação pela chave certa; valor malformado mantém o objeto |
| Criar | `test/core/models/content_model_test.dart` (ou alterar o existente em `test/core/models/`) | Tipo/formato por nome e por rótulo |
| Criar | `test/features/admin/panel/content_response_model_test.dart` | Preservação de `preservationAction`; malformada vira `null` |
| Criar | `test/core/components/field/app_filter_select_test.dart` | Abre, escolhe, Esc, desativado, nome |
| Criar | `test/features/admin/panel/panel_objects_store_test.dart`, `panel_object_row_test.dart`, `panel_filter_bar_test.dart`, `panel_objects_list_test.dart` | Busca, filtros, ordem, paginação, resumo, escondidos; linha nas três faixas; faixa de filtros |
| Alterar | `test/features/admin/panel/panel_address_test.dart`, `content_store_test.dart`, `panel_objects_view_test.dart`, `panel_harness.dart`, `test/support/fake_content.dart` | Endereço com `tipo`/`q`; store enxuta; vista nova |

## Decisões técnicas
- **Catálogo como fonte, não `ContentStore.getAllContents`:** a spec manda (Q-04) e garante números iguais aos do menu e do site; filtra no navegador (190 objetos). O `ContentDatasource`/`ContentRepository` não mudam (listagens ficam sem uso, sem apagar infraestrutura nesta entrega).
- **Endereço como fonte da verdade dos filtros**, em vez de a store escrever no endereço: o menu e "Ver objetos" já navegam por endereço (013), e um só sentido evita laços. A busca usa `Router.neglect(context, () => context.go(...))`; os selects usam `go` normal (uma entrada por escolha, o que deixa "voltar" desfazer um filtro).
- **O campo de busca guarda o próprio texto** (controlador da vista) e só é reescrito quando o `q` do endereço muda por fora (menu, "Ver objetos", voltar), para não mover o cursor a cada letra. O mesmo cuidado de chave que a 013 aprendeu com o seletor.
- **Foco no título só quando a mudança vem de fora dos filtros:** o `PanelSectionHeader` foca o título quando ele muda (013), o que tiraria o foco do select de tema. A vista marca a navegação feita pelos filtros e passa `focusTitleOnChange: false` nela.
- **Linha excluída some na hora** por uma lista de `docId` escondidos na `PanelObjectsStore`, limpa quando o catálogo recarregado chega; assim a linha não volta se a recarga atrasar ou falhar, e as contagens se ajustam quando o catálogo novo chega.
- **Resultado das gravações como observável (`outcome`)**, não como retorno: o diálogo fecha antes do fim da gravação (comportamento de hoje), então quem mostra o aviso é a vista, por `reaction`. Os textos técnicos de `ContentFailure` deixam de aparecer na tela.
- **"Novo objeto" sem subtema** mostra `Messenger.showInfo` e pede foco ao `FocusNode` do select que falta (decisão da spec).
- **Select próprio (`AppFilterSelect`) em vez do `AppDropdownField`:** o antigo usa `num_extension` e cinza claro. O `MenuAnchor` do Observatório já resolve teclado, Esc e foco.
- **Tipo no endereço pelo `name` do enum** (`video`, não `Vídeo`): sem acento e igual ao que os dados guardam.
- **Leitura tolerante de tipo/formato e da preservação** (decisão da spec): só leitura; `toJson` continua igual, então o diálogo continua gravando o rótulo até a 015.

## Dependências e geração de código
- Nenhum pacote novo; `pubspec.lock` não deve mudar (restaurar com `git restore pubspec.lock` se o `pub get` mexer).
- `fvm dart run build_runner build --delete-conflicting-outputs` depois de criar a `PanelObjectsStore` e mudar a `ContentStore`.
- Nenhuma rota nova nem renomeada: `/admin/painel/objetos` só passa a ler `tipo` e `q` (o builder já usa `PanelSelection.fromQuery`).
- `PanelObjectsStore` criada pela vista (vale enquanto a vista está aberta, como a `SubthemeObjectsStore`), com o `CatalogStore` do `GetIt`; nada novo nos `*_setup.dart`.

## Riscos e cuidados
- **Leitura de tipo/formato e preservação muda o site:** objetos gravados com rótulo passam a mostrar o tipo certo, e a ficha do objeto (009) passa a ler a preservação pelo modelo. Conferir a página de um objeto com preservação (ex.: `NMA_BIO_03`) e a página de subtema com filtro por tipo depois da troca; rodar os testes de `object_sheet` e `subtheme_objects_store`.
- **`ContentStore` encolhe:** `panel_shell.dart`, o diálogo e os testes da 013 (`content_store_test`, `panel_objects_view_test`, `panel_harness`) dependem dela; ajustar todos na mesma tarefa para o `analyze` ficar limpo.
- **Rebuild por endereço a cada letra:** conferir que a página não é recriada (o go_router mantém a mesma página para o mesmo caminho com outra consulta) e que o campo não perde foco nem cursor.
- **`PanelSectionHeader` é usado em "Temas e subtemas":** os parâmetros novos são opcionais; conferir a vista de temas em 390 e 1280.
- **`contentTypeOrder` sai da store do subtema:** os testes da 008 cobrem a ordem dos chips.
- **Sem credenciais:** sessão, gravação e exclusão só com autenticação e datasources simulados na cópia ASCII (nunca no worktree, nunca gravando no Firestore).
- **Contraste do selo e dos detalhes:** `inkSecondary` sobre `page` e `rowHover` (≥ 6,5:1 pela conta da 013); a pílula do código em `ink` sobre `page`.

## Como conferir
- Na cópia em caminho ASCII do scratchpad (rsync sem `build/` e `.dart_tool/`, `fvm flutter pub get`): `fvm flutter analyze`, `fvm flutter test`, `fvm dart format --set-exit-if-changed` nos `.dart` alterados.
- Na mesma cópia, com `AuthRepository` falso (sessão aberta) e `ContentDatasource` e `CatalogDatasource` falsos que compartilham uma coleção em memória semeada com os 190 objetos de `lib/core/content` (mais um objeto com tipo gravado pelo rótulo e um com `preservationAction`), nada gravado no Firestore; variantes em que a exclusão, a gravação e o catálogo falham. Esses arquivos nunca entram no repositório e são apagados ao fim.
- `fvm flutter build web --release`, servidor Python próprio com fallback de SPA, navegador embutido em 390, 768 e 1280 px, comparando com a aba "Painel" do protótipo; ao menos uma vez `fvm flutter run -d web-server` em modo debug para ver asserções e `overflow`. Voltar o navegador ao preset desktop e parar os servidores próprios pelo PID.
