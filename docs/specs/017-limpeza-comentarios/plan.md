# Plano da 017. Limpeza dos comentários do repositório

- **Spec:** spec.md
- **Criado em:** 2026-11-09

## Abordagem
Revisão **por área**, lendo cada arquivo inteiro (não só os trechos achados por busca) e decidindo comentário a comentário: fica, encurta, reescreve de forma genérica ou sai. Cada área vira um commit só de comentários (`docs: comentários de <área>`), com `analyze` e testes entre elas, para qualquer problema ser achado perto de onde nasceu.

Roda **depois da 016** (a limpeza de código já terá apagado componentes inteiros com seus comentários) e **antes da 018** (que apaga as specs; nada aqui depende delas).

Critérios de decisão, aplicados em ordem a cada comentário:
1. Repete o que o código ou o nome já diz? **Sai.**
2. Cita spec, fase, tarefa, item, protótipo, Q-xx, PR, redesign ou o repositório vizinho como origem? **Reescreve só com o porquê, ou sai.**
3. Só faz sentido para quem sabe a história ("antigo", "novo", "agora", "por enquanto")? **Reescreve com a regra atual, sem tempo, ou sai.**
4. Passa de duas linhas? **Encurta** para o essencial; se não couber, o motivo provavelmente é do `docs/architecture.md` e não do código.
5. Está em inglês? **Traduz** ou sai.
6. É `///` de membro público que só repete o nome ou o tipo? **Sai.** Se traz unidade, formato, efeito colateral ou significado de nulo, **fica**, em até duas linhas.
7. Explica contorno de limitação (Flutter 3.35.5 no web, `SelectionArea`, `announce`, cache do Firestore, FTP, Chrome sem janela)? **Fica**, curto, sem dizer quem descobriu.

Nada além de comentário muda. `dart format` só roda nos `.dart` tocados, e só para confirmar que não alterou nada além do esperado.

## Arquivos
Áreas (todas revisadas por inteiro; contagem aproximada de linhas de comentário na data do levantamento, antes da 016):

| Área | Pastas e arquivos | Linhas |
|---|---|---|
| 1. Raiz e navegação | `lib/main.dart`, `lib/core/navigation/`, `lib/core/pages/`, `lib/core/utils/` | ~65 |
| 2. Modelos, tema e conteúdo | `lib/core/models/`, `lib/core/theme/`, `lib/core/content/` (comentários que não sejam endereços) | ~120 |
| 3. Componentes do núcleo | `lib/core/components/` | ~130 |
| 4. Painel: login e dados | `lib/features/admin/login/`, `lib/features/admin/admin_setup.dart`, `lib/features/admin/panel/infra/`, `.../presentation/stores/` | ~210 |
| 5. Painel: telas | `lib/features/admin/panel/presentation/` (`components/`, `editor/`, `pages/`, `panel_address.dart`, `panel_list_memory.dart`) | ~190 |
| 6. Funcionalidades públicas | `lib/features/catalog/`, `home/`, `theme/`, `about/`, `contact/` | ~90 |
| 7. Testes | `test/core/`, `test/features/`, `test/support/` | ~70 |
| 8. Scripts de dados | `bin/*.py`, `bin/seed_firestore_utils.dart`, `run_seed.sh` | ~60 |
| 9. Ferramentas, CI e configuração | `tool/**/*.sh` e `*.html`, `.github/workflows/*.yml`, `pubspec.yaml`, `analysis_options.yaml`, `firebase.json`, `firestore.rules`, `firestore.indexes.json`, `web/index.html`, `web/manifest.json`, `.vscode/*` | ~110 |

Fora: `lib/firebase_options_*.dart` (gerados), `*.g.dart`, `*.freezed.dart`, `bin/venv/`, `build/`, `.dart_tool/`, `bin/content_seed_data.json`, `pubspec.lock`, os `.md`.

## Decisões técnicas
- **Ordem das áreas.** Do mais isolado ao mais cheio: 1, 2, 3, depois o painel (4 e 5), as funcionalidades públicas (6), testes (7) e o que não é Dart (8 e 9). Os testes vêm depois do código porque alguns comentários de teste explicam o mesmo contorno que o código.
- **Sem ferramenta automática de remoção.** Remoção por script de comentários apaga contornos importantes. As buscas só **listam** candidatos; a decisão é por leitura.
- **Sem comentário novo "para compensar".** Se um comentário sai e o código fica confuso, a correção é do código (nome melhor), e isso é outra entrega: anotar no relatório, não fazer aqui.
- **Alternativas descartadas:** deixar a regra só no `docs/specs/README.md` (já está lá e não impediu a deriva); proibir `///` por completo (perde unidades e formatos úteis).
- **Linhas de código com comentário no fim** (`x = 5; // motivo`): mover o comentário para a linha de cima muda uma linha de código no diff. Evitar; encurtar ou remover no lugar. Se for inevitável, listar no `verificacao.md`.

## Dependências e geração de código
Nenhuma. Nenhuma rota, pacote, store ou modelo gerado muda; `build_runner` não roda (e se rodar por engano, o diff de `*.g.dart` deve ser descartado).

## Riscos e cuidados
- **Remover um porquê importante.** Mitigação: na dúvida, manter encurtado; contornos de limitação (critério 7 acima) ficam. Cada commit lista, no corpo, os comentários de contorno que foram mantidos ou reescritos.
- **Tocar em código sem querer.** O diff-check abaixo roda a cada commit; `git diff --stat` não deve mostrar arquivos gerados.
- **`// ignore:` e `// ignore_for_file:`** são lidos pelo analisador; não apagar sem rodar `analyze`.
- **Anotações `///` de ferramentas.** Conferir se algum `.g.dart` não depende do texto (não depende, mas `analyze` e `test` provam).
- **Texto de interface dentro de comentário.** Comentário que cita texto de tela ("Carregando…", "Tentar de novo") é aceito se explica um comportamento; se for só lista de textos, sai.
- **Caminho com "ó".** Ferramentas rodam na cópia ASCII do scratchpad (`rsync -a --delete --exclude build --exclude .dart_tool --exclude .git --exclude bin/venv`).

## Como conferir
Comandos usados pelas tarefas (a partir da raiz, em `bash`):

```sh
# Lista de arquivos do escopo (texto de comentário, sem gerados, dados, binários e firebase_options_*)
escopo() { git ls-files -z lib test bin tool .github web .vscode run_seed.sh pubspec.yaml analysis_options.yaml firebase.json firestore.rules firestore.indexes.json \
  | grep -zvE '\.(g|freezed)\.dart$|^bin/venv/|^bin/content_seed_data\.json$|\.(png|webp|svg|ttf|jpg|ico)$|^lib/firebase_options_'; }
# Procura em comentários (//, ///, #, <!--); $1 é a regex
em_comentario() { escopo | xargs -0 grep -nEi "(^|[[:space:]])(//|#|<!--)[^\"']*($1)"; }

# Critério 1 (deve sair vazio)
em_comentario '\bspecs?\b|\bfase\b|\btarefa\b|prot[oó]tipo|redesign|\bQ-[0-9]+|\bT-[0-9]+|\bCA ?[0-9]+|\bPR ?#?[0-9]+|\bitem [0-9]|\([0-9]{3}\)'
# Critério 2 (cada resultado precisa de justificativa)
em_comentario '\bantig[oa]s?\b|\bagora\b|por enquanto|ainda n[aã]o|provis[oó]ri|tempor[aá]ri|legado|\bnov[oa]s?\b|porte d|igual ao observat'
# Critério 5 (deve sair vazio)
em_comentario '(final|return|await|const|var|import) [a-z_(]' | grep -E '(//|#)\s*(final|return|await|const|var|import) '

# Critério 3: blocos de 3 ou mais linhas de comentário seguidas (deve sair 0, fora firebase_options_*)
escopo | xargs -0 awk 'FNR==1{n=0} /^[[:space:]]*(\/\/|#|<!--)/ && !/^#!/ {n++; if(n==3) print FILENAME":"FNR; next} {n=0}'

# Critério 8: nenhuma linha de código mudou (deve sair vazio; saída = linhas alteradas que não são comentário nem vazias)
git diff -U0 <base> -- . ':!*.g.dart' ':!*.freezed.dart' | grep -E '^[+-]' | grep -vE '^(\+\+\+|---)' | grep -vE '^[+-][[:space:]]*(//|#|<!--|-->|\*|$)'
git diff --stat <base> | grep -E '\.g\.dart|\.freezed\.dart|content_seed_data|pubspec\.lock'   # deve sair vazio
```

Depois, na cópia ASCII: `fvm flutter analyze`, `fvm flutter test`, `fvm dart format --set-exit-if-changed` nos `.dart` tocados e `fvm flutter build web --release`. O app não precisa ser percorrido em tela (nada visível muda), mas a última tarefa abre a Home e o painel uma vez no navegador para confirmar que o build serve.
