# Execução da Fase 4

- **Início:** 2026-11-08
- **Branch:** refactor/redesign-fase-4 (worktree `.claude/worktrees/fase-4`, criada a partir de `refactor/redesign-fase-3`) → PR para `refactor/redesign-fase-3` (retargeta para `develop` quando o #13 entrar)

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 012-login | 4.1 | feita (10 critérios, 13 tarefas) | feita (2 commits) | feita (sem correções) | verificada |
| 013-painel-estrutura | 4.2 | feita (10 critérios, 17 tarefas) | pendente | pendente | |
| 014-painel-objetos | 4.3 | pendente | pendente | pendente | |
| 015-editor-objeto | 4.4 | pendente | pendente | pendente | |

## Decisões tomadas sem a pessoa
- (fase) Base na branch da Fase 3, a pedido da pessoa, porque o PR #13 ainda não entrou na `develop`. O PR da Fase 4 aponta para `refactor/redesign-fase-3` para mostrar só o que é da fase; quando o #13 for integrado e a branch apagada, o GitHub o move para a `develop`. O CI só roda em PR para `develop`/`main`, então roda depois disso.
- (fase) As specs 012 a 015 já existiam, aprovadas em 2026-10-27. A etapa de spec revisa cada uma contra o código atual (lição da Fase 0) em vez de reescrever.
- (fase) Sem credenciais de teste do painel: as telas com sessão são conferidas na cópia ASCII do scratchpad com autenticação e datasource simulados, nunca commitados e sem gravar no Firestore.
- (012) Em 768 px o login fica como no celular; campos não são apagados após credenciais erradas; mensagens de erro escolhidas na tela sem mudar `auth_failure.dart`; nascem em `lib/core/` campo de senha, `FormErrorAlert` e estado carregando do botão; o roteador espera a sessão salva só em `/admin`, com tempo-limite.
- (013) Até a 014, "Objetos digitais" mostra a área de objetos atual dentro da moldura nova, para criar/editar/excluir seguirem funcionando; `/admin/painel` leva a `/admin/painel/objetos` e "Ver objetos" passa `?tema=&subtema=`; gaveta abaixo de 900 px; erro nas contagens com "Tentar de novo" (o protótipo não tem); catálogo recarregado ao abrir o painel e após cada gravação.

## Ressalvas

## Ocorrências
- Alterações soltas na pasta original (testes de `test/` e `pubspec.lock`, na `refactor/redesign-fase-3`) ficaram lá, fora do worktree.
