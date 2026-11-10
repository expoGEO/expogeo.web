# Plano da 016. Limpeza: código, tokens, fontes, pacotes e assets sem uso

- **Spec:** spec.md
- **Criado em:** 2026-11-09

## Abordagem
Remoção em grupos pequenos e ordenados pela dependência, nunca por suposição: antes de apagar qualquer coisa, a tarefa faz `grep` do nome da classe e do nome do arquivo em `lib/`, `test/`, `bin/` e `tool/`. Depois de cada grupo rodam `analyze` e os testes (e, nos grupos de pacote e de asset, o build web), e o app volta a compilar antes do commit.

Ordem: **primeiro o código** que consome os tokens (componentes antigos), **depois a tipografia e a Aleo**, **depois os tokens** e **só por último pacotes e assets**, porque um pacote ou arquivo só pode sair quando o último `import`/referência já saiu. Pacotes entram depois do código por isso, e assets depois dos pacotes para o `build web` de cada passo continuar comparável.

Pontos de atenção do estado real:
- Os componentes antigos formam uma cadeia (`primary_button` e `secondary_button` usam `circular_loading`, `app_icon`, `AppIcons` e `num_extension`; `app_icon` usa `flutter_svg`). Removem-se juntos, do consumidor para o consumido, no mesmo grupo.
- O `EnvironmentBanner` ainda usa `AppTheme.typography.label` e `colors.primaryYellow`. Ele é migrado **antes** de apagar a tipografia antiga e a cor.
- `ThemeModel.color`, `SubthemeModel.color` e `ContentType.color` só existem para alimentar seis cores antigas. Saem antes das cores. As 35 linhas `color:` dos quatro arquivos de `lib/core/content/*/*.dart` são removidas por script, conferindo o `git diff` (só essas linhas).
- `google_fonts` e a Aleo saem juntos: `GoogleFonts.aleo` é o último uso do pacote, e o `app_theme.dart` importa os dois.
- `tool/images/generate_webp.sh` lê os PNGs; sai com eles.
- O `pubspec.lock` muda a cada remoção de pacote. Aceitar só o que a remoção causar (dependência direta e seus transitivos órfãos); se `pub get` mexer em versão de outro pacote, restaurar essa linha do lock.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Apagar | `lib/core/components/button/{primary_button,secondary_button,rounded_icon_button,back_to_button,checkbox_button}.dart` | Botões antigos sem uso |
| Apagar | `lib/core/components/loading/circular_loading.dart` | Só os botões antigos o usam |
| Apagar | `lib/core/components/field/{app_text_field,app_dropdown_field}.dart` | Campos antigos sem uso |
| Apagar | `lib/core/components/image/{app_network_image,app_asset_image}.dart` | Sem uso; o primeiro era o único a usar `cached_network_image` |
| Apagar | `lib/core/components/icon/{app_icon,rounded_app_icon}.dart`, `lib/core/utils/enums/app_icons.dart` | Sem uso |
| Apagar | `lib/core/components/card/rounded_card.dart`, `lib/core/utils/validators/validators.dart` | Sem uso (`FormValidators` fica) |
| Alterar | `lib/core/components/environment/environment_banner.dart` | Passa a usar estilo de `typography.of(context)` e um token novo de cor |
| Alterar | `lib/core/theme/app_typography/app_typography.dart` | Fica só com `of(context)`; saem os estilos antigos, `TypographyStyle`, `TypographySize` |
| Alterar | `lib/core/theme/app_theme.dart` | Sai o import de `google_fonts` e de `num_extension` |
| Apagar | `lib/core/utils/extensions/num_extension.dart` | Sem uso depois dos grupos A e C |
| Alterar | `lib/core/theme/app_colors/app_colors.dart` | Saem as cores antigas; entra o token da faixa de ambiente |
| Alterar | `lib/core/theme/app_gradients/app_gradients.dart` | Fica só `brand` |
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Saem `space` e `radius`; `stroke` fica |
| Alterar | `lib/core/models/{content_model,theme_model,subtheme_model}.dart` | Saem `ContentType.color` e o campo `color` |
| Alterar | `lib/core/content/*/*.dart` (4 arquivos de tema) | Saem as 35 linhas `color:` |
| Alterar | `lib/core/utils/enums/app_images.dart` | Saem `logo` e `observatorio`; confere cada entrada restante |
| Alterar | `pubspec.yaml`, `pubspec.lock` | Pacotes e fontes que saem |
| Apagar | `assets/fonts/Aleo-*.ttf` (7), 44 PNGs de `assets/images/`, `tool/images/` | Sem uso |
| Apagar | `lib/features/theme/REFACTORING_SUMMARY.md` | Descreve a paginação extinta |
| Alterar | `README.md` | Só o que ficou falso |
| Criar | `docs/specs/016-limpeza-legado/verificacao.md` | Pela etapa de verificação, com os dois tamanhos de build |

## Decisões técnicas
- **Cópia ASCII para ferramentas.** `fvm flutter analyze/test/build` quebram no caminho com "ó". Cada tarefa edita na pasta original e sincroniza com `rsync -a --delete --exclude build --exclude .dart_tool --exclude '.git' --exclude 'bin/venv'` para uma cópia no scratchpad, onde roda os comandos. Nunca copiar de volta.
- **`pubspec.lock`.** Entra no commit do grupo de pacote que o alterou, revisado linha a linha.
- **Tamanho do build.** Medido com `du -sk build/web` num `build web --release` limpo da cópia ASCII, antes (tarefa 0) e depois (tarefa final), com o mesmo comando. O `build/web` que está na pasta é antigo e não vale como base.
- **Token do amarelo da faixa.** Entra como `environmentBanner` (e `environmentBannerText` só se o estilo atual usar cor própria) em `AppColors`, com o mesmo valor `0xFFFDE047`. A aparência não muda.
- **Alternativas descartadas.** Manter o campo `color` dos modelos "por segurança": deixaria seis cores antigas vivas. Remover tudo num commit só: dificulta achar qual remoção quebrou. Reescrever o README inteiro agora: é a spec 018.
- **Commits.** Um por grupo (A a F), mensagens `chore: ...` ou `refactor: ...` em português.

## Dependências e geração de código
Nenhum pacote entra. Saem: `flutter_animate`, `carousel_slider`, `font_awesome_flutter`, `flutter_staggered_grid_view`, `youtube_player_iframe`, `syncfusion_flutter_pdfviewer`, `http`, `cupertino_icons`, `cached_network_image`, `google_fonts`. `build_runner` só se algum `.g.dart` ou `.freezed.dart` ficar defasado (não deve; nenhuma store ou modelo gerado muda). Depois de tirar plugins, `fvm flutter clean` e `pub get` na cópia ASCII. Nenhuma rota muda.

## Riscos e cuidados
- **Remoção do que parecia órfão e é usado dinamicamente:** assets e ícones por nome montado em texto (`AppImages.path`, `'assets/icons/${icon}.svg'` no rodapé). Conferir à mão e abrir Home, tema, rodapé e Sobre no navegador depois do grupo E.
- **`flutter_svg` e `url_launcher` ficam.** Não os remover por engano ao tirar `app_icon`.
- **Teste que referencia código removido.** Hoje `grep` não acha, mas conferir de novo em cada grupo; teste que só exercitava código morto é removido junto, dizendo isso no commit.
- **Faixa de ambiente:** só aparece com `APP_ENV=dev`. Conferir rodando o app sem define (padrão dev) e olhando a faixa antes e depois.
- **Dependência de pacote com plugin web:** `youtube_player_iframe` e `syncfusion_flutter_pdfviewer` trazem plugins; o `build web` do grupo B é o que prova.
- **Pasta com "ó":** nada do que roda no `Bash` depende de `flutter` na pasta original.

## Como conferir
Na cópia ASCII: `fvm flutter pub get`, `fvm flutter analyze`, `fvm flutter test`, `fvm dart format --set-exit-if-changed` nos `.dart` alterados, `fvm flutter build web --release` e `du -sk build/web`. Depois `fvm flutter run -d chrome` (ou o `web-server` com o navegador embutido) em 390, 768 e 1280 px: Home, `/natureza-meio-ambiente`, subtema `/natureza-meio-ambiente/biomas`, objeto, `/sobre`, `/contato`, um endereço inexistente (404), `/admin`, painel (lista e temas) e editor, procurando rolagem horizontal e erros no console. Buscas finais por `grep` listadas na tarefa G3.
