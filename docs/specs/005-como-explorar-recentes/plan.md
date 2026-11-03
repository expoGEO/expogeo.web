# Plano da 005. Home: Como explorar e Adicionados recentemente

- **Spec:** spec.md
- **Criado em:** 2026-11-03

## Abordagem
Tudo sai do **catálogo da 004** (`CatalogStore`, já carregado pela `HomePage`). Nenhuma consulta nova, nenhum datasource novo: as duas seções observam o mesmo store que alimenta as contagens do hero.

**Consultas no modelo.** O `CatalogModel` ganha duas leituras puras sobre a lista que já tem: `latest(int count)` (ordem por `originInfo.insertionDate` decrescente; empate pelo código de referência, `content.id`, em ordem crescente) e `firstOf(SubthemeEnum)` (objeto de menor código de referência no subtema, ou `null`). O `CatalogItem` ganha `route`, que hoje devolve a rota do subtema (`subtheme.route`); quando a 009 criar a página do objeto, só esse getter muda e o cartão e o exemplo 3 passam a levar ao objeto.

**Cartão de objeto.** Componente compartilhado em `lib/core/components/card/object_card.dart`, porque a 009 (outros objetos) e a 015 (prévia do editor) vão usá-lo. Recebe dados simples (`ContentModel`, `SubthemeEnum` e `onOpen`), sem depender do catálogo, para servir à prévia do editor, que não tem catálogo. Desenho do `.ocard` do protótipo: borda `line`, raio 16, padding 20, fundo `page`; linha de cima com o ícone do tipo num quadrado `accentSoft` de 40 px (ícone em `accent`) e a linha "Tipo · Formato" em rótulo (`label`, maiúsculas, `accent`); título em `h3` (até 3 linhas); descrição em `inkSecondary` (até 2 linhas, com reticências); rodapé com filete `line`, mini-medalhão do subtema (`AppMedallion` de 22 px) e "Subtema · Criador" em `small`/`inkSecondary`. O cartão inteiro é um único link, no mesmo arranjo do `ThemeOverviewCard` (camada clicável por cima, fora da semântica; `Semantics(link: true, label: título, explicitChildNodes: true)` com o h3 como nó próprio). Hover: borda `accent`, `shadows.elevated`, sobe 2 px e o título fica `accent`; com "reduzir movimento", só borda, sombra e cor. Junto vem o `ObjectCardSkeleton`, no mesmo formato.

**Ícone e linha do tipo.** Uma extensão em `lib/core/models/content_type_display.dart`: `ContentType.cardIcon` (ícones do protótipo: globo, play, documento, aplicativo, imagem, link) e `typeLine(ContentType, ContentFormat)`, que omite o formato quando é `outro` ou quando o nome é igual ao do tipo ("Vídeo · Vídeo" vira "Vídeo"). O `ContentType.icon` e o `ContentType.color` do modelo continuam como estão (o painel ainda usa as cores).

**Seções da Home.** Duas seções novas montadas pela `HomePage` depois de "Por onde começar":
- `HomeExploreSection`: fundo `surface`, rótulo "Como explorar" e `h2` "Do tema ao recurso, em três passos"; três passos em `Row` com `Expanded` no desktop (≥ 1024) e em coluna abaixo. Cada passo: filete de 2 px em `ink` em cima (como o `.step` do protótipo), número em círculo (30 px, `accentSoft` com o algarismo em `accentStrong`, decorativo), título `h3`, texto em `inkSecondary` e a caixa do exemplo (fundo `page`, borda `line`, raio 10, "Ex.:" em `ink` e o link em `accent` semibold com foco visível). Exemplo 1 leva a `ThemeEnum.naturezaMeioAmbiente.route` com o título do `ThemeModel` ("Meio Ambiente e Natureza"); exemplo 2 leva a `SubthemeEnum.biomas.route` com "Biomas · N objetos" (`countBySubtheme`); exemplo 3 usa `firstOf(SubthemeEnum.biomas)` e leva a `item.route`. Carregando: esqueleto curto no lugar de "N objetos" e do título do exemplo 3. Erro: exemplo 2 sem a contagem; exemplo 3 some. Vazio: "Biomas · 0 objetos" e exemplo 3 some.
- `HomeRecentSection`: `h2` "Adicionados recentemente" e a grade dos `latest(6)`: 1 coluna no celular, 2 no tablet, 3 no desktop (por faixa, como manda o README), linhas de altura igual (`IntrinsicHeight`, como a grade dos temas). Carregando (inicial ou carregando): 6 `ObjectCardSkeleton`. Erro: `StateErrorInline` "Não conseguimos carregar os objetos recentes" com "Tentar de novo", que chama `ensureLoaded()` (o store já tenta de novo depois de erro). Sucesso sem objetos: a seção inteira some (`SizedBox.shrink`).

**Estado de erro compacto.** O `StateErrorInline` do Observatório (`lib/app/core/components/error_content/state_error_inline.dart`) vem para `lib/core/components/state/state_error_inline.dart` com os tokens daqui (`surface`, `line`, `r16`, `AppButton.secondary` pequeno). A 011 consolida os estados compartilhados depois; usar o mesmo componente agora evita reescrever.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/features/catalog/infra/models/catalog_model.dart` | `latest(count)`, `firstOf(subtheme)` e `CatalogItem.route` |
| Criar | `lib/core/models/content_type_display.dart` | Ícone do tipo e linha "Tipo · Formato" com a regra de omissão |
| Alterar | `lib/core/models/theme_illustration.dart` | `SubthemeEnum.illustration` (imagem do `SubthemeModel` no `ThemeDataModel`, `null` se faltar) |
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Tokens dos passos, do cartão de objeto, da grade e do estado de erro compacto |
| Criar | `lib/core/components/card/object_card.dart` | Cartão de objeto e o esqueleto dele |
| Criar | `lib/core/components/state/state_error_inline.dart` | Erro compacto com "Tentar de novo" (do Observatório) |
| Criar | `lib/features/home/components/home_explore_section.dart` | "Como explorar" com os três passos |
| Criar | `lib/features/home/components/home_recent_section.dart` | "Adicionados recentemente" com grade, esqueleto, erro e vazio |
| Alterar | `lib/features/home/pages/home_page.dart` | Dois slivers novos depois de "Por onde começar" |
| Alterar | `test/features/catalog/catalog_test_data.dart` | Registros com datas e códigos para ordenar |
| Alterar | `test/features/catalog/catalog_model_test.dart` | `latest`, empate, menos de 6, `firstOf` |
| Criar | `test/core/models/content_type_display_test.dart` | Regra de omissão do formato |
| Criar | `test/core/components/object_card_test.dart` | Conteúdo, linhas, foco único, toque, placeholder, h3 |
| Criar | `test/features/home/home_explore_section_test.dart` | Textos, destinos, contagem, esqueleto, erro e vazio |
| Criar | `test/features/home/home_recent_section_test.dart` | 6 esqueletos, 6 cartões, erro com nova tentativa, seção oculta |

Nada muda em `content_model.dart`, `content_response_model.dart`, `app_router.dart`, `firestore.rules`, `pubspec.*` nem no painel.

## Decisões técnicas
- **Sem consulta nova.** Ordem e filtro sobre `CatalogModel.items` em memória (190 objetos). O índice de `collectionGroup` por data em `firestore.indexes.json` fica sem uso por ora; não é apagado.
- **Ordenação no modelo, não no widget.** `latest` e `firstOf` são funções puras testáveis; o widget só pede.
- **Empate pelo código de referência em ordem crescente** (`content.id`, ex.: `NMA_BIO_01`), que é estável entre cargas; o `docId` do Firestore é aleatório.
- **"Primeiro objeto de Biomas" = menor código de referência.** O protótipo usa o primeiro da lista; no Firestore não há ordem própria, e o código é a ordem da curadoria (hoje `NMA_BIO_01`, "aVoar Cerrado").
- **Destino do objeto num só lugar (`CatalogItem.route`).** Hoje é a rota do subtema; nenhuma rota nova. A 009 troca o getter.
- **Cartão recebe dados simples e `onOpen`**, não o `CatalogItem`, para servir também à prévia do editor (015), que monta um `ContentModel` sem catálogo. O subtema vem à parte porque, no catálogo, ele sai do caminho do documento, não do campo `subthemeId`.
- **Nome do subtema pelo `SubthemeEnum`** (caixa normal), como os mini-chips da 004; os títulos do `ThemeDataModel` estão em maiúsculas.
- **Nome do tema no exemplo 1 pelo `ThemeModel`** ("Meio Ambiente e Natureza"), igual ao anel, aos cartões e à navbar (decisão da 004).
- **Número do passo em círculo**, como a spec manda. O protótipo da Home mostra só o algarismo em laranja; o círculo segue o da lista numerada do protótipo (`.manifest-list`: 30 px, `accentSoft`, algarismo `accentStrong`). Decorativo (`ExcludeSemantics`).
- **Colunas por faixa, não por largura mínima de 300 px** como no CSS do protótipo: o README pede tamanhos fixos por faixa; o resultado nas três larguras é o mesmo (1, 2 e 3 colunas).
- **Ícones do tipo com `Icons` do Material** (`language`, `play_circle_outline`, `description_outlined`, `apps_outlined`, `image_outlined`, `link`), sem pacote de ícones novo. Decorativos (`ExcludeSemantics`); o tipo está escrito na linha de rótulo.
- **"Tentar de novo" recarrega o catálogo inteiro**: é a mesma carga; se der certo, as contagens do hero voltam junto. Sem estado de erro separado para os recentes.
- **Erro compacto do Observatório agora, não o da 011.** Mesmo texto e botão da spec; a 011 decide a forma final dos estados compartilhados.
- **Rótulo "Como explorar" em `accentStrong`.** A seção tem fundo `surface`, onde o `accent` dá 4,45:1 (abaixo de 4,5:1); mesma solução do hero na 004. Os links dos exemplos ficam em `accent` porque estão sobre a caixa branca (4,87:1).
- **Hover do cartão sobe 2 px** (o dos temas sobe 3), como no `.ocard:hover` do protótipo.

## Dependências e geração de código
- Nenhum pacote novo. Se o `pub get` mexer no `pubspec.lock`, `git restore pubspec.lock`.
- Sem `build_runner`: nenhum store novo nem mudança em store (o `CatalogStore` não muda).
- Rotas: nenhuma nova nem alterada (`theme.route`, `subtheme.route` já existem).
- Registro: nenhum (o `CatalogSetup` da 004 já registra o store).
- Assets: nenhum novo (ilustrações dos subtemas em WebP desde a 003).

## Riscos e cuidados
- **Regra não publicada no dev.** Com o Firestore real a consulta é negada: "Adicionados recentemente" mostra o erro e "Como explorar" fica sem contagem nem exemplo 3. O estado de sucesso só pode ser conferido com um **datasource falso temporário**, só na cópia ASCII do scratchpad e nunca commitado, alimentado com os objetos do dev lidos por subtema pela API REST (a leitura por subtema é permitida). Os 6 mais recentes esperados saem desse mesmo dump, ordenados por um script, e são comparados com a tela. Conferir de novo na Home do dev depois que a pessoa publicar a regra.
- **Datas iguais.** Vários objetos do seed têm a mesma data de inserção; o desempate pelo código tem de bater com o script de conferência.
- **`AppMedallion`, `AppSkeleton`, `AppButton` e tokens compartilhados.** Só se somam tokens; conferir hero, cartões dos temas, menu Temas e 404 depois.
- **Semântica do cartão.** O mesmo risco da 004 (link que engole o h3). Teste de widget e `read_page` conferem um link por cartão com o h3 dentro.
- **Altura igual nas linhas com `IntrinsicHeight`**: o esqueleto e os cartões têm de ter altura intrínseca calculável (sem `LayoutBuilder` dentro). Asserções desse tipo só aparecem em debug.
- **Texto longo:** título com 3 linhas e reticências, descrição com 2; "Subtema · Criador" com nome de criador longo quebra sem `overflow` em 390.
- **Contraste:** `accent` sobre `page` (rótulo do tipo e link do exemplo) 4,87:1; `inkSecondary` sobre `surface` e `page`; `accentStrong` sobre `accentSoft` (número). Medir na conferência.
- **Caminho com "ó":** `analyze` e `test` na cópia ASCII do scratchpad.
- **Painel admin:** não muda; sem credenciais de teste, fica "não conferido na tela".

## Como conferir
- `fvm flutter analyze` e `fvm flutter test` na cópia ASCII; `fvm dart format` nos `.dart` alterados.
- `git diff --stat` sem `lib/features/admin/`, `app_router.dart`, `content_model.dart`, `content_response_model.dart`, `firestore.rules`, `pubspec.*`; nenhum arquivo de datasource falso no projeto.
- `fvm flutter build web --release` no projeto (Firestore real → estado de erro) e na cópia com o datasource falso (sucesso, esqueleto com atraso e vazio); servidor Python próprio com fallback para `index.html`; navegador embutido em 390, 768 e 1280 px. Uma vez em debug (`fvm flutter run -d web-server`). Voltar o navegador ao preset desktop e parar os servidores.
