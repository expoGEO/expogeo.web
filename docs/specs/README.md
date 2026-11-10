# Especificações (SDD)

Cada feature maior ganha uma pasta `docs/specs/NNN-nome-curto/` enquanto está em andamento, com os arquivos criados em sequência pelas skills do projeto.

| Arquivo | Criado por | Conteúdo |
|---|---|---|
| `spec.md` | `/sdd-spec` | **O quê e por quê**: comportamento, estados, critérios de aceite, fora do escopo |
| `plan.md` | `/sdd-plan` | **Como**: abordagem técnica, arquivos afetados, decisões e riscos |
| `tasks.md` | `/sdd-plan` (atualizado por `/sdd-implement`) | Lista de tarefas ordenadas, com o progresso |
| `verificacao.md` | `/sdd-verify` | Resultado da conferência contra os critérios de aceite |

## Fluxo

```
pedido ou ideia ──► /sdd-spec ──► (aprovação) ──► /sdd-plan ──► /sdd-implement ──► /sdd-verify ──► merge
 (ver histórico)     spec.md                      plan.md        código +           verificacao.md
                                                  tasks.md       tasks.md marcadas
```

Em cada etapa a skill **para** e espera a sua aprovação antes de seguir. A spec parte do pedido da pessoa ou de uma ideia da seção "Fora do escopo e ideias futuras" de [redesign-history.md](../redesign-history.md); as regras de design e de código estão em [architecture.md](../architecture.md).

**Modo autônomo:** `/sdd-fase <pedido ou itens>` roda o fluxo inteiro sem paradas: divide o pedido em specs, faz cada etapa numa sessão separada, corrige o que a verificação achar (até 2 tentativas por problema), faz commits por entrega numa branch própria (`refactor/redesign-<fase>`, criada a partir da branch de integração) e termina com um resumo e um PR. O andamento fica em `docs/specs/execucao-<fase>.md`, que também serve para retomar se a execução for interrompida; no encerramento ele é apagado e o resumo vai para o histórico.

## Regras
- Numeração sequencial de três dígitos, seguindo a última usada (a 018 foi a última do redesign; a próxima é a 019). O nome é curto, em `kebab-case`, sem acentos.
- A spec tem um **status** no topo: `rascunho`, `aprovada`, `implementada` ou `verificada`.
- Uma spec só vai para o plano com **zero perguntas em aberto** e status `aprovada`.
- Se, durante a implementação, algo precisar divergir da spec, **atualize a spec primeiro** (e registre em "Histórico de mudanças"), depois o código.
- Cada critério de aceite deve poder ser conferido como "passou" ou "não passou".

## Depois do merge
A pasta da spec sai do repositório no mesmo PR ou logo depois. Antes disso:
- regras e padrões novos vão para [architecture.md](../architecture.md) ou [admin-panel.md](../admin-panel.md);
- ressalvas que seguem em aberto e lições vão para [redesign-history.md](../redesign-history.md);
- se a feature vinha de uma ideia futura, o item sai de lá.

Para consultar uma spec apagada, use o git (`git log --all -- docs/specs/NNN-*`). As do redesign estão na tag `redesign-specs`, criada localmente no encerramento da fase de limpeza (sem push de tag): `git show redesign-specs:docs/redesign/planejamento.md` e `git ls-tree -r --name-only redesign-specs docs/specs`.

## Quando usar
Use para features de mais ou menos meio dia para cima ou que mudem várias telas. Correções pequenas e ajustes pontuais dispensam spec.

## Comentários
Só o porquê que o código não mostra, em uma ou duas linhas, sem citar spec, fase ou protótipo; a regra completa está em "Convenções" de [architecture.md](../architecture.md).
