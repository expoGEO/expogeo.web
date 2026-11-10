# Verificação da 017. Limpeza dos comentários do repositório

- **Data:** 2026-11-10
- **Resultado:** aprovada com ressalvas

A base da conferência de comportamento é `c3e87ea` (estado após a 016); `51198a7..HEAD` também traz a limpeza de código da 016, já verificada.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas |
| `fvm flutter test` (cópia ASCII) | 998 testes passaram |
| `fvm dart format --set-exit-if-changed` nos `.dart` alterados | 0 alterações |
| `fvm flutter build web --release` | concluído |
| Home e `/admin` do build release em 1280 px | carregam (Home com hero e contagens; login do painel) |
| Comparação sem comentários, antes e depois (48 arquivos `.dart`, `.py`, `.sh`, `.yml`, `.yaml`, `.html`) | todos idênticos |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Sem spec, fase, tarefa, protótipo, redesign, Q-NN, T-NN, número | passou | Busca do plano sem ocorrência; com `\b[0-9]{3}\b` a mais, só tamanhos de tela, 200%, 512 × 216, 500 caracteres e 709 (Rec. 709) |
| 2 | Termos temporais só com justificativa | passou | Restam "nova aba", "nova tentativa" e "tenta de novo" (domínio); nenhum "antigo", "agora", "por enquanto" |
| 3 | Sem bloco de 3 linhas ou mais | passou | Script do plano sem saída; docstring de `seed_firestore.py` (4 linhas) reduzida a 2 |
| 4 | Sem inglês | passou | Busca por palavras comuns e leitura de `bin/` |
| 5 | Sem código comentado | passou | Buscas sem saída; `// "--web-experimental-hot-reload"` de `.vscode/launch.json` removido |
| 6 | Sem `///` redundante | passou | Amostra de cerca de 35 arquivos e varredura de `///` curtos; restavam setup do painel (corrigido) e 4 rótulos de grupo em `SubthemeEnum` (removidos) |
| 7 | Todas as áreas revisadas | passou | `tasks.md`; os 424 arquivos do escopo não tocados pela 017 foram varridos por `grep` (comentários no padrão) |
| 8 | Nenhuma mudança de comportamento | passou | Comparação sem comentários idêntica; diff sem `*.g.dart`, `*.freezed.dart`, `content_seed_data.json`, `pubspec.lock`. Linhas com comentário no fim alteradas: `extract_content_to_json.py:33` e `content_model.dart` (`issueYear`), só o texto do comentário |
| 9 | analyze, test, format, build | passou | Tabela acima |
| 10 | `ignore` com motivo | passou | `announce.dart`, `semantics.dart` com motivo; `seed_firestore_utils.dart` ganhou uma linha |
| 11 | README alinhado com a spec | passou | Seção "Comentários e texto" cobre as mesmas regras |

## Problemas encontrados
- `panel_setup.dart` ficou com 5 comentários que repetem o código (ajuste). Corrigido.
- 4 títulos de grupo em `SubthemeEnum` (`theme_data_model.dart`) (detalhe). Removidos.
- `seed_firestore.py`: docstring de 4 linhas (ajuste). Reduzida a 2; a dica de credenciais já é impressa pelo script.
- `seed_firestore_utils.dart`: `ignore_for_file` sem motivo (detalhe). Ganhou uma linha.
- `tasks.md` com a legenda `[x]` repetida (detalhe). Corrigida.

## Ressalvas
- `analysis_options.yaml` e `web/index.html` perderam os comentários padrão do Flutter (aceito; critérios 3 e 5 prevalecem sobre a decisão de manter).
- Comentários de CSS em `web/index.html` e `tool/web_icons/*.html` (`/* */`) não entram na busca do plano; ficam curtos e com o motivo (uma linha, às vezes longa).

## Não conferido
- Modo debug e telas em 390 e 768 px: nada visível muda; só Home e `/admin` em 1280 px no build release.
