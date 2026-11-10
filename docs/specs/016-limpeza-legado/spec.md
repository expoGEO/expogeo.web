# 016. Limpeza: código, tokens, fontes, pacotes e assets sem uso

- **Status:** aprovada
- **Item do planejamento:** Fase 5, itens 5.1 e 5.2
- **Protótipo:** não se aplica
- **Criada em:** 2026-10-27

> Referência no Observatório: `docs/specs/027-remocao-codigo-legado/` e `028-assets-sem-uso/`. Aqui as duas vão juntas porque o volume é menor.

## Objetivo
Tirar do projeto tudo o que o redesign deixou sem uso, para o código ficar menor, o build mais leve e ninguém usar por engano um token ou componente antigo. Quem usa o site **não vê mudança**.

## Situação atual
Conferida por busca no código em 2026-11-09, depois das Fases 0 a 4.

**Já saiu nas fases anteriores** (não entra na limpeza): `themes_row`, `theme_card`, `home_banner`, `logo`, `subtheme_card`, `subtheme_banner`, `subtheme_content`, `content_card`, `content_grid`, `content_form_dialog`, `content_list`, `theme_subtheme_selector`, `ContentPaginationStore`, o `content_theme_datasource` e a paginação por cursor, `ContentError` e `ContentEmpty`. Os botões antigos do painel foram trocados pelos novos na Fase 4.

**Componentes e utilitários que nenhuma tela usa** (só se referenciam entre si ou nada os importa):
- Botões: `primary_button`, `secondary_button`, `rounded_icon_button`, `back_to_button`, `checkbox_button`.
- Campos: `app_text_field`, `app_dropdown_field`.
- Imagens e ícones: `app_network_image`, `app_asset_image`, `app_icon`, `rounded_app_icon` e o enum `AppIcons` (`utils/enums/app_icons.dart`).
- Outros: `rounded_card`, `circular_loading` (só os botões antigos o usam) e a classe `Validators` (`utils/validators/validators.dart`; o `FormValidators` fica, é o que Contato e login usam).

**Fonte Aleo e tipografia antiga:** `AppTypography` ainda tem os estilos antigos (`headline`, `title`, `body`, `label`) em `GoogleFonts.aleo` com `num_extension`. Só os componentes antigos e o `EnvironmentBanner` (usa `label`) os consomem. As sete fontes `Aleo-*.ttf` estão em `assets/fonts/` e declaradas no `pubspec.yaml`.

**`num_extension`:** 11 arquivos o importam; 9 são os componentes antigos acima, os outros dois são `app_theme.dart` e `app_typography.dart`.

**Tokens antigos** (sem uso fora dos componentes antigos):
- Cores: `secondaryOrange`, `lightOrange`, `darkOrange`, `secondaryYellow`, `lightBlue`, `secondaryGreen`, `darkGray`, `lightGray` e a escala `gray50` a `gray800`.
- Cores ainda lidas, mas só por dados mortos: `primaryOrange`, `primaryBlue`, `secondaryBlue`, `primaryGreen`, `primaryRed`, `secondaryRed` e `mediumGray` aparecem em `ContentType.color` (ninguém lê) e no campo `color` de `ThemeModel` e `SubthemeModel` (35 linhas `color:` nos quatro arquivos de `lib/core/content/*/`; ninguém lê o campo, e ele não é gravado no Firestore). `primaryYellow` é o fundo da faixa de ambiente de testes (`EnvironmentBanner`), que continua e precisa de um token com nome próprio.
- Gradientes: `primaryGradient`, `cardGradient`, `blueGradient`, `greenGradient`, `redGradient`, `grayGradient`. Só `brand` é usado.
- Dimensões: `AppDimensions.space` e `.radius` (a escala `mini`…`gigantic`) sem uso; `.stroke` ainda é usado em dezenas de arquivos e fica.

**Pacotes sem nenhum `import` em `lib/`, `test/`, `bin/` ou `tool/`:** `flutter_animate`, `carousel_slider`, `font_awesome_flutter`, `flutter_staggered_grid_view`, `youtube_player_iframe`, `syncfusion_flutter_pdfviewer`, `http`, `cupertino_icons`. `cached_network_image` só é usado pelo `app_network_image`, então sai junto com ele. `google_fonts` só pela tipografia antiga. **Ficam:** `flutter_svg` (footer, cartão do Observatório), `url_launcher`, `dartz`, `freezed_annotation`, `flutter_web_plugins`, Firebase, MobX, GetIt, `go_router`.

**Assets:**
- `assets/images/` tem 42 PNGs e 42 WebP. Os PNGs das ilustrações e dos logos de apoio (36 ilustrações e 6 logos: `capes`, `cnpq`, `faced`, `fapemig`, `ppged`, `ufu`) foram substituídos pelos WebP. `logo_simple.png` é usado (`AppImages.logoSimple`) e fica; `logo.png` e `observatorio.png` têm entrada em `AppImages`, mas nenhum código as lê.
- O `tool/images/generate_webp.sh` (e `to_webp.html`) lê esses PNGs como origem; sem eles, o gerador perde o sentido.
- `assets/icons/` (`facebook`, `instagram`, `youtube`) é usado pelo rodapé por nome montado em texto; o enum `AppIcons` que também os nomeava sai.
- `lib/features/theme/REFACTORING_SUMMARY.md` descreve a paginação por cursor, que não existe mais.

**README.md:** ainda cita carrossel, paginação por cursor, `ContentPaginationState`, "tokens novos convivem com os antigos" e outros pontos desatualizados.

**Testes:** a pasta `test/` existe (cerca de 700 testes) e é a rede de segurança desta limpeza.

## Comportamento

### Código
- Remover os componentes, enums e utilitários da lista acima, conferindo por busca (nome da classe e nome do arquivo) antes de cada remoção, não por suposição.
- Trocar o `EnvironmentBanner` para o sistema novo (estilo de `AppTheme.typography.of(context)` e um token de cor com nome próprio para o amarelo da faixa), mantendo a aparência.
- Remover a tipografia antiga (`headline`, `title`, `body`, `label`, `TypographyStyle`, `TypographySize`), a Aleo e o `GoogleFonts`.
- Remover `num_extension` e seu import em `app_theme.dart`.
- Remover `ContentType.color` e o campo `color` de `ThemeModel` e `SubthemeModel`, com as 35 linhas `color:` dos arquivos de conteúdo. O conteúdo de seed continua igual no resto.
- Remover os tokens antigos de cor, gradiente e `space`/`radius`. Não há prefixo provisório a renomear nos tokens novos (conferir por busca por `new`, `v2`, `legacy`, `old`).
- Regerar com `build_runner` o que mudar (MobX/Freezed), se algo mudar.

### Pacotes
- Tirar do `pubspec.yaml` os pacotes sem uso, em grupos pequenos. Cada grupo é conferido com `analyze`, testes e build web.
- O `pubspec.lock` acompanha as remoções; transitivos que mudem por outro motivo que não a remoção são restaurados.

### Assets
- Remover os 42 PNGs substituídos (36 ilustrações e 6 logos de apoio), `logo.png` e `observatorio.png`, e as entradas correspondentes em `AppImages`. Fica `logo_simple.png`.
- Remover as sete fontes Aleo. `pubspec.yaml` declara só o que fica (Bricolage Grotesque, Figtree, `assets/images/`, `assets/icons/`).
- Remover `tool/images/` (gerador de WebP sem origem). `tool/web_icons/` fica.
- Todo arquivo restante de `assets/` precisa ter referência no código (inclusive por nome montado em texto, conferido à mão).

### Documentação
- Apagar `lib/features/theme/REFACTORING_SUMMARY.md`.
- Corrigir no `README.md` só o que ficou falso (carrossel, paginação, tokens antigos, componentes removidos). A reescrita enxuta do README e dos demais `.md` é da spec 018.

## Estados
Não se aplica.
- **Casos de borda:** builds locais antigos podem precisar de `fvm flutter clean` depois de tirar plugins; asset usado só por nome montado em texto (`'assets/icons/${icon}.svg'`, `AppImages.path`) é conferido à mão; `bin/seed_firestore_utils.dart` e os scripts de seed não são tocados.

## Responsivo
Não se aplica; as telas ficam iguais.

## Acessibilidade
Não se aplica; nada visível muda.

## Dados e regras de negócio
- Nenhum dado, rota, regra do Firestore ou comportamento muda. O campo `color` removido é só do modelo em memória e nunca foi gravado.
- Conteúdo de seed em `lib/core/content/` e `bin/` **fica** (só perde as linhas `color:`).

## Critérios de aceite
- [ ] 1. `fvm flutter analyze` sem avisos e `fvm flutter test` passando, em cópia de caminho ASCII.
- [ ] 2. `fvm flutter build web --release` passa e `build/web` fica menor que o build feito antes da limpeza; os dois tamanhos (em KB, `du -sk`) são anotados no `verificacao.md`.
- [ ] 3. Nenhuma referência a `Aleo`, `google_fonts`, `GoogleFonts`, `num_extension` nem à extensão `.fontSize(` em `lib/`, `test/`, `pubspec.yaml` e `assets/`.
- [ ] 4. Os componentes e utilitários listados (botões, campos, imagens, ícones, `rounded_card`, `circular_loading`, `AppIcons`, `Validators`) não existem e nenhum nome deles aparece em `lib/` e `test/`.
- [ ] 5. Os pacotes removidos não aparecem no `pubspec.yaml`, no `pubspec.lock` (como dependência direta) nem em `import`; os que ficam continuam importados.
- [ ] 6. Os tokens antigos listados (cores, gradientes, `space`, `radius`, tipografia antiga) não existem; `ContentType.color` e o campo `color` de `ThemeModel`/`SubthemeModel` também não, e `lib/core/content/` não tem linha `color:`.
- [ ] 7. A faixa de ambiente de testes (`EnvironmentBanner`) tem a mesma aparência de antes, agora com token e estilo do sistema novo.
- [ ] 8. Nenhum arquivo de `assets/` sem referência no código; os 42 PNGs substituídos, `logo.png`, `observatorio.png` e as fontes Aleo saíram; `logo_simple.png` e os três ícones continuam.
- [ ] 9. `pubspec.yaml` declara só as fontes e pastas de assets que ficam; `tool/images/` saiu.
- [ ] 10. `git diff` da entrega não toca `firestore.rules`, `firestore.indexes.json`, `firebase.json`, `bin/`, `lib/core/navigation/` e as rotas, nem os modelos gravados no Firestore (`ContentModel` só perde `ContentType.color`).
- [ ] 11. Home, temas, subtemas, objeto, Sobre, Contato, 404, login, painel (lista, temas) e editor abrem e funcionam como antes em 390, 768 e 1280 px, sem rolagem horizontal e sem `overflow` no console.
- [ ] 12. `REFACTORING_SUMMARY.md` apagado e o `README.md` sem menção a carrossel, paginação por cursor, `ContentPaginationState`, componentes removidos ou "tokens antigos".

## Fora do escopo
- Reescrita enxuta do README e dos demais `.md` (spec 018) e revisão de comentários (spec 017).
- Mudanças de dados, de rotas, do painel e dos scripts de seed.
- Trocar de pacote ou atualizar versões.
- O bloco `scripts:` do `pubspec.yaml` (usado por ferramenta externa de scripts) e a limpeza de `pubspec.lock` além do que as remoções causarem.

## Perguntas em aberto
- Nenhuma.
- Decidido no modo autônomo: remover o campo `color` de `ThemeModel`/`SubthemeModel` e as 35 linhas dos arquivos de conteúdo, porque ninguém o lê e ele não é gravado; deixá-lo manteria seis cores antigas vivas só por causa de dados mortos.
- Decidido no modo autônomo: remover `tool/images/` junto com os PNGs, porque o gerador de WebP tem os PNGs como origem e ficaria quebrado; o histórico fica no git.
- Decidido no modo autônomo: manter `AppDimensions.stroke` (em uso) e remover só `space` e `radius`.
- Decidido no modo autônomo: remover `cupertino_icons` (nenhum `CupertinoIcons` no código), porque não há uso e a limpeza de pacotes cobre tudo o que está sem `import`.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
- 2026-11-09: revisada contra o código depois das Fases 0 a 4 (busca por uso). Saíram da lista o que as fases anteriores já removeram (`themes_row`, `theme_card`, cartões e listas antigas, `ContentPaginationStore`, `content_theme_datasource`, `ContentError`, `ContentEmpty`); entraram os componentes que seguiam sem uso (botões, campos e imagens antigos, `AppIcons`, `Validators`), a tipografia antiga, `ContentType.color` e o campo `color` dos modelos, `tool/images/`, `logo.png`, `observatorio.png` e `cupertino_icons`. Corrigido "não há pasta `test/`" (ela existe). Critérios numerados e README limitado a corrigir o que ficou falso. Continua aprovada.
