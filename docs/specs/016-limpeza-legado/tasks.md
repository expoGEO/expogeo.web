# Tarefas da 016. Limpeza: código, tokens, fontes, pacotes e assets sem uso

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios de aceite da spec, na ordem: CA1 analyze e testes; CA2 build e tamanho; CA3 sem Aleo, google_fonts e num_extension; CA4 componentes antigos fora; CA5 pacotes fora; CA6 tokens e campo `color` fora; CA7 faixa de ambiente igual; CA8 assets sem referência; CA9 pubspec e `tool/images`; CA10 nada de dados, regras e rotas; CA11 telas iguais em 390, 768 e 1280; CA12 README e REFACTORING_SUMMARY.

Regras de todas as tarefas: antes de apagar, `grep -rn` do nome da classe e do arquivo em `lib/ test/ bin/ tool/`; depois de apagar, `fvm flutter analyze` e `fvm flutter test` na cópia ASCII do scratchpad (sincronizar com `rsync`, ver plano) sem avisos; um commit por grupo, sem push.

## Grupo 0: base de comparação
- [x] **0.1.** Na cópia ASCII do commit atual: `pub get`, `analyze`, `test` verdes; `fvm flutter build web --release`; anotar `du -sk build/web` (**antes**) e o número de testes. Guardar os números para o `verificacao.md`. Atende: CA1, CA2.
  - Nota: build/web antes = 49384 KB (`du -sk`), 1002 testes passando.

## Grupo A: componentes e utilitários antigos
- [x] **A1.** Apagar `primary_button.dart`, `secondary_button.dart`, `rounded_icon_button.dart`, `back_to_button.dart`, `checkbox_button.dart` e `circular_loading.dart` (nessa ordem: consumidores antes do consumido). Conferir que `app_button.dart`, `app_icon_button.dart` e `inline_link.dart` não importam nenhum. Atende: CA4.
- [x] **A2.** Apagar `app_text_field.dart` e `app_dropdown_field.dart`. Conferir que `form_text_field.dart`, `form_select_field.dart`, `app_filter_select.dart` e `app_search_field.dart` seguem sem dependência deles. Atende: CA4.
- [x] **A3.** Apagar `app_network_image.dart`, `app_asset_image.dart`, `rounded_card.dart`, `lib/core/utils/validators/validators.dart` (mantém `form_validators.dart`). Atende: CA4.
- [x] **A4.** Apagar `app_icon.dart`, `rounded_app_icon.dart` e `lib/core/utils/enums/app_icons.dart`; apagar pastas que ficarem vazias (`icon/`, `loading/`). Conferir que o rodapé e o cartão do Observatório continuam com `flutter_svg` direto. Atende: CA4.
- [x] **A5.** Gate do grupo A: `analyze`, `test`, `build web` e um `grep -rnE "PrimaryButton|SecondaryButton|RoundedIconButton|BackToButton|CheckboxButton|CircularLoading|AppTextField|AppDropdownField|AppNetworkImage|AppAssetImage|RoundedCard|AppIcon\b|RoundedAppIcon|AppIcons|\bValidators\b" lib test` sem resultado. Commit do grupo. Atende: CA1, CA4.

## Grupo B: tipografia, Aleo e `num_extension`
- [x] **B1.** `EnvironmentBanner` passa a usar um estilo de `AppTheme.typography.of(context)` com mesmo peso e tamanho aproximados do `label` médio antigo, e a cor de fundo vira o token novo `AppColors.environmentBanner` (`0xFFFDE047`). Comparar visualmente a faixa antes e depois com o app sem `APP_ENV` (padrão dev) em 390 e 1280. Arquivos: `environment_banner.dart`, `app_colors.dart`, teste da faixa se existir. Atende: CA7.
  - Nota: estilo `typography.of(context).small` com peso 600 (14 px, Figtree no lugar da Aleo) e texto em `colors.ink` no lugar de `gray900`; fundo é `colors.environmentBanner`. Comparação visual na conferência final (G2).
- [x] **B2.** Em `app_typography.dart`, apagar `headline`, `title`, `body`, `label`, `TypographyStyle` e `TypographySize`, deixando `of(context)`; tirar o import de `google_fonts` e de `num_extension` de `app_theme.dart`. Antes, `grep -rnE "typography\.(headline|title|body|label)\b|TypographyStyle|TypographySize" lib test` só pode achar a própria definição. Atende: CA3.
- [x] **B3.** Apagar `lib/core/utils/extensions/num_extension.dart` (e a pasta vazia). Atende: CA3.
- [x] **B4.** `pubspec.yaml`: remover `google_fonts` e a família `Aleo`; apagar `assets/fonts/Aleo-*.ttf` (7). `pub get`. Conferir que a pasta `assets/fonts/licenses` fica (só Bricolage e Figtree). Gate: `analyze`, `test`, `build web`; `grep -rniE "aleo|google_fonts|GoogleFonts|num_extension" lib test pubspec.yaml assets` sem resultado (o `pubspec.lock` não deve listar `google_fonts` como direta). Commit do grupo. Atende: CA1, CA3, CA9.
  - Nota: o `pubspec.lock` só perdeu `google_fonts`; os bumps de transitivos feitos pelo editor foram descartados.

## Grupo C: tokens e dados mortos
- [x] **C1.** Apagar `ContentType.color` (`content_model.dart`); remover o campo `color` do construtor de `ThemeModel` e `SubthemeModel`; remover por script as 35 linhas `color:` de `lib/core/content/*/*.dart` (os quatro arquivos de tema). Conferir `git diff --stat` (só linhas `color:` nesses arquivos) e que `bin/content_seed_data.json` e `bin/` não mudaram. Atende: CA6, CA10.
  - Nota: os testes de tema e subtema deixaram de passar `color:` (`theme_overview_card_test`, `theme_header_stats_test`, `theme_subthemes_section_test`).
- [x] **C2.** Em `app_colors.dart`, apagar `primary*`, `secondary*`, `light*`, `dark*`, `mediumGray`, `white` **só se** a busca mostrar zero uso (`white` e `black` têm uso real: ficam), a escala `gray50`..`gray800` e os `Color` sem referência; conferir cada nome com `grep -rnw nome lib test`. Atende: CA6.
  - Nota: `gray900` também saiu (único uso era a faixa, que passou a `ink`); `white` e `black` ficam. Removidos também `lightOrange`, `secondaryYellow`, `lightBlue`, `lightGray` e as cores sem uso.
- [x] **C3.** Em `app_gradients.dart`, apagar `primaryGradient`, `cardGradient`, `blueGradient`, `greenGradient`, `redGradient`, `grayGradient`, deixando `brand`. Em `app_dimensions.dart`, apagar `space` e `radius` (e o `DimensionStyle` só se `stroke` não precisar dos oito campos: caso precise, manter a classe). Conferir ausência de prefixo provisório com `grep -rnEi "\b(new|v2|legacy|old)[A-Z_]" lib/core/theme`. Atende: CA6.
  - Nota: `DimensionStyle` ficou com os oito campos porque `stroke` os declara; só `space` e `radius` saíram.
- [x] **C4.** Gate do grupo C: `analyze`, `test`, `build web`; `grep -rnE "primaryOrange|secondaryOrange|primaryBlue|primaryGreen|primaryRed|mediumGray|primaryGradient|blueGradient|dimensions\.(space|radius)\b" lib test` sem resultado; `grep -rn "color:" lib/core/content` sem resultado. Commit. Atende: CA1, CA6.

## Grupo D: pacotes (um grupo por vez, com build entre eles)
- [x] **D1.** Remover `syncfusion_flutter_pdfviewer` e `youtube_player_iframe` (os mais pesados). Confirmar `grep -rn "syncfusion\|youtube_player" lib test bin tool` vazio; `pub get`; `fvm flutter clean` na cópia ASCII; `analyze`, `test`, `build web`. Revisar o diff do `pubspec.lock` (saída de transitivos órfãos, nenhuma subida de versão de outro pacote). Atende: CA5.
  - Nota: build/web 48700 KB depois da remoção; o lock só perdeu pacotes (syncfusion_*, webview_*, youtube_*, device_info_plus, intl).
- [x] **D2.** Remover `carousel_slider`, `flutter_staggered_grid_view`, `flutter_animate`, `font_awesome_flutter`. Mesma conferência de D1. Atende: CA5.
  - Nota: build/web 48000 KB.
- [x] **D3.** Remover `cached_network_image`, `http` e `cupertino_icons` (conferir `CupertinoIcons` e `package:http` por `grep` em `lib test bin tool`). Mesma conferência de D1. Manter `flutter_svg`, `url_launcher`, `dartz`, `freezed_annotation`, `flutter_web_plugins`. Atende: CA5.
  - Nota: `http` também era dependência direta, mas continua no lock como transitivo (Firebase); build/web 47976 KB.
- [x] **D4.** Gate do grupo D: `grep` de cada nome de pacote removido em `pubspec.yaml` e em `import` sem resultado; `pubspec.lock` sem eles como `direct`. Commit do grupo (ou um por tarefa, se o lock ficar grande). Atende: CA1, CA5.
  - Nota: nenhum dos pacotes removidos consta como `direct` no lock.

## Grupo E: assets
- [ ] **E1.** Em `app_images.dart`, apagar as entradas `logo` e `observatorio`; para cada entrada restante, confirmar por `grep` que há uso (ilustrações de tema e subtema, logos de apoio) e anotar quais não têm. Apagar `logo.png` e `observatorio.png`. Atende: CA8.
- [ ] **E2.** Apagar os 42 PNGs substituídos de `assets/images/` (36 ilustrações e `capes`, `cnpq`, `faced`, `fapemig`, `ppged`, `ufu`, inclusive `cultura_política.png`, que tem acento e par `cultura_politica.webp`). Ficam `logo_simple.png`, `observatorio_simbolo.svg` e todos os `.webp`. Atende: CA8.
- [ ] **E3.** Apagar `tool/images/` (gerador e `to_webp.html`). Conferir que nada em `README.md`, `docs/` ou workflows chama `tool/images`. Atende: CA9.
- [ ] **E4.** Auditar `assets/`: para cada arquivo restante, `grep` do nome em `lib test web tool`; `assets/icons/{facebook,instagram,youtube}.svg` seguem pelo rodapé (nome montado em texto); `assets/fonts/licenses` fica. `pubspec.yaml` só com `assets/images/`, `assets/icons/` e as famílias Bricolage Grotesque e Figtree. Atende: CA8, CA9.
- [ ] **E5.** Gate do grupo E: `analyze`, `test`, `build web`, e abrir Home (anel dos temas), um tema, um subtema, Sobre (logos de apoio) e o rodapé no navegador em 390 e 1280, sem imagem quebrada nem erro de asset no console. Commit. Atende: CA1, CA8, CA11.

## Grupo F: documentação
- [ ] **F1.** Apagar `lib/features/theme/REFACTORING_SUMMARY.md`. Atende: CA12.
- [ ] **F2.** No `README.md`, corrigir só o que ficou falso: tirar carrossel, paginação por cursor e `ContentPaginationState` (a seção "Tratamento de erros" passa a usar um exemplo do catálogo ou um texto sem código), a frase "tokens novos convivem com os antigos", a lista de componentes que não existem mais (`PrimaryButton` etc.) e `google_fonts`/`Aleo`, se citados. Conferir com `grep -niE "carrossel|carousel|paginação|cursor|ContentPagination|google_fonts|aleo|convivem" README.md` sem resultado. Não reescrever o resto (spec 018). Atende: CA12.

## Grupo G: conferência final
- [ ] **G1.** Cópia ASCII limpa (`flutter clean`, `pub get`): `fvm flutter analyze` sem avisos, `fvm flutter test` passando, `fvm dart format --set-exit-if-changed` nos `.dart` alterados, `fvm flutter build web --release`; anotar `du -sk build/web` (**depois**) e conferir que é menor que o de 0.1. Atende: CA1, CA2.
- [ ] **G2.** Rodar o app (`fvm flutter run -d chrome`, ou build servido) e percorrer em 390, 768 e 1280 px: `/`, `/natureza-meio-ambiente`, `/natureza-meio-ambiente/biomas`, um objeto, `/sobre`, `/contato`, `/rota-que-nao-existe` (404), `/admin`, lista e temas do painel e o editor de objeto (criar e editar abrem; sem credenciais, conferir com a autenticação simulada dos testes). Sem rolagem horizontal, sem `overflow` e sem erro no console; faixa de ambiente de testes visível no padrão dev. Atende: CA7, CA11.
- [ ] **G3.** Greps finais, todos sem resultado: `grep -rniE "aleo|google_fonts|GoogleFonts|num_extension" lib test pubspec.yaml assets`; a regex do gate A5; a regex do gate C4; nomes dos pacotes removidos em `pubspec.yaml` e `lib test bin tool`. `git diff --stat main...HEAD -- firestore.rules firestore.indexes.json firebase.json bin lib/core/navigation` vazio. Atende: CA3, CA4, CA5, CA6, CA10.
- [ ] **G4.** Status da spec para `implementada`; entregar os números (tamanho antes e depois, testes) para a etapa de verificação escrever o `verificacao.md`. Atende: CA2.
