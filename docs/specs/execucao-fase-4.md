# Execução da Fase 4

- **Início:** 2026-11-08
- **Branch:** refactor/redesign-fase-4 (worktree `.claude/worktrees/fase-4`, criada a partir de `refactor/redesign-fase-3`) → PR para `refactor/redesign-fase-3` (retargeta para `develop` quando o #13 entrar)

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 012-login | 4.1 | feita (10 critérios, 13 tarefas) | feita (2 commits) | feita (sem correções) | verificada |
| 013-painel-estrutura | 4.2 | feita (10 critérios, 17 tarefas) | feita (3 commits) | feita (1 correção) | verificada |
| 014-painel-objetos | 4.3 | feita (14 critérios, 17 tarefas) | feita (2 commits) | feita (1 correção) | verificada |
| 015-editor-objeto | 4.4 | feita (16 critérios, 18 tarefas) | feita (4 commits) | feita (2 correções, 1 ressalva) | verificada com ressalvas |

## Decisões tomadas sem a pessoa
- (fase) Base na branch da Fase 3, a pedido da pessoa, porque o PR #13 ainda não entrou na `develop`. O PR da Fase 4 aponta para `refactor/redesign-fase-3` para mostrar só o que é da fase; quando o #13 for integrado e a branch apagada, o GitHub o move para a `develop`. O CI só roda em PR para `develop`/`main`, então roda depois disso.
- (fase) As specs 012 a 015 já existiam, aprovadas em 2026-10-27. A etapa de spec revisa cada uma contra o código atual (lição da Fase 0) em vez de reescrever.
- (fase) Sem credenciais de teste do painel: as telas com sessão são conferidas na cópia ASCII do scratchpad com autenticação e datasource simulados, nunca commitados e sem gravar no Firestore.
- (012) Em 768 px o login fica como no celular; campos não são apagados após credenciais erradas; mensagens de erro escolhidas na tela sem mudar `auth_failure.dart`; nascem em `lib/core/` campo de senha, `FormErrorAlert` e estado carregando do botão; o roteador espera a sessão salva só em `/admin`, com tempo-limite.
- (013) Até a 014, "Objetos digitais" mostra a área de objetos atual dentro da moldura nova, para criar/editar/excluir seguirem funcionando; `/admin/painel` leva a `/admin/painel/objetos` e "Ver objetos" passa `?tema=&subtema=`; gaveta abaixo de 900 px; erro nas contagens com "Tentar de novo" (o protótipo não tem); catálogo recarregado ao abrir o painel e após cada gravação.
- (014) Até a 015, a lista nova abre o diálogo de criar/editar de hoje; a leitura dos dados gravados é corrigida na 014 (preservação pela chave `preservationAction`, tipo e formato pelo nome ou pelo rótulo), sem mudar o que é gravado — isso também afeta o site público (objetos criados pelo formulário deixam de aparecer como "Outro"); filtros `tipo` e `q` no endereço.
- (015) O editor grava como os 190 objetos do dev (código como id do documento, siglas de tema/subtema, tipo e formato pelo nome, datas só com o dia); criar e trocar de subtema em transação, para não repetir código; editor fora da moldura do painel, como no protótipo; "Novo objeto" sempre abre o editor; o diálogo antigo sai aqui e os campos/botões antigos ficam para a 016. `themeTitle`/`subthemeTitle` saem com o nome do site, que difere da grafia do seed em alguns subtemas (nenhuma tela lê esses campos).

## Ressalvas
- (015) o menu das listas do editor (Tipo, Formato, Mês, Ano, Tema, Subtema) abre mais estreito que o campo; tentado `minimumSize` do `MenuStyle` com a largura medida por `LayoutBuilder` e ao abrir, e o item do menu seguiu com 121 px, então desfeito para não mexer nos filtros da lista.
- (014) nenhuma ressalva.
- (013) nenhuma ressalva; fora do escopo, registrado para a 015: o formulário antigo grava tipo e formato pelo rótulo e lê pelo nome (objeto criado volta como "Outro"), não corrigido porque mexeria no modelo.

## Ocorrências
- Alterações soltas na pasta original (testes de `test/` e `pubspec.lock`, na `refactor/redesign-fase-3`) ficaram lá, fora do worktree.
- 2026-11-08: o limite de 5 horas interrompeu a verificação da 013; retomada com SendMessage em 2026-11-09.
- 2026-11-09: o limite de 5 horas interrompeu a implementação da 015 na tarefa C4; retomada com SendMessage.
