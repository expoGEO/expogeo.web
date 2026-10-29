# Plano da 003. `index.html`, ícones e ilustrações otimizadas

- **Spec:** spec.md
- **Criado em:** 2026-10-29

## Abordagem
Duas frentes independentes, ambas copiando o que o Observatório já resolveu.

**Cabeçalho, ícones e carregamento (0.7).** O `web/index.html` ganha `lang="pt-BR"`, `viewport`, título, descrição, `theme-color`, `canonical`, Open Graph e `twitter:*` no mesmo formato do `index.html` do Observatório, com endereço absoluto `https://expogeo.com.br/`. O bloco do Analytics fica exatamente onde está, no topo do `<head>`, entre os mesmos marcadores. A tela de carregamento é a do Observatório (`#carregamento`: CSS e script inline, `role="status"`, anel no acento, esmaecer de 200 ms no evento `flutter-first-frame`, remoção imediata com "reduzir movimento", aviso de demora em 15 s com "Recarregar", mensagem `<noscript>`), trocando o SVG do Observatório pelo símbolo da expoGEO (`icons/Icon-192.png` exibido a 64 px, nítido até 3x) e o nome por "expo**GEO**".

Os ícones (`favicon.png` 32 px, `Icon-192/512`, `Icon-maskable-192/512`, `apple-touch-icon.png` 180 px) e a imagem de compartilhamento (`og-image.png`, 1200 × 630) saem de páginas HTML "fotografadas" pelo Chrome sem janela e reduzidas com `sips`, como em `../observatorio_geo_hist/tool/web_icons/`. A expoGEO não tem o símbolo em SVG; as páginas usam o `logo_simple.png` com `object-fit` e uma escala que tira a margem transparente do arquivo.

**Ilustrações (0.8).** A máquina não tem `cwebp`, ImageMagick nem Pillow, e o `sips`/ImageIO do macOS só lê WebP. O Chrome instalado codifica WebP pelo `canvas.toDataURL('image/webp', q)`; o teste feito no planejamento converteu a maior ilustração (`conflitos_terra.png`, 480 KB) em 60 KB com qualidade 0,8, 512 × 512 e transparência preservada, sem perda visível, e o `cnpq.png` (98 KB) em 31 KB com 0,95 na resolução original. Um script em `tool/images/` abre uma página local com `--dump-dom`, recebe o WebP em base64 e grava em `assets/images/`. As 36 ilustrações ficam em 512 px com qualidade 0,8 (0,75 ou 0,7 se passar de 60 KB); os 6 logos de apoio mantêm a resolução, com 0,95.

O `AppImages` passa a dizer o formato de cada imagem: ilustrações e logos de apoio em `.webp`, marca e Observatório em `.png`. Como o nome do arquivo sai de `convertToSnakeCase(name)`, `culturaPolitica` vira `cultura_politica.webp` e a ilustração de Cultura e Política deixa de cair no placeholder. Os PNGs continuam em `assets/images/` (pasta inteira já declarada no `pubspec`) até a 016. Um teste confere que todo caminho do `AppImages` existe no disco.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `tool/images/to_webp.html` | Página que desenha o PNG num `canvas` (redução com `imageSmoothingQuality: high`) e escreve o WebP em base64 |
| Criar | `tool/images/generate_webp.sh` | Converte as 36 ilustrações e os 6 logos pelo Chrome sem janela, confere tamanho com `sips` e imprime a tabela PNG × WebP |
| Criar | `assets/images/*.webp` (42 arquivos) | 36 ilustrações (nomes do `AppImages`, sem acento) e 6 logos de apoio |
| Alterar | `lib/core/utils/enums/app_images.dart` | Formato por entrada (`.webp` para ilustrações e apoio, `.png` para `logo`, `logoSimple`, `observatorio`) |
| Criar | `test/core/utils/app_images_test.dart` | Todo `AppImages.path` existe no disco; ilustrações e apoio em `.webp`; caminhos sem acento |
| Criar | `tool/web_icons/icon.html`, `maskable.html`, `og.html`, `generate.sh` | Ícones e imagem de compartilhamento a partir do `logo_simple.png`, como no Observatório |
| Alterar (gerados) | `web/favicon.png`, `web/icons/Icon-192.png`, `Icon-512.png`, `Icon-maskable-192.png`, `Icon-maskable-512.png` | Símbolo da expoGEO no lugar do ícone padrão do Flutter; favicon de 69 KB para ≤ 10 KB |
| Criar (gerados) | `web/icons/apple-touch-icon.png`, `web/og-image.png` | Ícone do iOS e imagem de compartilhamento |
| Alterar | `web/manifest.json` | Nome, nome curto, cores, descrição, `lang`; sai `orientation` |
| Alterar | `web/index.html` | `lang`, metadados, ícones e tela de carregamento |

## Decisões técnicas
- **Conversão pelo Chrome sem janela, não por `cwebp`/Pillow.** Instalar `webp` pelo Homebrew ou Pillow pelo `uv` exigiria baixar pacotes fora do previsto; o Chrome já está na máquina e já é a ferramenta do `generate.sh` do Observatório. O script aceita `CHROME=...` para outro caminho. Resultado conferido no planejamento (60 KB e 31 KB, transparência mantida).
- **Qualidade 0,8 nas ilustrações, com recuo para 0,75 e 0,7** só nas que passarem de 60 KB. A soma esperada fica perto de 1,8 MB contra 12,9 MB dos PNGs (cerca de 86% menor; o critério pede 80%).
- **Logos de apoio na resolução original e qualidade 0,95.** Reduzir tiraria a nitidez em tela de alta densidade; 1,0 no Chrome fica quase do tamanho do PNG (69 KB contra 98 KB no CNPq).
- **Marca e Observatório continuam PNG.** A spec não pede, e o `logo_simple.png` é a fonte dos ícones.
- **Formato por entrada no `AppImages`** (construtor `const AppImages([this.format = ImageFormat.webp])` ou equivalente), em vez de um segundo enum. Nenhum modelo muda: `SubthemeModel.image` e `ThemeEnum.illustration` seguem apontando para o mesmo `AppImages`.
- **Nome do WebP igual ao do `AppImages` em snake_case**, inclusive o erro de grafia `espaco_rural_brasleiro`, para não renomear entradas do enum. O PNG com acento (`cultura_política.png`) fica como está.
- **Imagem de compartilhamento em PNG 1200 × 630**, com endereço absoluto de produção também no build de dev (o dev não é indexado e o critério se confere em produção ou no dev publicado). Fontes Bricolage e Figtree carregadas de `assets/fonts/`.
- **Símbolo da tela de carregamento por `<img src="icons/Icon-192.png">`**, sem arquivo novo; `alt=""` e `aria-hidden`, com o texto "Carregando a expoGEO" escondido visualmente dentro do `role="status"`.
- **Aviso de demora e `<noscript>` do Observatório**: a spec não tratava falha de carregamento; registrado no histórico da spec.
- **Cores da tela de carregamento e das páginas de ícone em variáveis CSS** com os valores do `AppColors` (`page`, `ink`, `inkSecondary`, `line`, `accent`, `accentStrong`), com um comentário apontando o arquivo. HTML não lê os tokens Dart.
- **Sem `orientation` no manifesto**: o app instalado não deve travar em retrato em tablet e desktop.
- **Comentários dos scripts e páginas em português**, só com o porquê (regra do projeto; os do Observatório estão em inglês).

## Dependências e geração de código
- Nenhum pacote novo no `pubspec`. Nenhuma mudança na seção `assets:` (a pasta `assets/images/` já está declarada).
- Ferramentas usadas só pelos scripts: Google Chrome (`/Applications/Google Chrome.app`), `sips` e `base64` do macOS.
- Sem `build_runner`, sem `*_setup.dart`, sem rota, sem modelo.

## Riscos e cuidados
- **Marcadores do Analytics:** o `deploy-dev.yml` apaga o intervalo com `sed`. A tela de carregamento não pode ficar dentro dele; a conferência roda o mesmo `sed` numa cópia do `build/web/index.html` e confere que o `#carregamento` continua e o `googletagmanager` sai.
- **Pacote maior até a 016:** PNG e WebP vão juntos para `build/web/assets/`. O Flutter só baixa a imagem usada, então o carregamento não piora; só o deploy por FTP fica maior.
- **Encoder do canvas:** pode clarear bordas semitransparentes. A tarefa B3 compara PNG e WebP lado a lado em fundo branco e escuro.
- **Ilustração cortada:** o cartão de subtema atual usa `BoxFit.cover` num quadrado; com WebP quadrado igual ao PNG, o recorte não muda. O medalhão (`contain`) já mostra inteira.
- **Telas que mostram ilustrações:** menu Temas (desktop e painel do celular), cartões e faixa de subtema nas páginas de tema. Conferir as três nas três larguras.
- **Pré-visualização em aplicativo de mensagem** só funciona com o site publicado (a imagem tem endereço absoluto). Localmente se conferem as tags e o arquivo; a prévia real fica para o dev publicado, registrada como pendente se não der para conferir.
- **Painel admin:** não usa `AppImages` (conferido por `grep`); sem credenciais de teste, fica "não conferido na tela".
- **Caminho com "ó":** `analyze` e `test` só na cópia ASCII do scratchpad.

## Como conferir
- `fvm flutter analyze` e `fvm flutter test` na cópia ASCII; `fvm dart format` nos `.dart` alterados.
- Tabela do `generate_webp.sh`: 36 ilustrações ≤ 512 px, soma ≥ 80% menor; 6 logos com a resolução do PNG e menores.
- `fvm flutter build web --release`, servidor Python próprio com fallback para `index.html` e um atraso opcional no `main.dart.js` para ver a tela de carregamento; navegador embutido em 390, 768 e 1280 px: título, favicon, metadados, manifesto, tela de carregamento, menu Temas com as 4 ilustrações (Cultura e Política sem placeholder), páginas de tema e subtema com `.webp` na aba de rede.
- Uma vez em debug (`fvm flutter run -d web-server` na cópia ASCII).
