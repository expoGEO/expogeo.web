# Plano da 001. Fundação visual (tokens, fontes e breakpoints)

- **Spec:** spec.md
- **Criado em:** 2026-10-27

## Abordagem
Portar para a expoGEO a fundação do redesign do Observatório (`../observatorio_geo_hist/lib/app/theme/` e `lib/app/core/utils/screen/screen_utils.dart`), **somando** ao tema atual sem mexer em nada que já existe. As classes antigas (`AppColors`, `AppDimensions`, `AppTypography`, `AppGradients`, `ScreenUtils`) ganham campos e métodos novos com nomes que não existem hoje; nenhum campo atual muda de valor, de tipo ou de nome. Assim as telas atuais e o painel continuam idênticos, e as specs 002 em diante passam a construir em cima dos tokens novos.

A tipografia nova segue o modelo do Observatório: uma classe `AppTextStyles` resolvida pela faixa de largura (`AppTheme.typography.of(context)`), com tamanhos fixos por faixa, `fontFamily` das fontes embutidas e nada de `google_fonts` ou `num_extension`. As faixas viram um `enum Breakpoint` com `fromWidth`, que é a única regra de corte (599/600 e 1023/1024) e é coberta por teste unitário. A largura de conteúdo entra como constante e um componente `PageContent`, copiado do Observatório, para que todo conteúdo novo use a mesma caixa de 1120 px com margens de 20/32 px.

A conferência visual usa uma tela de teste temporária com ponto de entrada próprio (`-t`), fora do roteador e fora do git, para não tocar em rotas nem no `main.dart`.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `assets/fonts/BricolageGrotesque-{SemiBold,Bold,ExtraBold}.ttf` | Títulos (600, 700, 800), copiados do Observatório |
| Criar | `assets/fonts/Figtree-{Regular,Medium,SemiBold,Bold}.ttf` | Texto (400 a 700), copiados do Observatório |
| Criar | `assets/fonts/licenses/OFL-BricolageGrotesque.txt`, `OFL-Figtree.txt` | Licenças OFL, copiadas do Observatório |
| Alterar | `pubspec.yaml` | Declarar as famílias `BricolageGrotesque` e `Figtree` ao lado da `Aleo` |
| Alterar | `lib/core/theme/app_theme.dart` | `part` do `app_text_styles.dart` e import do `screen_utils.dart` (para `Breakpoint`) |
| Alterar | `lib/core/theme/app_colors/app_colors.dart` | Cores novas da tabela da spec |
| Alterar | `lib/core/theme/app_gradients/app_gradients.dart` | Degradê `brand` da expoGEO |
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | `spacing`, `radii`, `shadows`, `focus` (classes `SpacingScale`, `RadiiScale`, `ShadowStyle`, `FocusStyle`) |
| Criar | `lib/core/theme/app_typography/app_text_styles.dart` | `AppTextStyles` por faixa (h1, h2, h3, reading, regular, small, label, code) |
| Alterar | `lib/core/theme/app_typography/app_typography.dart` | Método `of(BuildContext)` que devolve `AppTextStyles` |
| Alterar | `lib/core/utils/screen/screen_utils.dart` | `enum Breakpoint`, `contentMaxWidth`, `breakpointOf`, `contentMargin`; funções atuais intactas |
| Criar | `lib/core/components/structure/page_content.dart` | Caixa de conteúdo de 1120 px centralizada com margem por faixa |
| Criar | `test/core/utils/screen/breakpoint_test.dart` | Faixas e margens em 390, 599, 600, 768, 1023, 1024 e 1280 px |
| Criar (temporário, fora do git) | `lib/dev/foundation_preview_main.dart` | Tela de teste dos tokens; listada em `.git/info/exclude` e apagada ao fim da verificação |

## Decisões técnicas
- **Nomes novos, iguais aos do Observatório.** Cores: `page`, `surface`, `ink`, `inkSecondary`, `line`, `accent`, `accentStrong`, `accentSoft`, `footerBackground`, `footerLine`, `footerText`, `footerHighlight`, `error`, `errorSurface`, `success`, `successSurface`. Dimensões: `spacing.s4…s96`, `radii.r6…r20` e `pill`, `shadows.soft` e `shadows.elevated`, `focus.width/offset/color`. Nenhum colide com os antigos (`space`, `radius`, `stroke`, `primaryOrange`…). Alternativa descartada: prefixo (`newAccent`, `v2…`), que atrapalharia copiar componentes do Observatório e ficaria estranho depois da limpeza (spec 016).
- **Escala de espaçamento** com os valores do Observatório: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 96. **Sombras:** só `soft` e `elevated`, que a spec pede; as demais do Observatório entram quando algum componente precisar.
- **Degradê:** `AppGradients.brand`, cores `#F97316 → #FB923C → #FACC15` com paradas 0 / 0,45 / 1 e o ângulo de 120° do protótipo (`GradientRotation` de 30° sobre o eixo horizontal). O `primaryGradient` antigo termina em `#FDE047` e fica como está.
- **Tipografia por faixa via `AppTheme.typography.of(context)`**, como no Observatório. Tamanhos: h1 32/40/52 (800), h2 26/30/36 (700), h3 18/20/20 (700), reading 17/18/18, regular 16, small 14, label 12,5/12,5/13 (700), code 13,5. Fallback `['system-ui', 'Roboto', 'Arial']`.
- **Estilo do código de referência (`code`) em Figtree 600 com algarismos tabulares**, e não em fonte monoespaçada do sistema. Motivo: o Flutter web (CanvasKit) não acessa fontes do sistema; `monospace` cairia na Roboto baixada da internet, proporcional. Embutir uma monoespaçada acrescentaria de 120 a 270 KB por peso ao carregamento inicial (o Flutter web baixa todas as fontes do `pubspec` na abertura). A spec foi ajustada (ver "Histórico de mudanças"); se a 009 ou a 014 exigirem monoespaçada de fato, uma fonte OFL é embutida nessa hora.
- **"Sem internet" das fontes** passa a ser conferido como "nenhuma requisição a `fonts.googleapis.com`/`fonts.gstatic.com` para Bricolage ou Figtree, e os `.ttf` vêm de `assets/fonts/`". O app inteiro não abre sem rede (o CanvasKit vem de CDN), então o teste literal não faz sentido. Também registrado na spec.
- **Breakpoint num `enum` com `fromWidth`**, no mesmo arquivo do `ScreenUtils`, como no Observatório. `isMobile`, `isTablet`, `isDesktop`, `isLaptop`, `isSmallMobile` e `isSmallDesktop` ficam com a mesma lógica.
- **Teste unitário das faixas** (primeira pasta `test/` do projeto). Alternativa: só olhar na tela de teste; descartada porque 599 e 1023 px são fáceis de errar a olho e o teste custa pouco. Usa só `flutter_test`, que já está nas dependências de desenvolvimento.
- **Tela de teste com ponto de entrada próprio** (`fvm flutter run -t lib/dev/foundation_preview_main.dart`), um `MaterialApp` simples sem Firebase. Fica fora do git via `.git/info/exclude` (arquivo local, não versionado) e é apagada pelo `/sdd-verify` depois de anotar o resultado. Alternativa descartada: rota temporária no `AppRouter`, que mexeria em rotas.
- **Sem foco visual em componente agora.** A spec pede o token de foco; o anel de foco (`AppFocusRing` do Observatório) entra com os botões na 002.

## Dependências e geração de código
- Nenhum pacote novo. Nenhuma mudança de `build_runner`, de rota, de `*_setup.dart` ou de modelo.
- Assets: 7 `.ttf` e 2 licenças copiados de `../observatorio_geo_hist/assets/fonts/`; famílias declaradas em `flutter: fonts:` do `pubspec.yaml`.
- `test/` nova, rodada com `fvm flutter test` na cópia em caminho ASCII.

## Riscos e cuidados
- **Regressão nas telas atuais:** só os arquivos da tabela mudam e nenhum valor antigo é tocado; conferir com `git diff` (apenas linhas adicionadas no tema e no `ScreenUtils`) e comparar capturas antes/depois de Home, página de tema, página de subtema, Contato, 404 e login.
- **Painel admin:** não há credenciais de teste; fica "não conferido na tela". A garantia é estrutural (nenhum arquivo do painel muda e os tokens antigos ficam iguais).
- **Peso inicial:** as 7 fontes novas somam cerca de 420 KB, baixados na abertura mesmo pelas telas antigas, que ainda não as usam. Aceito: as telas novas vêm nas próximas specs, e a Aleo (com `google_fonts`) sai na 016.
- **Import circular** `app_theme.dart` ↔ `screen_utils.dart`: permitido em Dart e já usado assim no Observatório; o `analyze` confirma.
- **Caminho com "ó":** `analyze` e `test` só rodam na cópia ASCII do scratchpad (rsync sem `build/` e `.dart_tool/`, depois `pub get`).
- **Specs 009 e 014** falam em fonte monoespaçada para o código; ver a decisão do estilo `code`.

## Como conferir
- `fvm flutter analyze` e `fvm flutter test` na cópia ASCII: sem avisos (linha de base em 2026-10-27: "No issues found!").
- `fvm flutter build web --release -t lib/dev/foundation_preview_main.dart`, servir `build/web` e abrir no navegador embutido em 390, 599, 600, 768, 1023, 1024 e 1280 px (e 1440 para o centro de 1120 px).
- Pelo menos uma vez em debug (`fvm flutter run -d web-server --web-port <porta> -t lib/dev/foundation_preview_main.dart`) para ver asserções de layout.
- Build do app normal (`fvm flutter build web --release`) e capturas antes/depois das telas atuais em 390, 768 e 1280 px.
- Aba de rede: Bricolage e Figtree vêm de `assets/fonts/`, sem requisição a Google Fonts para essas famílias.
- Contraste dos pares da spec calculado por script (WCAG 2.1) e anotado no `verificacao.md`.
