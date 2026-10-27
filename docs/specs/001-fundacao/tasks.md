# Tarefas da 001. Fundação visual (tokens, fontes e breakpoints)

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios de aceite da spec, na ordem: **CA1** compila e `analyze` limpo; **CA2** telas atuais e painel idênticos; **CA3** cores e degradê; **CA4** espaçamentos, raios, sombras e foco, sem valor solto; **CA5** fontes embutidas, declaradas, com licença, sem Google Fonts; **CA6** estilos novos sem `google_fonts`/`num_extension`; **CA7** tela de teste em 390/768/1280; **CA8** faixas em 390, 599, 600, 768, 1023, 1024, 1280; **CA9** 1120 px e margens 20/32; **CA10** contraste anotado.

`analyze` e `test` rodam na cópia ASCII do scratchpad (rsync sem `build/` e `.dart_tool/`, depois `fvm flutter pub get`). Toda tarefa termina com `fvm flutter analyze` sem avisos.

## Grupo A: linha de base
- [x] **A1.** Gerar o build web do estado atual (antes de qualquer mudança) e capturar Home, uma página de tema, uma de subtema, Contato, 404 e login em 390, 768 e 1280 px, guardando as imagens no scratchpad. Arquivos: nenhum no projeto. Atende: CA2 (referência do "antes").
  - Nota: capturas feitas com Chrome sem janela via protocolo de depuração (18 imagens). A página Contato já abria cinza no estado atual (`GoError: There is no GoRouterState above the current context`), defeito anterior a esta spec.

## Grupo B: tokens
- [x] **B1.** Acrescentar ao `AppColors` as 16 cores da tabela da spec com os nomes do plano, sem tocar nas atuais. Arquivos: `lib/core/theme/app_colors/app_colors.dart`. Atende: CA3.
- [x] **B2.** Acrescentar `AppGradients.brand` (`#F97316 → #FB923C → #FACC15`, paradas 0 / 0,45 / 1, 120°). Arquivos: `lib/core/theme/app_gradients/app_gradients.dart`. Atende: CA3.
- [x] **B3.** Acrescentar ao `AppDimensions` `spacing` (4 a 96), `radii` (6 a 20 e `pill`), `shadows` (`soft`, `elevated`) e `focus` (3 px, afastamento 2 px, cor `accent`), copiando as classes do Observatório. Arquivos: `lib/core/theme/app_dimensions/app_dimensions.dart`. Atende: CA4.

## Grupo C: breakpoints e largura de conteúdo
- [ ] **C1.** Acrescentar ao `screen_utils.dart` o `enum Breakpoint` (`fromWidth`, cortes 600 e 1024), `contentMaxWidth = 1120`, `breakpointOf(context)` e `contentMargin(breakpoint)` (20 / 32 / 32, pelos tokens `spacing`). As funções atuais ficam iguais. Arquivos: `lib/core/utils/screen/screen_utils.dart`, `lib/core/theme/app_theme.dart` (import). Atende: CA8, CA9.
- [ ] **C2.** Criar o teste das faixas e margens em 390, 599, 600, 768, 1023, 1024 e 1280 px, e das funções antigas (`isMobile`, `isTablet`, `isDesktop`) nos mesmos pontos, e rodar `fvm flutter test`. Arquivos: `test/core/utils/screen/breakpoint_test.dart`. Atende: CA8.
- [ ] **C3.** Criar o `PageContent` (caixa de 1120 px centralizada, margem por faixa), copiado do Observatório. Arquivos: `lib/core/components/structure/page_content.dart`. Atende: CA9.

## Grupo D: fontes e tipografia
- [ ] **D1.** Copiar de `../observatorio_geo_hist/assets/fonts/` os 7 `.ttf` (Bricolage 600/700/800, Figtree 400/500/600/700) e as 2 licenças OFL, e declarar as famílias `BricolageGrotesque` e `Figtree` no `pubspec.yaml` ao lado da `Aleo`. Arquivos: `assets/fonts/*`, `assets/fonts/licenses/*`, `pubspec.yaml`. Atende: CA5.
- [ ] **D2.** Criar `AppTextStyles` (h1, h2, h3, reading, regular, small, label, code) com os tamanhos por faixa da spec e do plano, `fontFamily` das fontes embutidas e fallback do sistema, e o método `AppTheme.typography.of(context)`. Sem `google_fonts` e sem `num_extension` no arquivo novo. Arquivos: `lib/core/theme/app_typography/app_text_styles.dart`, `lib/core/theme/app_typography/app_typography.dart`, `lib/core/theme/app_theme.dart` (`part`). Atende: CA6 (conferir com `grep` no arquivo novo), CA5.

## Grupo E: tela de teste temporária
- [ ] **E1.** Acrescentar `lib/dev/` ao `.git/info/exclude` e criar o ponto de entrada `lib/dev/foundation_preview_main.dart` (um `MaterialApp` sem Firebase, dentro de `PageContent`) mostrando: amostras de todas as cores e do degradê com o hex; cada estilo de texto com nome, família, peso e o tamanho efetivo; espaçamentos, raios, sombras e um bloco com o foco de 3 px; e um rodapé com a largura atual, a faixa (`Breakpoint`) e a margem em uso. Só tokens novos, nada de valor solto. Arquivos: `lib/dev/foundation_preview_main.dart` (fora do git), `.git/info/exclude`. Atende: CA7, CA3, CA4, CA9.

## Grupo F: conferência
- [ ] **F1.** Conferir o código: `git diff` mostra só linhas acrescentadas no tema, no `ScreenUtils` e no `pubspec.yaml` (nenhum valor antigo alterado ou removido); `grep` sem `google_fonts`, `GoogleFonts` e `num_extension` em `app_text_styles.dart`, `page_content.dart` e nos trechos novos; `git status` não lista `lib/dev/`; `fvm flutter analyze` e `fvm flutter test` limpos. Atende: CA1, CA2, CA4, CA6.
- [ ] **F2.** Calcular por script o contraste (WCAG 2.1) dos pares da seção Acessibilidade da spec e guardar a tabela para o `verificacao.md` (valores esperados: ink/branco 17,1; secundário/branco 7,0; acento/branco 4,87; secundário/superfície 6,45; texto do rodapé 11,65; destaque do rodapé 8,37; erro/branco 6,54; sucesso/fundo 5,71; acento forte/superfície 6,26; acento forte/acento suave 6,11). Atende: CA10.
- [ ] **F3.** Conferência rodando o app em **390, 768 e 1280 px**: (a) build release da tela de teste (`-t lib/dev/foundation_preview_main.dart`), servida por um servidor Python próprio com fallback para `index.html`, aberta no navegador embutido; conferir os tamanhos da tabela em cada faixa, a troca exata em 599/600 e 1023/1024, o conteúdo em 1120 px centralizado a 1440 px e as margens de 20/32 px, sem rolagem horizontal; (b) aba de rede: Bricolage e Figtree carregadas de `assets/fonts/`, sem requisição a `fonts.googleapis.com`/`fonts.gstatic.com` para essas famílias; (c) uma vez em debug (`fvm flutter run -d web-server`) sem asserção de layout no console; (d) build release do app normal e capturas de Home, tema, subtema, Contato, 404 e login comparadas com as da A1; painel marcado como "não conferido na tela" se não houver credenciais de teste; (e) parar os servidores e voltar o navegador ao preset desktop. Atende: CA2, CA5, CA7, CA8, CA9.

## Ligação critério → tarefa
| Critério | Tarefas |
|---|---|
| CA1 compila, `analyze` limpo | todas; F1 |
| CA2 telas atuais e painel idênticos | A1, F1, F3 |
| CA3 cores e degradê | B1, B2, E1 |
| CA4 espaçamentos, raios, sombras, foco | B3, E1, F1 |
| CA5 fontes embutidas sem internet | D1, D2, F3 |
| CA6 sem `google_fonts`/`num_extension` | D2, F1 |
| CA7 tela de teste em 390/768/1280 | E1, F3 |
| CA8 faixas nos pontos de corte | C1, C2, F3 |
| CA9 1120 px e margens 20/32 | C1, C3, E1, F3 |
| CA10 contraste anotado | F2 |
