# Plano da 006. Página Sobre, resumo na Home, apoio e bloco do Observatório

- **Spec:** spec.md
- **Criado em:** 2026-11-03

## Abordagem
Tudo é conteúdo fixo: nenhuma consulta, nenhum store, nenhum datasource. A entrega cria peças compartilhadas em `lib/core/components/` (porque Home e Sobre usam as mesmas, e a 007 a 009 vão reaproveitar migalhas e cabeçalho), uma feature pequena `lib/features/about/` só com página e componente, e uma seção nova na Home.

**Apoio (porte do Observatório).** `PartnerLogo`, `PartnerLogoGrid` e `PartnersSection` vêm de `../observatorio_geo_hist/lib/app/core/components/partners/` com os tokens daqui. As instituições ficam num `enum Partner` em `lib/core/models/partner.dart` (sigla, nome completo, endereço e `AppImages`), na ordem da spec (UFU, FACED, PPGED, FAPEMIG, CAPES, CNPq) e com os endereços do `Partner` do Observatório. O efeito é o mesmo de lá: um único valor animado (`TweenAnimationBuilder`) controla matriz de cor (cinza → cor, com a opacidade na própria matriz), subida, escala, fundo `page`, borda `line` e sombra `soft`; em repouso não pinta sombra nem abre camada. Hover e foco por teclado (`FocusHighlightMode.traditional`) acendem; "reduzir movimento" zera subida e escala. Falha da imagem mostra a sigla em `small`/`inkSecondary`. Colunas por faixa (README): 2 no celular, 3 no tablet, 6 no desktop, com células vazias completando a última linha para não deixar buraco.

**Bloco do Observatório.** `ObservatoryCard` em `lib/core/components/structure/observatory_card.dart`: cartão `footerBackground` com raio 20, círculos concêntricos no canto superior direito (`CustomPainter`, `footerHighlight` a 13%, como o `.parent::before` do protótipo), símbolo de 64 px, rótulo "A expoGEO faz parte do" (`label`, `footerHighlight`), `h2` "Observatório do Ensino de História e Geografia" em branco, texto em `footerText` e `AppButton.primary` "Visitar o Observatório" com `externalUrl: AppLinks.observatory`. Em linha (`Row`: símbolo, `Expanded` texto, botão) no desktop; empilhado abaixo. O símbolo é o `logo.svg` do Observatório (círculos concêntricos laranja), copiado para `assets/images/observatorio_simbolo.svg` e desenhado com `flutter_svg` (já no `pubspec`).

**Migalhas, cabeçalho e coluna de leitura.** `Breadcrumbs`, `PageHeader` e `ReadingColumn` vêm de `../observatorio_geo_hist/lib/app/core/components/reading/` para `lib/core/components/reading/`, com os tokens daqui: navegação com nome "Você está em", seta decorativa, último item com "página atual" e os anteriores como links (`context.go`). O `PageHeader` tem fundo `surface` com filete `line` embaixo, `h1` (`headingLevel: 1`) e `lead` em `reading`/`inkSecondary` (o mesmo do hero).

**Página Sobre.** `AboutPage` (`lib/features/about/pages/about_page.dart`) monta `SiteScaffold` com: `PageHeader` (Início › Sobre, "Sobre a expoGEO", subtítulo); `ReadingColumn` (máx. 720) com os três parágrafos em `reading`, o `h2` "Como cada objeto é descrito", o texto, o `ReferenceCodeExample`, a frase dos links e um `Wrap` com `AppButton.secondary` "Metadados da curadoria" e "Tese de doutorado" (`externalUrl` com `AppLinks.curationMetadata` e `AppLinks.thesis`, os mesmos do rodapé); e uma seção com `PartnersSection` e `ObservatoryCard`. O `ReferenceCodeExample` (`lib/features/about/components/`) mostra os três blocos com borda `line` e raio 12: letras em `code` ampliado (24 px, `accentStrong`, Figtree 600 tabular) e a legenda em `small`/`inkSecondary`; 3 colunas (`Row` de `Expanded`, altura igual) a partir do tablet e 1 no celular. É um grupo com nome "Exemplo de código de referência".

**Home.** `HomeAboutSection` (`lib/features/home/components/home_about_section.dart`): `surface`, rótulo "Sobre a expoGEO" (`accentStrong`), `h2`, texto em `reading`/`inkSecondary`, link "Saiba mais sobre o projeto →" para `AppRouter.about`; à direita (ou embaixo, abaixo de 1024) a lista dos três públicos com filetes `line` em cima e embaixo, ícone de 44 px em círculo `accentSoft` (ícone em `accentStrong`, decorativo), título `h3` e texto em `inkSecondary`. A `HomePage` ganha três slivers depois de "Adicionados recentemente": `HomeAboutSection`, `PartnersSection` e o `ObservatoryCard` dentro de `PageContent` com padding só embaixo (como o `padding-top:0` do protótipo).

**Rota e limpeza.** `GoRoute(path: AppRouter.about)` com `AboutPage`, sem mexer nas outras rotas. Com o texto novo no ar, `home_banner.dart` e `logo.dart` (sem uso, sem conteúdo próprio) são apagados.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `assets/images/observatorio_simbolo.svg` | Símbolo do Observatório (cópia do `logo.svg` do redesign de lá) |
| Alterar | `lib/core/utils/enums/app_images.dart` | Formato `svg` e entrada `observatorioSimbolo` |
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | `ShadowStyle.fade` e tokens de logos, migalhas, cabeçalho, leitura, resumo, bloco do Observatório e código |
| Criar | `lib/core/models/partner.dart` | Instituições: sigla, nome completo, endereço, imagem |
| Criar | `lib/core/components/partners/partner_logo.dart` | Logo com efeito, link e falha |
| Criar | `lib/core/components/partners/partner_logo_grid.dart` | Grade 2/3/6 sem buraco |
| Criar | `lib/core/components/partners/partners_section.dart` | Seção "Realização e apoio" |
| Criar | `lib/core/components/structure/observatory_card.dart` | Bloco do Observatório |
| Criar | `lib/core/components/reading/breadcrumbs.dart` | Migalhas |
| Criar | `lib/core/components/reading/page_header.dart` | Cabeçalho de página com h1 |
| Criar | `lib/core/components/reading/reading_column.dart` | Coluna de leitura de 720 px |
| Criar | `lib/features/about/components/reference_code_example.dart` | Os três blocos do código |
| Criar | `lib/features/about/pages/about_page.dart` | Página `/sobre` |
| Criar | `lib/features/home/components/home_about_section.dart` | Resumo e públicos |
| Alterar | `lib/features/home/pages/home_page.dart` | Três slivers no fim |
| Alterar | `lib/core/navigation/app_router.dart` | Só acrescenta a rota `/sobre` |
| Apagar | `lib/features/home/components/home_banner.dart` | Texto antigo substituído pelo da página Sobre |
| Apagar | `lib/features/home/components/logo.dart` | Sem uso, sem conteúdo |
| Criar | `test/core/components/partners_test.dart` | Logos: nome, link, foco, falha, colunas |
| Criar | `test/core/components/observatory_card_test.dart` | Textos, h2, botão externo, empilhamento |
| Criar | `test/core/components/breadcrumbs_test.dart` | Nome "Você está em", página atual, link |
| Criar | `test/features/about/about_page_test.dart` | Conteúdo, um h1, h2, botões, código |
| Criar | `test/features/home/home_about_section_test.dart` | Textos, link, h2/h3, colunas |
| Criar | `test/core/navigation/about_route_test.dart` | `/sobre` abre a `AboutPage` com "Sobre" ativo (o `navbar_location_test` já cobre o endereço) |

Nada muda em `lib/features/admin/`, `lib/features/catalog/`, `content_model.dart`, `firestore.rules` nem em `pubspec.*` (a pasta `assets/images/` já está declarada).

## Decisões técnicas
- **Componentes compartilhados em `lib/core/components/`**, não em `features/about`: Home e Sobre usam apoio e bloco; 007 a 009 usam migalhas e cabeçalho.
- **`features/about` sem `infra/` nem `*_setup.dart`**: não há dados. Segue o formato da `features/home` (`pages/` e `components/`).
- **Porte do Observatório, não reescrita**: mesmo efeito, mesma semântica, já testados lá. Ajustes: tokens daqui, `UrlUtils.openUrl`, nome acessível "…, abre em nova aba" (como o resto deste site) e ordem das instituições da spec.
- **Logo com falha mostra a sigla** (como no Observatório): a célula mantém o tamanho, e a grade não abre buraco.
- **Colunas por faixa (2/3/6)** em vez do cálculo por largura mínima do Observatório: o README pede tamanhos fixos por faixa; a spec escolheu 3 no tablet.
- **Símbolo do Observatório em SVG copiado do redesign de lá.** O `observatorio.png` daqui tem o nome escrito em escuro e some sobre o fundo escuro. `AppImages` ganha o formato `svg`; o PNG continua (a 016 limpa).
- **Código de referência em Figtree 600 tabular** (estilo `code` ampliado para 24 px), não monoespaçada como no protótipo: decisão da 001, sem fonte nova.
- **Rótulo, link "Saiba mais" e ícones dos públicos em `accentStrong`**: sobre `surface` o `accent` dá 4,45:1 e sobre `accentSoft` 4,38:1. Mesma solução da 004 e da 005. O link ganha sublinhado no hover.
- **Bloco do Observatório empilhado também em 768**, como no protótipo (que empilha abaixo de 760 px de largura).
- **`ShadowStyle.fade`** portado do Observatório para a sombra acompanhar o valor animado sem pintar sombra transparente em repouso.
- **Seções novas da Home não observam o `CatalogStore`**: aparecem mesmo com o catálogo em erro (hoje, `PERMISSION_DENIED` no dev).
- **Apagar `logo.dart` junto com `home_banner.dart`**: os dois estão na lista da 016, sem uso desde a 004; `logo.dart` não tem conteúdo real.

## Dependências e geração de código
- Nenhum pacote novo (`flutter_svg` e `url_launcher` já existem). Se o `pub get` mexer no `pubspec.lock`, `git restore pubspec.lock`.
- Sem `build_runner`: nenhum store nem modelo Freezed.
- Rota: só acrescenta `/sobre` em `app_router.dart` (constante `AppRouter.about` já existe). O servidor do dev e da produção já reescreve rotas para `index.html` (o `.htaccess` fica no servidor), então o link direto funciona como nas outras rotas.
- Registro: nenhum.
- Asset novo: `assets/images/observatorio_simbolo.svg` (pasta já declarada).

## Riscos e cuidados
- **Dados do catálogo não são usados.** A regra de leitura por grupo de coleções ainda não está publicada no dev (`PERMISSION_DENIED`), mas nenhuma parte da 006 depende dela; não é preciso datasource falso. Na Home com o Firestore real, as contagens e os recentes mostram o estado de erro da 004/005 e as seções novas aparecem normalmente. Para olhar a Home inteira com dados (regressão), pode-se reaproveitar o datasource falso da 005, só na cópia do scratchpad, nunca commitado.
- **Desempenho da rolagem com seis logos animados**: cada logo em `RepaintBoundary`, sem sombra nem filtro extra em repouso (mesmo cuidado do Observatório).
- **Foco no fundo escuro**: o anel de foco do `AppButton` em `accent` sobre `footerBackground` dá cerca de 3,4:1 (mínimo para contorno não textual é 3:1). Conferir visível por Tab.
- **Altura igual nos blocos do código com `IntrinsicHeight`**: sem `LayoutBuilder` dentro; asserções só em debug.
- **Componentes compartilhados novos** não alteram os existentes. `AppImages` ganha um formato; conferir que os caminhos atuais (`png`, `webp`) não mudam. Conferir hero, temas, "Como explorar", recentes, navbar, rodapé, tema, subtema e 404.
- **Zoom 200%**: textos dos blocos do código, do bloco do Observatório e das migalhas quebram (`Wrap`/`Flexible`), sem altura fixa.
- **Contraste a medir**: `accentStrong`/`surface` (6,26), `accentStrong`/`accentSoft` (6,11), `inkSecondary`/`surface` (6,45) e `page` (7,01), `footerText` e `footerHighlight` sobre `footerBackground`, branco sobre `accent` (botão), `accentStrong`/`page` nos códigos.
- **Caminho com "ó"**: `analyze` e `test` na cópia ASCII do scratchpad.
- **Painel admin**: não muda; sem credenciais de teste, fica "não conferido na tela".

## Como conferir
- `fvm flutter analyze` e `fvm flutter test` na cópia ASCII; `fvm dart format` nos `.dart` alterados.
- `git diff --stat` sem `lib/features/admin/`, `lib/features/catalog/`, `firestore.rules`, `pubspec.*`; em `app_router.dart` só a rota nova.
- `fvm flutter build web --release` no projeto; servidor Python próprio com fallback para `index.html`; navegador embutido em 390, 768 e 1280 px na Home e em `/sobre` (abrindo `/sobre` direto e recarregando). Uma vez em debug (`fvm flutter run -d web-server`) para pegar asserções e `overflow`. Voltar o navegador ao preset desktop e parar os servidores.
