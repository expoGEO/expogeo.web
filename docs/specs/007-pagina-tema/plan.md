# Plano da 007. Página do tema

- **Spec:** spec.md
- **Criado em:** 2026-11-04

## Abordagem
A `ThemePage` passa a ser montada com as peças que as Fases 0 e 1 deixaram prontas. O cabeçalho é o `PageHeader` da 006, ampliado com dois espaços opcionais (medalhão e detalhes), para a 008 usar o mesmo cabeçalho. Os cartões seguem o padrão do `ThemeOverviewCard` da 004: um link só, clique numa camada fora da árvore de acessibilidade, `h3` preservado dentro do link. As contagens vêm do `CatalogStore` por `Observer`, com os mesmos três estados da Home (esqueleto, número, some).

Tudo o que não é contagem vem do código e aparece na hora, então a página nunca espera o Firestore. A `ThemePage` vira `StatefulWidget` só para chamar `ensureLoaded()` no `initState`: sem isso, quem entra direto pelo endereço ficaria sem contagens, porque hoje só a Home dispara a carga.

Nenhum modelo, rota, regra do Firebase ou pacote muda. `ThemeBanner`, `SubthemeGrid` e `SubthemeCard` saem, porque só a `ThemePage` os usa e não têm conteúdo próprio.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Tokens de cabeçalho com medalhão, grade, cartão e chips |
| Alterar | `lib/core/components/reading/page_header.dart` | Espaços opcionais `trailing` e `details`; sem eles, nada muda na Sobre |
| Criar | `lib/features/theme/components/theme_header_stats.dart` | "N subtemas" e "N objetos digitais", com esqueleto e erro |
| Criar | `lib/features/theme/components/subtheme_overview_card.dart` | Cartão de subtema: medalhão, nome, contagem e os estados |
| Criar | `lib/features/theme/components/theme_subthemes_section.dart` | `h2` com a contagem e grade de 2, 3 ou 4 colunas com altura igual por linha |
| Criar | `lib/features/theme/components/other_themes_section.dart` | Rótulo "Outros temas" e chips com mini-medalhão |
| Alterar | `lib/features/theme/pages/theme_page.dart` | Nova composição, carga do catálogo, fundo padrão; mantém o construtor usado pelo `AppRouter` |
| Apagar | `lib/features/theme/components/theme_banner.dart`, `subthemes_grid.dart`, `subtheme_card.dart` | Sem uso depois da troca |
| Criar | `test/core/components/page_header_test.dart` | Espaços opcionais e layout por faixa |
| Criar | `test/features/theme/theme_header_stats_test.dart`, `subtheme_overview_card_test.dart`, `theme_subthemes_section_test.dart`, `other_themes_section_test.dart`, `theme_page_test.dart` | Critérios cobertos em teste de widget |

## Decisões técnicas
- **`PageHeader` ampliado, em vez de um cabeçalho próprio do tema.** A 008 tem o mesmo cabeçalho com medalhão. `trailing` recebe o widget pronto e `details` entra abaixo do `lead`. Desktop: `Row` centralizada com texto em `Expanded` e `trailing` à direita. Celular e tablet: `trailing` acima das migalhas (`.medal{order:-1}` do protótipo). Sem `trailing` e `details`, a árvore é a de hoje.
- **Medalhão por faixa na `ThemePage`:** 180 no desktop e 96 em celular e tablet (decisão de 768 registrada na spec). `ThemeEnum.illustration`, não `ThemeModel.imagePath` (`.jpg` antigo, inexistente).
- **Nome do subtema de `subtheme.type.name` e do tema de `theme.title`; descrição com `trim()`** (a de Cultura e Política termina com espaço). Motivo na spec.
- **Colunas fixas por faixa (2, 3, 4), como a `PartnerLogoGrid`**, e não o `auto-fill` do protótipo, pela regra de tamanhos por faixa do README. Em 600 px o cartão tem cerca de 165 px, por isso o medalhão de tablet é 120 (o do esqueleto do protótipo) e não 140.
- **Altura igual por linha com `IntrinsicHeight` + `Row` esticada**, como `_ThemesGrid` da Home. Alternativa `AlignedGridView` (usada hoje) não iguala alturas. Células vazias completam a última linha para a largura não mudar. Nada de `LayoutBuilder` no cartão: ele não responde a altura intrínseca. O placeholder do `AppMedallion` tem um, mas fica sob `SizedBox.square`, que responde sozinho; há teste com a imagem falhando dentro da grade.
- **Cartão com foco único**, cópia do padrão do `ThemeOverviewCard`: `Semantics(link, label, focusable, container, explicitChildNodes)` por fora; `InkWell` em `Positioned.fill` com `ExcludeSemantics`, `focusNode` e hover; `AppFocusRing` com `StackFit.passthrough`. O nome é `h3`; a contagem é nó próprio. Elevação é só sombra: o protótipo não sobe o cartão (`.scard` sem `translateY`).
- **Hover:** borda `accent`, `shadows.elevated`, nome em `accent`, medalhão gira −8° (`themeCardMedallionTurn`) e cresce 3%. Com "reduzir movimento", sem giro nem escala.
- **Contagem como peça única por estado:** sucesso "N objetos" ou "1 objeto"; 0 "Nenhum objeto ainda"; carregando `AppSkeleton` com a altura da linha, para o cartão não pular; erro nada. Só o `Observer` da contagem reconstrói.
- **Estado inicial tratado como carregando**, como na Home, porque o primeiro frame vem antes do `ensureLoaded`.
- **`store` opcional nos componentes e na `ThemePage`** (sem valor, `GetIt`), como `ThemeOverviewCard` e `HeroCounts`, para os testes usarem o `FakeCatalogRepository`.
- **`themeTitle` continua no construtor da `ThemePage`**, sem uso, para não tocar no `AppRouter`. O `orElse` também fica: as quatro rotas só passam ids válidos e o endereço inexistente nunca chega aqui.
- **"Outros temas":** texto com `toUpperCase()` e `styles.label` em `accent` (sobre `page`, 4,87:1), dentro de `Semantics(header, headingLevel: 2, label: 'Outros temas', excludeSemantics)`, para a leitura não soletrar. Chips em `Wrap`; a ordem é a do `ThemeDataModel`, sem o tema atual.
- **Chips com link, não `AppButton`:** não há variante com imagem, e os chips de filtro da 008 têm outro papel (alternam). Componente privado em `other_themes_section.dart`, com `InkWell`, `AppFocusRing`, altura mínima `minTapTarget`, borda `line` e hover com borda `ink`.
- **Nomes novos sem colidir com a 016:** `SubthemeOverviewCard` em arquivo novo, porque a lista da 016 cita `subtheme_card` para remoção; apagado agora, a busca dela não acha nada.

## Dependências e geração de código
- Nenhum pacote novo. `flutter_staggered_grid_view` continua no `pubspec` (sai na 016). Se o `pub get` mexer no `pubspec.lock`, não incluir em commit.
- Sem `build_runner`: nenhum store novo nem modelo.
- Rotas: nenhuma alterada; `app_router.dart` não muda. Assets: nenhum novo. Setup: nenhum registro novo (`CatalogSetup` já roda no `main`).

## Riscos e cuidados
- **Leitura do catálogo no dev.** `firestore.rules` já tem a regra e os deploys passaram a publicá-la, mas a conferência ainda não foi feita depois disso. Se a consulta for negada, a página cai no estado de erro e os critérios 3 e 4 não podem ser conferidos com dados reais: nesse caso usar datasource falso só em cópia no scratchpad, alimentado pelos dados do dev, e registrar a ressalva.
- **`PageHeader` é da Sobre.** Conferir `/sobre` nas três larguras; `about_page_test.dart` segue passando.
- **Medalhão acima das migalhas** em celular e tablet muda a ordem de leitura visual, não a do teclado (o medalhão não tem foco).
- **`IntrinsicHeight` por linha** custa uma medição a mais; são no máximo 4 linhas, sem imagem pesada fora do cache. Asserções de layout só aparecem em debug: rodar uma vez com `flutter run -d web-server`.
- **Grade em 600 px:** nomes longos podem ir a 3 linhas; conferir 600 e 1024, além das três larguras da spec, para `overflow`.
- **Chips de tema:** cada tema é uma rota, então a página nova nasce no topo; conferir que o scroll não fica no fim ao trocar de tema pelo fim da página.
- **Texto a 200%:** a navbar já transborda (pendência anterior, fora daqui). Conferir só cartões, cabeçalho e chips.
- **Caminho com "ó":** `analyze` e `test` na cópia ASCII do scratchpad. `pubspec.lock` tem alteração solta da pessoa.
- **Painel admin:** não muda; sem credenciais, fica "não conferido".

## Como conferir
- `fvm flutter analyze` e `fvm flutter test` na cópia ASCII; `fvm dart format` nos `.dart` alterados.
- `git diff --stat` sem `lib/features/admin/`, `app_router.dart`, `lib/core/models/`, `lib/core/content/`, `firestore.rules`, `pubspec.*`.
- `grep` por `Color(0x`, `fontSize:` numérico, `EdgeInsets` e `SizedBox` com número e `.scale` nos arquivos novos.
- `fvm flutter build web --release`, servidor Python próprio com fallback para `index.html`, navegador embutido em 390, 768 e 1280 px, nas quatro rotas. Uma vez em debug. Detalhe na tarefa D2.
