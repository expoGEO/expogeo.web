# Plano da 015. Editor de objeto em página própria

- **Spec:** spec.md
- **Criado em:** 2026-11-09

## Abordagem
O editor é uma **página própria fora da moldura do painel** (`ObjectEditorPage`), em duas rotas novas de nível de cima, `/admin/painel/objetos/novo` e `/admin/painel/objetos/:codigo/editar`, que já caem na regra de sessão do `adminRedirect` (tudo sob `/admin/painel/`). A página lê o objeto e os códigos do **catálogo único** (`CatalogStore`, spec 004), o mesmo da lista: no editar, procura pelo slug do código (Q-01); no novo, calcula o código pelo que o catálogo tem do subtema. O desenho e o comportamento são portados do editor de publicações do Observatório (`post_editor_page.dart`, `components/editor/`, `leave_guard*.dart`), com os tokens e as peças que a expoGEO já tem (`FormTextField`, `FormErrorAlert`, `AppFilterSelect`, `AppButton`, `showConfirmDialog`, `Messenger`, `StateMessageBox`, `AppSkeleton`, `ObjectCard`, `EnvironmentBanner` já global).

O estado do formulário fica numa classe simples e testável (`ObjectEditorForm`: controladores, foco por campo, valores iniciais, "tem alterações", lista de pendências e montagem do `ContentResponseModel`), e a regra do código em funções puras (`reference_code.dart`). A gravação passa pela `ContentStore` (resultado em `outcome`, `isBusy`, `savedCount`), que ganha as três operações do editor (criar com código conferido, atualizar, mover), e a página espera o resultado para voltar à lista e mostrar o aviso.

A **gravação passa a seguir o formato dos 190 objetos do dev** (decisão da spec): o id do documento é o código; `themeId`/`subthemeId` com as siglas (`ThemeEnum.id`, `SubthemeEnum.id`); `themeTitle`/`subthemeTitle` com os nomes do `ThemeDataModel`; tipo e formato pelo `name`; datas só com o dia. Criar e mover usam **transação** do Firestore: os objetos do subtema são lidos de novo (consulta normal, antes da transação, porque a transação só lê documentos), o código é calculado, e a transação lê o documento `{código}`; se já existe, tenta o número seguinte (até 5 vezes) e só então grava (e, ao mover, apaga o antigo na mesma transação). Editar sem trocar de subtema continua com `update`, que preserva as chaves que o editor não conhece.

Na lista (014), "Novo objeto" e "Editar"/título passam a navegar para as rotas novas, e o diálogo `content_form_dialog.dart` é apagado. Uma memória simples do painel (`PanelListMemory`, registrada no `PanelSetup`) guarda o último endereço da lista, para o editor voltar com os filtros.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/models/content_model.dart` | `OriginInfo.toJson` grava tipo e formato pelo `name` e `insertionDate` só com o dia; `PreservationAction.toJson` grava `updateDate` só com o dia; leitura sem mudança |
| Alterar | `lib/core/utils/date/date.dart` | `isoDay` (`AAAA-MM-DD` dos campos como estão, sem fuso) e `monthNames` públicos para as listas de mês |
| Alterar | `lib/features/admin/panel/infra/models/content_response_model.dart` | `toJson` com `themeId`/`subthemeId` pelas siglas e `themeTitle`/`subthemeTitle` pelo `ThemeDataModel` |
| Alterar | `lib/features/catalog/infra/models/catalog_model.dart` | `findByCode(slug)` em todos os subtemas e `codesOf(subtheme)` (só leitura) |
| Criar | `lib/features/admin/panel/infra/models/reference_code.dart` | Regra do código (Q-05): prefixo e número a partir dos códigos do subtema, próximo código, código seguinte |
| Alterar | `lib/features/admin/panel/infra/datasources/content_datasource.dart` | `createWithCode` e `moveContent` por transação, com código conferido; `updateContent` sem mudança; caminho por siglas |
| Alterar | `lib/features/admin/panel/infra/repositories/content_repository.dart` | As duas operações novas com `Either` |
| Alterar | `lib/features/admin/panel/presentation/stores/content_store.dart` (+ `.g.dart`) | `createContent` devolve o código gravado; `moveContent`; `outcome` com o código; `build_runner` |
| Criar | `lib/features/admin/panel/presentation/panel_list_memory.dart` | Último endereço da lista, para voltar com filtros |
| Alterar | `lib/features/admin/panel/panel_setup.dart` | Registra a `PanelListMemory` |
| Alterar | `lib/features/admin/panel/presentation/panel_address.dart` | `newObject(theme, subtheme)`, `editObject(code)`, leitura de `?tema&subtema` do novo |
| Alterar | `lib/core/navigation/app_router.dart` | Constantes e rotas do editor (com `onExit` e redirecionamento do código original para o slug) |
| Criar | `lib/core/utils/browser/leave_guard.dart`, `leave_guard_stub.dart`, `leave_guard_web.dart` | Aviso do navegador ao fechar/recarregar e endereço atual do navegador (porte do Observatório, com `dart:js_interop` e `dart:js_interop_unsafe`, sem pacote) |
| Alterar | `lib/core/components/form/form_text_field.dart` | Parâmetros opcionais: `helperText` (dica visível, lida com o campo), `inputFormatters`, `maxLength`, `prominent` (título em fonte maior) |
| Alterar | `lib/core/components/field/app_filter_select.dart` | Parâmetros opcionais `invalid` (borda de erro) e `height`, para servir de lista de formulário |
| Criar | `lib/core/components/form/form_select_field.dart` | Rótulo + `AppFilterSelect` + erro, no molde do `FormTextField`, integrado ao `Form` |
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart`, `lib/core/theme/app_typography/app_text_styles.dart` | Tokens do editor (barra, grade, cartões, lateral, pílula) e estilos (`editorBarTitle`, `editorCardTitle`, `editorTitleField`) |
| Criar | `lib/features/admin/panel/presentation/editor/object_editor_form.dart` | Estado do formulário, pendências, "tem alterações", montagem do modelo |
| Criar | `lib/features/admin/panel/presentation/components/editor/object_editor_bar.dart` | Barra fixa: voltar, título, pílula do código, Cancelar/Salvar |
| Criar | `lib/features/admin/panel/presentation/components/editor/object_editor_card.dart` | Cartão com título de grupo (semântica de grupo) |
| Criar | `lib/features/admin/panel/presentation/components/editor/object_editor_fields.dart` | Os quatro cartões de campos |
| Criar | `lib/features/admin/panel/presentation/components/editor/object_editor_side.dart` | "Onde aparece" (tema, subtema, código) e "Prévia do cartão" |
| Criar | `lib/features/admin/panel/presentation/components/editor/object_editor_layout.dart` | Duas colunas no desktop; uma coluna com "Onde aparece" no topo e a prévia no fim |
| Criar | `lib/features/admin/panel/presentation/components/editor/object_editor_missing_alert.dart` | Aviso "Falta preencher para salvar:" com links (porte do `PostEditorMissingAlert`) |
| Criar | `lib/features/admin/panel/presentation/components/editor/object_editor_skeleton.dart` | Esqueleto dos cartões e da lateral |
| Criar | `lib/features/admin/panel/presentation/pages/object_editor_page.dart` | Página: carregar, estados, salvar, sair com confirmação |
| Alterar | `lib/features/admin/panel/presentation/pages/panel_objects_view.dart` | "Novo objeto" e "Editar" navegam; guarda o endereço na `PanelListMemory`; sai o tratamento de `created`/`updated`/`saveFailed` |
| Apagar | `lib/features/admin/panel/presentation/components/content_form_dialog.dart` | Substituído pelo editor |
| Alterar/criar | `test/core/models/content_model_test.dart`, `test/features/admin/panel/content_response_model_test.dart`, `reference_code_test.dart`, `object_editor_form_test.dart`, `form_select_field_test.dart`, `object_editor_page_test.dart`, `panel_address_test.dart`, `panel_objects_view_test.dart`, `content_store_test.dart`, `test/core/navigation/object_editor_route_test.dart`, `test/features/catalog/catalog_model_test.dart`, `test/support/fake_content.dart` | Cobertura das regras e das telas |

## Decisões técnicas
- **Página fora do `ShellRoute`:** o protótipo e o Observatório desenham o editor sem o menu lateral. Como a moldura recarrega o catálogo ao montar, a volta à lista já traz o objeto novo; o editor também chama `CatalogStore.refresh()` depois de gravar (a reação a `savedCount` fica na moldura e não roda fora dela). A página reage à perda de sessão (`AuthStore.user` nulo → login), como a moldura.
- **Rotas de nível de cima com `onExit`:** `GoRoute(path: '/admin/painel/objetos/novo')` e `GoRoute(path: '/admin/painel/objetos/:codigo/editar')`, com uma `ValueKey('object-editor')` na página para trocar de endereço sem recriar (mesmo cuidado do Observatório). `onExit` chama `ObjectEditorPage.confirmLeave`, que pergunta só com alterações; no "voltar" do navegador cancelado, devolve o endereço do editor ao navegador (porte do `confirmLeave` do Observatório). A rota de editar redireciona `NMA_BH_03` para `nma-bh-03` com `referenceCodeSlug`, como `_objectRoute`.
- **Objeto achado no catálogo pelo slug, em qualquer subtema:** os códigos não se repetem entre subtemas (prefixo do subtema). Se dois coincidirem, vale o menor, como `CatalogModel.find`. Um método `findByCode(slug)` entra no `CatalogModel` (só leitura).
- **Regra do código em funções puras** (`reference_code.dart`): `parseCode('NMA_PAG_06') → (prefix: 'NMA_PAG', number: 6)`; `nextCode(codes, subtheme)` usa o prefixo mais frequente entre os códigos do subtema (empate: o do maior número), o maior número + 1, com 2 dígitos no mínimo; sem códigos, `SubthemeEnum.id` + `_01`; `following(code)` dá o número seguinte. Assim a tela e a transação usam a mesma regra.
- **Transação para criar e mover**, com o código como id: garante que um código não seja sobrescrito nem duplicado e que mover não deixe duas cópias. Alternativas: `add` com id automático (o formato antigo do diálogo, diferente dos dados) e `WriteBatch` (não confere se o id está livre).
- **`toJson` alinhado aos dados existentes** (decisão da spec): muda só o que o código escreve; a leitura continua aceitando os dois jeitos. As datas viram `AAAA-MM-DD` a partir dos campos do `DateTime` (sem `toUtc`), e `DateTime.parse` lê os dois formatos.
- **Estado do formulário fora do widget** (`ObjectEditorForm`), em vez de uma store MobX: é estado local da página, com `TextEditingController`/`FocusNode` por campo e um `ChangeNotifier` para tema, subtema, tipo, formato, mês e ano. "Tem alterações" compara o retrato inicial dos valores com o atual (voltar ao valor original não conta como alteração).
- **Pendências calculadas pelo formulário, não pelos validadores do `Form`:** `ObjectEditorForm.missing()` devolve os campos na ordem da tela com o texto da spec; a página guarda essa lista, mostra o aviso e passa a cada campo seu erro (o `FormTextField` mostra borda e texto "Preencha …"). O foco vai para o aviso (como no Observatório), que é anunciado.
- **Listas do formulário com `AppFilterSelect`** (já tem teclado, Esc, `MenuAnchor` e nome acessível) envoltas num `FormSelectField` com rótulo e erro, em vez do `AppDropdownField` antigo (usa `num_extension` e cinza claro). Os parâmetros novos do select são opcionais; os filtros da lista não mudam.
- **Ano de emissão** com `FilteringTextInputFormatter.digitsOnly` e `maxLength` 4 (sem contador visível); menos de 4 algarismos entra nas pendências.
- **Próxima revisão** com duas listas: "Mês" (janeiro a dezembro, com "—") e "Ano" (do ano atual − 1 até + 5, mais o ano gravado se estiver fora). Grava `AAAA-MM-01`.
- **Prévia** com o `ObjectCard` existente dentro de `ExcludeSemantics` + `IgnorePointer` + `ExcludeFocus`, com um `Semantics(label: 'Prévia do cartão')` no cartão lateral: não muda o componente do site.
- **Volta à lista com filtros pela `PanelListMemory`** (memória da sessão), em vez de um parâmetro `?voltar=` no endereço do editor: o endereço fica limpo e recarregar o editor continua funcionando (volta à lista sem filtros).
- **Aviso de sucesso** mostrado pelo `Messenger` com o contexto do editor logo antes do `go` para a lista: o `ScaffoldMessenger` é o do `MaterialApp`, e o aviso passa para a tela seguinte. A vista da lista deixa de reagir a `created`/`updated`/`saveFailed` (só exclusão).
- **Aviso do navegador** com `dart:js_interop`/`dart:js_interop_unsafe` (`globalContext` + `addEventListener('beforeunload')`), sem tornar `package:web` dependência direta; importação condicional para os testes na VM.

## Dependências e geração de código
- **Sem pacote novo.** `pubspec.yaml` e `pubspec.lock` não mudam (restaurar o lock se o `pub get` mexer).
- `build_runner` depois de mudar a `ContentStore`.
- Rotas novas em `lib/core/navigation/app_router.dart` (`adminObjectNew`, `adminObjectEdit`), sem mexer nas existentes.
- `PanelSetup` registra a `PanelListMemory`.
- Firestore: mesmas coleções e regras; só muda o que o código grava (alinhado aos 190 objetos).

## Riscos e cuidados
- **Sem credenciais:** criar, editar e mover não podem ser feitos no Firestore real. A conferência usa autenticação e datasource simulados na cópia ASCII (nunca no worktree), que gravam em memória e imprimem o documento montado, para comparar com um dos 190 objetos do dev (consulta só de leitura). A transação real fica sem conferência na tela: os testes cobrem a regra do código, e o risco é anotado na verificação.
- **Formato na produção:** a regra foi tirada do dev. Se a produção tiver objetos com outro formato (siglas, id automático), o editor ainda os lê (014) e os edita no mesmo documento; conferir na produção depois do merge (pendência no histórico).
- **`toJson` muda para o site?** Não: o site só lê. Mas `content_model_test` ("toJson continua gravando o rótulo") muda de propósito; conferir que nenhum outro teste dependa do rótulo gravado.
- **`FormTextField` e `AppFilterSelect` são compartilhados** (login, Contato, filtros da lista e do subtema?): parâmetros novos opcionais; rodar os testes de `signin_page`, `contact_form`, `panel_filter_bar`, `app_filter_select` e olhar login, Contato e a lista em 390 e 1280.
- **`onExit` do go_router 14.8** roda também em `go` feitos pela própria página (salvar): a página zera "tem alterações" antes de navegar.
- **Voltar do navegador com alterações:** no web o endereço já mudou quando `onExit` pergunta; se a pessoa continua editando, o endereço é devolvido (porte do Observatório). Conferir na tela.
- **`beforeunload` e Hot restart:** o ouvinte é retirado no `dispose` e quando não há alterações.
- **Teclado nas listas dentro do formulário:** o `AppFilterSelect` foi feito para a faixa de filtros; conferir Tab, Enter, setas e Esc dentro dos cartões.
- **Barra fixa:** a página usa `CustomScrollView` com a barra como `SliverPersistentHeader` fixo ou `Column` com a barra fora da rolagem; conferir que o foco por Tab rola o campo para fora de baixo da barra.

## Como conferir
- Na cópia ASCII do scratchpad (o "ó" do caminho quebra as ferramentas): `fvm flutter pub get`, `fvm dart run build_runner build --delete-conflicting-outputs`, `fvm flutter analyze`, `fvm flutter test`, `fvm dart format --set-exit-if-changed` nos arquivos alterados; `git restore pubspec.lock` se mudar.
- `fvm flutter build web --release` com autenticação e datasource simulados (só na cópia), servido por um servidor Python próprio com fallback para `index.html`; navegador embutido em 390, 768 e 1280, voltando ao preset desktop no fim; pelo menos uma vez em modo debug (`fvm flutter run -d web-server`) olhando o registro de `overflow`.
- Telas: lista → "Novo objeto" com e sem filtros; editor de `nma-bh-03`; `NMA_BH_03/editar`; código inexistente; pendências; troca de subtema; saída com e sem alterações; erro de gravação simulado; catálogo lento e com erro; lista, "Temas e subtemas", login, Contato e uma página de objeto do site depois da mudança.
