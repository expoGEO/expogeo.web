# Tarefas da 017. Limpeza dos comentários do repositório

Legenda: `- [x]` a fazer, `- [x]` feita.

Critérios de aceite da spec, na ordem: CA1 sem termos de spec/fase/tarefa/protótipo/redesign/Q-xx/número; CA2 termos temporais só com justificativa; CA3 nenhum bloco de 3 linhas ou mais; CA4 sem inglês; CA5 sem código comentado; CA6 sem `///` redundante; CA7 todas as áreas revisadas por inteiro; CA8 nenhuma mudança de comportamento; CA9 analyze, testes, format e build; CA10 `ignore` com motivo; CA11 regra do `docs/specs/README.md` alinhada.

Regras de todas as tarefas de área: ler cada arquivo inteiro; aplicar os sete critérios de decisão do plano; só comentário muda; depois da área, rodar na cópia ASCII `fvm flutter analyze` (sem avisos) e `fvm flutter test` (verde) e o diff-check do plano (saída vazia); um commit por área (`docs: comentários de <área>`); no corpo, listar os comentários de contorno mantidos ou reescritos. Marcar `[x]` com a contagem aproximada de comentários antes e depois.

## Grupo 0: preparação
- [x] **0.1.** Conferir que a 016 já está implementada (`git log` com os commits de limpeza). Anotar o `<base>` (commit antes do primeiro commit desta spec). Sincronizar a cópia ASCII e confirmar `analyze` e `test` verdes antes de começar. Atende: CA9.
- [x] **0.2.** Definir no terminal as funções `escopo` e `em_comentario` do plano; rodar as buscas dos CA1, CA2, CA3 e CA5 e guardar a lista inicial no scratchpad (não no repositório). Atende: CA1, CA2, CA3, CA5.

## Grupo A: Dart de `lib/`
- [x] **A1. Área 1.** `lib/main.dart`, `lib/core/navigation/`, `lib/core/pages/`, `lib/core/utils/` (inclui `browser/leave_guard*.dart`, `url/mail_draft.dart`). Atende: CA1, CA2, CA6, CA7.
- [x] **A2. Área 2.** `lib/core/models/` (os dois `///` "o formulário antigo gravava o rótulo" de `content_model.dart` viram a regra atual, ex.: "Aceita o nome ou o rótulo, porque há objetos gravados dos dois jeitos"), `lib/core/theme/` (inclui comentários de tokens: ficam os que dizem contraste ou uso restrito, saem os que repetem o nome da cor) e comentários de `lib/core/content/`. Atende: CA1, CA2, CA6, CA7.
- [x] **A3. Área 3.** `lib/core/components/`. Atenção a `///` de widgets que só dizem "Botão de…" ou "Campo de…" e aos contornos de acessibilidade (ficam). Atende: CA1, CA2, CA6, CA7, CA10.
- [x] **A4. Área 4.** `lib/features/admin/login/`, `admin_setup.dart`, `panel/infra/` (datasources e repositories: sai o `///` que repete o nome, como "Busca um conteúdo específico"; ficam as regras do formato gravado, do código como id e da transação) e `panel/presentation/stores/`. Atende: CA1, CA2, CA6, CA7.
- [x] **A5. Área 5.** `lib/features/admin/panel/presentation/` (`components/`, `editor/`, `pages/`, `panel_address.dart`, `panel_list_memory.dart`). Reescrever "novo/nova" que depende da história (ex.: "o novo objeto" para "o objeto em criação"); encurtar os blocos de 3 linhas de `panel_filter_bar.dart` e `object_actions.dart`. Atende: CA1, CA2, CA3, CA6, CA7.
- [x] **A6. Área 6.** `lib/features/catalog/`, `home/`, `theme/`, `about/`, `contact/`. Atende: CA1, CA2, CA6, CA7.
- [x] **A7.** Gate do grupo A: buscas dos CA1 e CA5 vazias em `lib/`; `analyze`, `test` e `format --set-exit-if-changed` nos `.dart` tocados. Atende: CA1, CA5, CA9.

## Grupo B: testes
- [x] **B1. Área 7.** `test/core/`, `test/features/`, `test/support/`. Sai o comentário que repete o nome do teste; ficam os de largura/contorno/SDK (reescrever "SDKs mais novos que o 3.35.5" e "Em versões novas do Flutter" sem depender de data, dizendo a condição). Atende: CA1, CA2, CA6, CA7.

## Grupo C: fora do Dart
- [x] **C1. Área 8.** `bin/extract_content_to_json.py`, `bin/extract_content_to_json_v2.py`, `bin/seed_firestore.py`, `bin/seed_firestore_utils.dart` (o cabeçalho de 4 linhas encurta; `///` de comando sem valor sai), `run_seed.sh`. Traduzir para português o que ficar (hoje há comentários em inglês nos dois `extract_*`). Conferir que os scripts continuam com a mesma sintaxe: `python3 -m py_compile bin/*.py` (cópia no scratchpad, sem criar `__pycache__` no repositório) e `bash -n run_seed.sh`; o seed em si não é executado. Atende: CA4, CA6, CA7, CA8.
- [x] **C2. Área 9, parte 1.** `.github/workflows/*.yml` (reescrever "código novo" para a regra atual: "Antes do site, porque o código depende das regras e dos índices"; encurtar o cabeçalho de 3 linhas), `pubspec.yaml`, `analysis_options.yaml` (manter as linhas padrão do Flutter, remover o que é nosso e redundante), `firebase.json`, `firestore.rules`, `firestore.indexes.json`, `.vscode/*`. YAML e JSON continuam válidos: `python3 -c "import yaml"` não é garantido; usar `fvm dart pub get` (pubspec) e o `analyze` como prova, e ler os workflows com atenção à indentação. Atende: CA1, CA2, CA3, CA7.
- [x] **C3. Área 9, parte 2.** `tool/web_icons/*.sh` e `*.html`, `web/index.html` (comentários do Analytics e de metadados ficam só se dizem porquê; os marcadores `<!-- analytics:inicio -->` e `<!-- analytics:fim -->` **não podem mudar**, o `deploy-dev.yml` procura por eles), `web/manifest.json`. `bash -n` nos `.sh`. Se o `tool/images/` ainda existir (016 não rodou), tratá-lo igualmente. Atende: CA1, CA3, CA7, CA8.
- [x] **C4.** Em `firebase_options_dev.dart` e `firebase_options_prod.dart` (gerados) nada muda; registrar no `verificacao.md` que ficaram de fora e por quê. Atende: CA7.

## Grupo D: regra e conferência final
- [x] **D1.** Reler a seção "Comentários e texto" do `docs/specs/README.md`: ela já cobre o que esta spec pede (porquê, 1-2 linhas, sem citar spec/fase/protótipo). Se faltar algo (código vizinho como origem, tempo verbal "antigo/novo", `///` só quando agrega), acrescentar em uma frase. Na spec 018 esse README é reescrito: passar o ajuste para o texto da 018 se ela ainda não rodou. Atende: CA11.
- [x] **D2.** Rodar todas as buscas do plano sobre o repositório inteiro: CA1 e CA5 vazias, CA3 sem blocos (exceto `firebase_options_*`), CA2 com a lista de usos legítimos; CA4 por leitura rápida dos `bin/*.py` e busca de palavras inglesas (`the `, ` of `, ` for `, `first`, `check`) em comentários. Anotar a lista de CA2 e a contagem de `///` removidos por área para o `verificacao.md`. Atende: CA1, CA2, CA3, CA4, CA5, CA6.
- [x] **D3.** Diff-check completo contra `<base>`: saída vazia (ou linhas justificadas); `git diff --stat` sem `*.g.dart`, `*.freezed.dart`, `content_seed_data.json`, `pubspec.lock`. Atende: CA8.
- [x] **D4.** Cópia ASCII limpa: `fvm flutter analyze` sem avisos, `fvm flutter test` verde, `fvm dart format --set-exit-if-changed` nos `.dart` tocados, `fvm flutter build web --release`. Servir o build e abrir Home (390 e 1280) e `/admin` uma vez, sem erro no console. Status da spec para `implementada`. Atende: CA9, CA10.

## Notas da execução (modo autônomo)
- Contagem aproximada: cerca de 130 comentários removidos e 25 reescritos ou encurtados (lib/core ~35, lib/features ~70, bin ~60 linhas, config e web ~35); os comentários de contorno (foco, semântica, SDK, transação, FTP) foram mantidos.
- C4: `firebase_options_*.dart` ficaram de fora por serem gerados.
- Divergência de `analysis_options.yaml`: o texto padrão do modelo do Flutter e as linhas comentadas de exemplo foram removidos (a spec previa mantê-los), porque os critérios 3 e 5 exigem zero blocos de 3 linhas e zero código comentado. Em `lib/core/theme/app_dimensions` e `app_text_styles` os `///` ficaram, por trazerem unidade ou uso.
- Verificação do critério 8: o código sem comentários de cada `.dart` alterado é idêntico ao da base; o AST dos `.py` é igual fora das docstrings.
