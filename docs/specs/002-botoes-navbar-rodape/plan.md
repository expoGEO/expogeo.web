# Plano da 002. Botões, faixa do Observatório, navbar e rodapé

- **Spec:** spec.md
- **Criado em:** 2026-10-27

## Abordagem
Portar do redesign do Observatório (`../observatorio_geo_hist/lib/app/core/components/`) os componentes que já resolvem o mesmo problema: `AppButtonBase` e os três botões, `AppFocusRing`, `NavbarItem`, `NavbarDropdown` (hover, teclado, Esc, Tab), `NavbarLocation` (com o contorno da 404), o menu lateral do celular, o `Footer` em colunas por faixa e os botões de redes. Tudo adaptado aos tokens da spec 001 e às regras da expoGEO (menu Temas com medalhões, faixa do Observatório, marca expo**GEO**).

Os botões novos entram como **componentes novos** (`AppButton.primary/.secondary/.ghost`), sem mexer nos antigos `PrimaryButton` e `SecondaryButton`, que o painel admin usa e que só saem quando o painel for redesenhado (specs 013 a 015) e na limpeza (016). Nas páginas públicas, todo botão de texto passa para o novo.

Para a faixa rolar junto e só a navbar ficar fixa, as páginas públicas passam a usar um `SiteScaffold` com `CustomScrollView`: faixa como `SliverToBoxAdapter`, navbar como `SliverPersistentHeader` fixo, conteúdo da página e rodapé preso à base (`SliverFillRemaining`). Home, tema, subtema e 404 trocam o `Column(Navbar, Expanded(SingleChildScrollView))` atual por ele; o conteúdo de cada página não muda. A Home, que hoje não tem navbar, ganha faixa e navbar.

A navbar lê o endereço por `NavbarLocation.of(context)`, que tenta o `GoRouterState` e, na falta dele (página de erro do `errorBuilder`), usa `GoRouter.of(context).routeInformationProvider`. É exatamente o contorno do Observatório e **corrige o `GoError` que deixava Contato e 404 cinza**, sem mexer em rotas. Como `/contato` e `/sobre` ainda não têm rota, os dois caem na 404, que passa a abrir com navbar, rodapé e o item ativo certo.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Grupo `components` (`ComponentSizes`): navbar, faixa, botões, menu, rodapé, alvo mínimo, animação, corte de 900 px |
| Alterar | `lib/core/theme/app_colors/app_colors.dart` | `footerMuted` (#B9B1A7) e `footerSubtle` (#A39A8F), tons do protótipo para endereço e linha final |
| Criar | `lib/core/components/focus/app_focus_ring.dart` | Anel de foco de 3 px, copiado do Observatório |
| Criar | `lib/core/components/button/app_button.dart` | Primário, secundário e discreto; normal e pequeno; ícone antes/depois; desativado; link externo |
| Alterar | `lib/features/home/components/carousel/theme_card.dart`, `lib/features/theme/components/subtheme_card.dart`, `subtheme_error.dart`, `theme_banner.dart`, `subtheme_banner.dart` | Trocar `PrimaryButton`, `SecondaryButton` e `BackToButton` pelo `AppButton` |
| Criar | `lib/core/components/image/app_medallion.dart` | Medalhão 1:1 com `contain`, borda de linha e placeholder (acento suave + ícone de mapa) |
| Criar | `lib/core/models/theme_illustration.dart` | Extensão `ThemeEnum.illustration` → `AppImages` (o `imagePath` atual aponta para JPGs que não existem) |
| Criar | `lib/core/components/brand/app_brand.dart` | Símbolo + "expo**GEO**" + linha opcional; variante para fundo escuro |
| Criar | `lib/core/utils/constants/app_links.dart` | Endereços do Observatório, redes, metadados, tese, e-mail e endereço postal |
| Alterar | `lib/core/utils/url/url_utils.dart` | Parâmetro `sameTab` (para `mailto:` não abrir aba em branco) |
| Criar | `assets/icons/instagram.svg`, `facebook.svg`, `youtube.svg` | Copiados do Observatório |
| Alterar | `pubspec.yaml` | Declarar `assets/icons/` |
| Alterar | `lib/core/navigation/app_router.dart` | Só a constante `about = '/sobre'` (nenhum `GoRoute` novo ou alterado) |
| Criar | `lib/core/navigation/home_sections.dart` | Pedido de rolagem até a seção de temas da Home ("Ver todos na página inicial") |
| Criar | `lib/core/components/structure/observatory_strip.dart` | Faixa escura do Observatório |
| Criar | `lib/core/components/structure/navbar/navbar_location.dart` | Seção ativa a partir do endereço, com contorno da 404 |
| Criar | `lib/core/components/structure/navbar/navbar_item.dart` | Item com sublinhado ativo, hover e foco |
| Criar | `lib/core/components/structure/navbar/navbar_dropdown.dart` | Menu suspenso com hover, teclado, Esc, Tab e fechamento na rolagem |
| Criar | `lib/core/components/structure/navbar/navbar_themes_menu.dart` | Conteúdo do menu Temas |
| Criar | `lib/core/components/structure/navbar/navbar_mobile_menu.dart` | Painel do celular com sanfona |
| Alterar (reescrever) | `lib/core/components/structure/navbar.dart` | Navbar nova e `NavbarSliver` fixo |
| Alterar (reescrever) | `lib/core/components/structure/footer.dart` | Rodapé escuro em 4/2/1 colunas |
| Criar | `lib/core/components/structure/site_scaffold.dart` | Faixa + navbar fixa + conteúdo + rodapé na base |
| Alterar | `lib/features/home/pages/home_page.dart`, `lib/features/theme/pages/theme_page.dart`, `subtheme_page.dart`, `lib/core/pages/not_found_page.dart` | Usar o `SiteScaffold`; Home marca a seção de temas |
| Criar | `test/core/components/navbar/navbar_location_test.dart`, `navbar_dropdown_test.dart` | Seção ativa por endereço; abrir/fechar por teclado e foco de volta |

## Decisões técnicas
- **Botões como componente novo (`AppButton`), não reescrita dos antigos.** Alternativa: mudar `PrimaryButton`/`SecondaryButton` por dentro; descartada porque mudaria o painel admin, fora do escopo. Os antigos ficam só no painel até a 013–015 e saem na 016. Construtores nomeados `AppButton.primary`, `.secondary`, `.ghost`; `size: AppButtonSize.regular | small`; `leadingIcon`/`trailingIcon`; `isDisabled`; `externalUrl` (abre em aba nova, põe a seta ↗ e acrescenta "abre em nova aba" ao nome acessível).
- **Discreto em acento forte (#A33600).** O acento normal sobre o acento suave do hover dá 4,38:1. Igual ao Observatório. Spec ajustada.
- **Desativado:** opacidade 0,5 (token), sem hover, cursor `forbidden`, `Semantics(enabled: false)`. **Foco:** `AppFocusRing` só no modo de teclado (`FocusHighlightMode.traditional`), como no Observatório.
- **Botões de ícone da paginação (`AppIconButton` em `content_grid`) ficam como estão**; não são um dos três botões e a grade é redesenhada na 008.
- **Corte da navbar em 900 px** (token `navbarCollapseWidth`), medido pela largura da tela e não pelo `Breakpoint`: até 900 px, botão de menu e marca sem a linha "Curadoria digital..."; acima, navbar completa. A faixa encurta no `Breakpoint.mobile` (< 600) e o rodapé usa as três faixas (4/2/1 colunas).
- **Painel do celular lateral** (`showGeneralDialog`, entra pela direita, até 420 px), como no Observatório: prende o foco, fecha com Esc e no fundo, e devolve o foco ao botão de menu. Alternativa: painel embaixo da barra, como no protótipo; descartada porque, com a faixa rolando, a posição do painel mudaria com a rolagem. A sanfona "Temas" usa `AnimatedSize` com duração zero quando `MediaQuery.disableAnimationsOf` é verdadeiro.
- **Menu Temas:** `OverlayPortal` + `LayerLink` do `NavbarDropdown` do Observatório (hover no desktop com 150 ms de atraso para fechar; clique fixa; Enter/Espaço/seta para baixo abrem e focam o primeiro item; Esc fecha e devolve o foco; Tab sai fechando). Acrescenta: fecha quando a página rola (ouvinte no `Scrollable` da página). Cada linha: medalhão de 30 px, nome (`Flexible`, até 2 linhas) e "N subtemas" sem quebra, contagem de `theme.subthemes.length`.
- **"Ver todos na página inicial"** marca um `ValueNotifier` em `HomeSections` e vai para `/`; a Home ouve e rola até a seção de temas (hoje o `ThemesRow`) com `Scrollable.ensureVisible`, sem animação com "reduzir movimento". Mesmo padrão do `openTeam` do Observatório; nenhuma rota nova.
- **Medalhão criado aqui (`AppMedallion`)**, porque o menu Temas precisa dele antes da 004. A 004 reaproveita e só define tamanhos. Spec 002 e 004 ajustadas.
- **Ilustração do tema por extensão em arquivo novo** (`ThemeEnum.illustration`), sem mexer em `ThemeModel` nem no conteúdo: `representacoesEspaciais`, `meioAmbienteNatureza`, `espacosUrbanoRural`, `culturaPolitica` de `AppImages`. Quando a 003 trocar os caminhos para WebP, o menu acompanha.
- **Redes por SVG** (`flutter_svg`, já dependência) copiados do Observatório, em vez de `font_awesome_flutter`, que a 016 pode remover. Endereços iguais aos do Observatório.
- **Links sem `linkUrl` na semântica.** No Observatório, o `linkUrl` exigiu um contorno com `package:web` para o navegador não seguir o `<a href>` sozinho; aqui os itens anunciam `link: true` e navegam pelo `onTap`. Evita dependência direta nova.
- **Logos de apoio saem do rodapé** (o rodapé novo da spec e do protótipo não os tem). Voltam na seção "Realização e apoio" da 006. Nenhum asset é apagado.
- **Constante `AppRouter.about`** só como texto, para o item "Sobre" e o rodapé saírem das constantes; o `GoRoute` vem na 006.
- **Testes:** unitário do `NavbarLocation.fromUri` e de widget do `NavbarDropdown` (seta para baixo abre e foca o primeiro item, Esc fecha e devolve o foco ao gatilho). Só `flutter_test`.

## Dependências e geração de código
- Nenhum pacote novo. `flutter_svg` e `url_launcher` já estão no `pubspec`.
- Assets: 3 SVGs em `assets/icons/`, declarados em `flutter: assets:`.
- Sem `build_runner`, sem mudança de `*_setup.dart`, de modelo ou de `GoRoute`. Em `app_router.dart` entra só a constante `about`.

## Riscos e cuidados
- **Páginas com o mesmo componente:** Home, 4 temas, subtemas, 404 (inclui `/contato` e `/sobre`). A conferência final abre todas em 390, 768 e 1280 px. O painel e o login não usam navbar nem rodapé; os botões antigos continuam lá. Garantia estrutural: `git diff` sem arquivos de `lib/features/admin/`.
- **Troca de `SingleChildScrollView` por `CustomScrollView`** na página de subtema: a grade de conteúdos já é encolhida (estava dentro de rolagem), então funciona dentro de `SliverToBoxAdapter`; conferir em debug que não há asserção de layout nem `overflow`.
- **`BackdropFilter` no Flutter web:** custo de desenho a cada rolagem; aceitável (o Observatório usa o mesmo). Se ficar lento no celular, o desfoque pode cair sem mudar a aparência de longe (fundo a 94%).
- **Medalhões no menu:** os PNGs têm cerca de 400 KB; o menu carrega 4 só ao abrir. A 003 reduz.
- **Seção de temas da Home:** a 004 substitui o `ThemesRow`; o plano dela precisa manter a chave de `HomeSections`. Anotado na 004.
- **Logos de apoio somem do site entre a Fase 0 e a 006.** A fase vai para `develop`, não para produção.
- **Contato e Sobre na 404:** o item ativo aparece porque o endereço é `/contato` ou `/sobre`, mesmo com a página de erro; aceito pela spec até a 006 e a 010.
- **Painel admin:** sem credenciais de teste; fica "não conferido na tela".
- **Caminho com "ó":** `analyze` e `test` só na cópia ASCII do scratchpad.

## Como conferir
- `fvm flutter analyze` e `fvm flutter test` na cópia ASCII: sem avisos e testes passando.
- `grep` nos arquivos novos e reescritos: sem `Color(0x`, `num_extension`, `GoogleFonts`, `fontSize:` com número e `EdgeInsets` com número solto.
- `fvm flutter build web --release`, servir `build/web` com fallback para `index.html` e abrir no navegador embutido: Home, os 4 temas, um subtema de cada tema, `/contato`, `/sobre` e um endereço inexistente, em 390, 768 e 1280 px; teclado na faixa, navbar, menu Temas, painel do celular e rodapé.
- Uma vez em debug (`fvm flutter run -d web-server`) sem asserção nem `overflow` no console.
- Contraste dos pares da faixa, navbar e rodapé por script (WCAG 2.1).
