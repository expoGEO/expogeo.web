# Verificação da 018. Enxugar a documentação

- **Data:** 2026-11-10
- **Resultado:** aprovada

## Comandos
| Comando | Resultado |
|---|---|
| `wc -l README.md docs/*.md docs/specs/README.md` | 55, 130, 87, 89, 97 e 43 linhas, todos dentro do alvo |
| Script Python de links relativos e âncoras (README, docs, skills) | nenhum link ou âncora quebrado |
| `grep` de `Q-xx`, `docs/redesign/`, `docs/cicd`, `planejamento`, `specs/NNN`, "Fase N" | só no histórico, no README de specs e na pasta 018 |
| `grep` de emoji nos `.md` e skills | vazio |
| `git diff --name-only 94f3f7e^ HEAD` fora de `.md` | vazio |
| `fvm flutter analyze` / `test` | não rodados: nenhum código mudou |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Seis arquivos nos tamanhos-alvo | passou | contagens acima |
| 2 | Pastas apagadas; 018 e `execucao-fase-5.md` mantidos | passou | `ls docs docs/specs`; `REFACTORING_SUMMARY.md` ausente |
| 3 | Extração conferida item a item | passou | `tasks.md` marcado; comparação com o conteúdo antigo (94f3f7e^) |
| 4 | Regras de design, git, comentários e comandos preservadas | passou | faltavam "push só com pedido explícito" e "procure o equivalente antes de criar"; corrigido em `architecture.md` |
| 5 | Decisões Q-xx e de marca atemporais | passou | `architecture.md`, `admin-panel.md` e tabela de decisões do histórico; sem rótulo Q-xx |
| 6 | Histórico completo | passou | fases 0 a 5, decisões, 15 ressalvas, lições, ideias futuras e recuperação pela tag; leitura do protótipo por Artifact acrescentada |
| 7 | `deployment.md` fiel a workflows e Firebase | passou | conferido com `ci.yml`, `deploy-*.yml`, `firebase.json`, `firestore.rules`; risco da chave revogada acrescentado |
| 8 | Links e menções | passou | script e `grep` |
| 9 | Skills coerentes | passou | só caminhos novos; `sdd-fase` diz que a divisão parte do pedido; fluxo intacto |
| 10 | Sem `.md` extra, sem emoji | passou | `find docs` |
| 11 | Tag só registrada | passou | README de specs e histórico dizem que a orquestradora cria a tag local; tag não existe |
| 12 | analyze e test; diff só `.md` | passou com ressalva | diff conferido; analyze e test não rodados (sem código alterado) |

## Problemas encontrados
- `announce` citado como nome de função, mas a função é `announceToScreenReader` (ajuste, corrigido).
- Perdas pequenas do README de specs e dos planos antigos (regra de push, reaproveitamento, leitura do protótipo, chave exposta): corrigidas.

## Não conferido
- `analyze` e `test` (nenhum arquivo de código mudou).
- Estado de proteção de branches, `.htaccess` do dev e produção: seguem como pendências de infraestrutura nos documentos.
