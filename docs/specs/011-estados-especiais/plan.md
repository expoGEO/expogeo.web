# Plano da 011. Estados especiais: carregando, vazio, erro e 404

- **Spec:** spec.md
- **Criado em:** 2026-11-08

## Abordagem
Quase tudo já existe: `StateMessageBox`, `StateErrorInline`, `AppSkeleton` e os esqueletos de cada tela vieram das Fases 1 e 2. A entrega é fechar as diferenças, sem refazer telas:

1. **Caixa de estado:** a `StateMessageBox` ganha um topo opcional no lugar do ícone (para o "404"), o nível de título (para o `h1` da 404) e o papel de leitura por tom: `SemanticsRole.alert` no erro e região anunciada (status) no neutro.
2. **Erro padrão:** um `StateErrorBox` em `core/components/state/`, como o do Observatório (`error_content/state_error_box.dart`), com ícone de alerta, o texto "Confira sua conexão com a internet e tente de novo." e "Tentar de novo" primário. Subtema e objeto passam a usá-lo, mudando só o título.
3. **404:** `NotFoundPage` reescrita sobre `SiteScaffold` + `PageContent` + a caixa na variante 404. A navbar fica neutra por um `NavbarLocationScope` (InheritedWidget) que a página põe em volta do scaffold; `NavbarLocation.of` consulta o escopo antes do endereço. O roteador, o subtema e o objeto continuam chamando a mesma `NotFoundPage`, então as rotas não mudam.
4. **Carregando para a leitura de tela:** um `LoadingRegion` em `core/components/skeleton/` (`Semantics` com rótulo "Carregando…" e os filhos fora da leitura) envolve as linhas do subtema, os cartões dos recentes e o esqueleto do objeto.
5. **Offline:** o `CatalogDatasource` passa a tratar resposta vazia vinda do cache como falha, como o Observatório (`snapshot.docs.isEmpty && snapshot.metadata.isFromCache`). O repositório devolve `CatalogFetchFailure`. A regra fica numa função pura para ser testada sem Firestore.

O painel, os botões antigos e `CircularLoading`, `ContentError` e `ContentEmpty` não são tocados.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | `notFoundPaddingTop`/`Bottom` (40/72) |
| Alterar | `lib/core/theme/app_typography/app_text_styles.dart` | `stateCode`: Bricolage 800, 64/88/112 por faixa, espaçamento -0,04 em, altura 1, cor definida no uso (tamanhos no estilo, como os outros estilos por faixa) |
| Alterar | `lib/core/components/state/state_message_box.dart` | `leading` opcional no lugar de `icon`; `headingLevel`; `SemanticsRole.alert` no erro e `SemanticsRole.status` no neutro, com anúncio do título ao aparecer (`announce`, desligável na 404) |
| Criar | `lib/core/components/state/state_error_box.dart` | Erro de carregamento padrão (título + `onRetry`) |
| Criar | `lib/core/components/skeleton/loading_region.dart` | Rótulo "Carregando…" para um grupo de esqueletos |
| Alterar | `lib/core/components/structure/navbar/navbar_location.dart` | `NavbarLocationScope` e consulta a ele em `NavbarLocation.of` |
| Alterar | `lib/core/pages/not_found_page.dart` | 404 nova, sem degradê, cores nem medidas soltas |
| Alterar | `lib/features/theme/components/subtheme_objects_section.dart` | `StateErrorBox`; `LoadingRegion` nas linhas |
| Alterar | `lib/features/theme/pages/object_page.dart` | `StateErrorBox`; `LoadingRegion` em cabeçalho e ficha |
| Alterar | `lib/features/home/components/home_recent_section.dart` | `LoadingRegion` nos cartões-esqueleto |
| Alterar | `lib/features/catalog/infra/datasources/catalog_datasource.dart` | Resposta vazia do cache vira falha |
| Alterar | `lib/features/catalog/infra/repositories/catalog_repository.dart` | Mapeia a falha offline para `CatalogFetchFailure` |
| Alterar | `README.md` | Linha "Componentes" do Design System: `StateMessageBox`, `StateErrorBox`, `StateErrorInline`, `AppSkeleton`, `LoadingRegion` |
| Criar | `test/core/pages/not_found_page_test.dart` | Textos, `h1`, botão, navbar neutra, larguras |
| Criar | `test/core/components/state_error_box_test.dart`, `test/core/components/loading_region_test.dart`, `test/core/components/app_skeleton_test.dart` | Componentes |
| Criar | `test/features/catalog/catalog_datasource_test.dart` | Regra do cache vazio |
| Alterar | `test/core/components/state_message_box_test.dart`, `test/features/catalog/catalog_store_test.dart`, `test/features/theme/subtheme_objects_section_test.dart`, `test/features/theme/object_page_test.dart`, `test/features/home/home_recent_section_test.dart` | Papéis de leitura, retry sem empilhar, botão primário, "Carregando…" |

Não mudam: rotas e `app_router.dart`, modelos, `firestore.rules`, painel (`lib/features/admin/`), `PrimaryButton`/`SecondaryButton`, `CircularLoading`, `AppButton`, `pubspec.yaml`.

## Decisões técnicas
- **Escopo herdado para a navbar neutra, e não parâmetro no `SiteScaffold`.** O `SiteScaffold` monta a `NavbarSliver` por dentro; passar a localização por três construtores mexeria em todas as páginas. Um `InheritedWidget` em volta só da 404 resolve sem tocar no resto.
- **`StateErrorBox` novo, e não só trocar o botão no subtema.** O texto e o botão do erro se repetem em duas telas e a spec pede que sejam iguais; o Observatório já tem a mesma peça.
- **`SemanticsRole.alert` existe no Flutter 3.35.5** (usado pelos diálogos do Material). Se o motor web não emitir `role="alert"` para ele, usar `SemanticsService.announce` ao montar a caixa de erro, como a `ContactConfirmation` da 010 fez com o título.
- **"404" fora da leitura** com `ExcludeSemantics`; o título leva `headingLevel: 1`.
- **Tamanho do "404" por faixa** (64/88/112), no lugar do `clamp(4rem,12cqi,7rem)` do protótipo, porque a regra do projeto proíbe escalar com a tela.
- **Regra do cache numa função estática** (`CatalogDatasource.checkSnapshot(isEmpty, isFromCache)` ou equivalente), porque o projeto não tem `fake_cloud_firestore` e não deve ganhar pacote por isso.
- **Retry sem empilhar** já é garantido pelo `ensureLoaded` (ignora chamada enquanto carrega); a entrega só acrescenta o teste com o `FakeCatalogRepository`, que conta as consultas.
- **"Tentar de novo" no erro compacto da Home continua secundário pequeno**, como na 005: a seção é secundária e o botão primário competiria com os da página.

## Dependências e geração de código
- Nenhum pacote novo, nenhum asset, nenhuma rota nova. `build_runner` não é necessário (nenhum store ou modelo muda).

## Riscos e cuidados
- **`StateMessageBox` é usada por subtema, objeto e 404:** a troca de `icon` obrigatório por `icon` ou `leading` não pode mudar o desenho das caixas atuais. Conferir subtema (vazio, busca sem resultado, erro) e objeto (erro) nas três larguras.
- **`NavbarLocation.of` serve navbar e menu do celular em todas as páginas:** conferir que "Temas", "Sobre" e "Contato" continuam ativos nas próprias páginas.
- **Papel de alerta no web:** pode não sair como `role="alert"` no motor 3.35.5; conferir na árvore do navegador (clicar em `flt-semantics-placeholder` via JS).
- **Testes que procuram `NotFoundPage` por tipo** (tema, subtema, objeto) seguem válidos, porque a classe continua a mesma.
- **Offline real:** o navegador embutido não desliga a rede. O erro é conferido com datasource que falha, só na cópia ASCII, como na 005 e na 009.
- **Painel:** não pode mudar; conferir com `git diff --stat` que nada em `lib/features/admin/` mudou. Sem credenciais de teste, fica "não conferido" na tela.

## Como conferir
- Na cópia ASCII do scratchpad (o "ó" do caminho quebra a ferramenta), com o `pubspec.lock` do git: `fvm flutter pub get`, `fvm flutter analyze`, `fvm flutter test`, `fvm dart format` nos arquivos alterados.
- `fvm flutter build web --release` lá, servido por um servidor Python com fallback de SPA, no navegador embutido em 390, 768 e 1280: `/nao-existe`, `/natureza-meio-ambiente/nao-existe`, `/cultura-politica/biomas`, `/natureza-meio-ambiente/biomas/nao-existe`, `/a/b/c/d`, um endereço com 300 caracteres; subtema e objeto com sucesso, busca sem resultado e erro simulado; Home com recentes em erro simulado; `/sobre` e `/contato` com o item ativo.
- Uma vez em debug (`fvm flutter run -d web-server`) na 404 e no subtema, sem asserção de layout no console.
- Voltar o navegador ao preset desktop e parar os servidores próprios ao terminar.
