# Execução da Fase 0

- **Início:** 2026-10-27
- **Branch:** refactor/redesign-fase-0 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 001-fundacao | 0.1-0.3 | feito (plano com 13 tarefas) | feito (3 commits) | feito (1 correção: comentário do degradê) | verificada |
| 002-botoes-navbar-rodape | 0.4-0.6 | feito (plano com 21 tarefas) | feito (3 commits) | feito (1 correção: comentários que só descreviam o código; teste do hover dos botões) | verificada |
| 003-index-ilustracoes | 0.7-0.8 | feito (plano com 13 tarefas) | feito (3 commits; 1 ajuste na spec: título do `MaterialApp`) | feito (1 correção: comentário em inglês no `index.html`; prévia real em aplicativo de mensagem pendente até o deploy) | verificada |

O item 0.0 (branch `develop` com deploy de dev) já existe no remoto e fica fora do fluxo SDD.

## Decisões tomadas sem a pessoa
- (geral) A branch da fase saiu de `origin/develop` e recebeu, por avanço rápido, o commit local `addaf91` (specs aprovadas 001 a 016), que ainda não estava no remoto. Motivo: as specs aprovadas são a entrada da fase.
- (geral) As specs 001 a 003 já estavam aprovadas; a etapa "spec+plano" roda só o `/sdd-plan`, ajustando a spec apenas se o plano exigir.
- (001, plano) Código de referência em Figtree 600 com algarismos tabulares, não em monoespaçada do sistema (o Flutter web não acessa fontes do sistema; embutir uma monoespaçada pesaria 120 a 270 KB por peso na abertura). Spec ajustada e registrada no histórico.
- (001, plano) Critério "fontes sem internet" conferido como "sem requisição a Google Fonts para Bricolage/Figtree", já que o app depende de rede para o CanvasKit. Spec ajustada.
- (001, plano) Tela de teste com ponto de entrada próprio em `lib/dev/`, fora do git via `.git/info/exclude`, em vez de rota temporária; apagada no fim da verificação.
- (001, plano) Primeira pasta `test/` do projeto, com teste unitário das faixas (só `flutter_test`, já presente).
- (002, plano) Botões novos como componente novo (`AppButton.primary/.secondary/.ghost`) nas páginas públicas; `PrimaryButton`/`SecondaryButton` antigos ficam só no painel admin até 013-015 e saem na 016. Motivo: não mexer no painel. Spec ajustada.
- (002, plano) Botão discreto em acento forte `#A33600` (acento normal sobre acento suave dá 4,38:1), como no Observatório. Spec ajustada.
- (002, plano) Painel do celular lateral (`showGeneralDialog`, como no Observatório) em vez de abaixo da barra, porque a faixa rola e mudaria a posição do painel. Spec ajustada.
- (002, plano) Componente de medalhão (`AppMedallion`) criado na 002, não na 004, porque o menu Temas precisa dele antes; 002 e 004 ajustadas. Ilustração do tema por extensão nova `ThemeEnum.illustration` (o `imagePath` do modelo aponta para JPGs inexistentes), sem tocar no modelo.
- (002, plano) O `GoError` de Contato e 404 vem do `GoRouterState.of` da navbar na página do `errorBuilder`; a navbar nova usa o contorno do Observatório (`GoRouter.of(context).routeInformationProvider`). Correção incluída na tarefa D1, sem mexer em rotas. `/contato` e `/sobre` continuam caindo na 404 (agora com navbar, rodapé e item ativo) até 010 e 006.
- (002, plano) Faixa rolando e navbar fixa por um `SiteScaffold` com `CustomScrollView`; Home, tema, subtema e 404 passam a usá-lo, sem mudar o conteúdo. A Home, que não tinha navbar, ganha faixa e navbar.
- (002, plano) Logos de apoio saem do rodapé (não estão no rodapé novo) e voltam na 006; nenhum asset apagado. Spec ajustada.
- (002, plano) "Ver todos na página inicial" por `ValueNotifier` em `HomeSections` + rolagem até a seção de temas, sem rota nova; constante `AppRouter.about` só como texto, sem `GoRoute`. A 004 foi anotada para manter a chave.
- (002, plano) Ícones de redes em SVG copiados do Observatório (`flutter_svg`, já dependência); links sem `linkUrl` na semântica, para não precisar do contorno com `package:web`. Nenhum pacote novo.
- (003, plano) WebP gerado pelo Chrome sem janela (`canvas.toDataURL`), por script em `tool/images/`: a máquina não tem `cwebp`, ImageMagick nem Pillow, e o `sips` só lê WebP. Nada instalado e nenhum pacote no `pubspec`. Teste no planejamento: maior ilustração de 480 KB para 60 KB (qualidade 0,8, 512 px, transparência mantida).
- (003, plano) WebP com o nome do `AppImages` em snake_case, sem acento (`cultura_politica.webp`), o que tira Cultura e Política do placeholder; o PNG com acento fica até a 016. `AppImages` ganha formato por entrada (ilustrações e logos de apoio em WebP; `logo`, `logoSimple` e `observatorio` em PNG), sem mexer em modelo. Spec ajustada.
- (003, plano) Logos de apoio em WebP na resolução original (qualidade 0,95), com critério de aceite novo (CA8). Spec ajustada.
- (003, plano) Imagem de compartilhamento em PNG 1200 × 630 (`web/og-image.png`) com endereço absoluto `https://expogeo.com.br/`, mais `twitter:*`; ícones e imagem gerados por `tool/web_icons/` (Chrome sem janela + `sips`), como no Observatório, a partir do `logo_simple.png`. Spec ajustada.
- (003, plano) Tela de carregamento do Observatório com aviso de demora em 15 s, botão "Recarregar" e mensagem `<noscript>` (a spec não tratava falha de carregamento); manifesto com descrição e `lang`, sem `orientation`. Spec ajustada.
- (003, implementação) O `title` do `MaterialApp` ("expoGEO: Exposição Geográfica") trocava o título da aba ao carregar; passa a usar o título novo. Spec ajustada.
- (003, implementação) `movimentos_terra.webp` ficou com 67 KB (qualidade 0,7), acima da meta de 60 KB; a soma ficou 89% menor.
- (003, plano) Prévia real em aplicativo de mensagem só com o site publicado; na conferência local valem as tags e a imagem, e a prévia fica pendente para o dev publicado.

## Ressalvas
- (003, verificação) Nenhuma ressalva de código. Pendente de conferência após o deploy: prévia real em aplicativo de mensagem (`dev.expogeo.com.br`). O anel parado com "reduzir movimento" foi conferido forçando a regra do CSS por script; painel admin não conferido na tela (sem credenciais).

## Ocorrências
- (003, verificação) Aceite da Fase 0 conferido: todas as páginas atuais abrem em debug sem erro com navbar, rodapé e botões novos; navbar navegável por teclado.
- (003, implementação) A sessão parou no limite de uso durante a conferência e foi retomada em 2026-11-03, sem perda de trabalho.
- (001, implementação) Um `pub get` atualizou transitivos no `pubspec.lock` (`characters` 1.4.1, `matcher` 0.12.19) fora da entrega; o arquivo foi restaurado pela orquestradora.
- (001, implementação) Defeito anterior à fase: a página Contato abre cinza com `GoError: There is no GoRouterState above the current context`. Corrigido na 002 (navbar nova sem `GoRouterState.of`).
- (002, implementação) A sessão parou no limite de uso no meio do grupo da navbar e foi retomada de onde parou (2026-10-29), sem perda de trabalho.
- (002, implementação) A orquestradora retomou por engano a sessão já encerrada da implementação da 001; ela não alterou nada (conferido no `git status`).
- (003, implementação) A sessão parou no limite semanal de uso depois de 2 commits e foi retomada de onde parou (2026-11-03), sem perda de trabalho.
- (003, implementação) Defeito anterior à fase: `/representacoes-espaciais/movimentos-terra` mostra o conteúdo de História da Cartografia, porque Movimentos da Terra não está na lista de subtemas do tema. Fica para a spec 008 (página de subtema).
