# Execução da Fase 0

- **Início:** 2026-10-27
- **Branch:** refactor/redesign-fase-0 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 001-fundacao | 0.1-0.3 | feito (plano com 13 tarefas) | feito (3 commits) | feito (1 correção: comentário do degradê) | verificada |
| 002-botoes-navbar-rodape | 0.4-0.6 | feito (plano com 21 tarefas) | feito (3 commits) | pendente | |
| 003-index-ilustracoes | 0.7-0.8 | pendente | pendente | pendente | |

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

## Ressalvas
- (nenhuma até agora)

## Ocorrências
- (001, implementação) Um `pub get` atualizou transitivos no `pubspec.lock` (`characters` 1.4.1, `matcher` 0.12.19) fora da entrega; o arquivo foi restaurado pela orquestradora.
- (001, implementação) Defeito anterior à fase: a página Contato abre cinza com `GoError: There is no GoRouterState above the current context`. Fica para a spec 010 (Contato).
