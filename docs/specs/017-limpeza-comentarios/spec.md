# 017. Limpeza dos comentários do repositório

- **Status:** verificada com ressalvas
- **Item do planejamento:** Fase 5, item 5.3
- **Protótipo:** não se aplica
- **Criada em:** 2026-11-09

## Objetivo
Deixar em todo o repositório só os comentários que valem a pena: breves, em português, sobre o **porquê** que o código não mostra, e escritos de forma que continuem verdadeiros depois que as specs, o planejamento e o histórico das fases saírem do repositório. Quem usa o site **não vê mudança**, e nenhuma linha de código muda de comportamento.

## Situação atual
Levantamento por busca em 2026-11-09 (antes da limpeza de código da spec 016, que apaga muita coisa e reduz o trabalho aqui):
- Cerca de 660 linhas de comentário `//` e 470 de documentação `///` em `lib/` (sem contar `*.g.dart` e `*.freezed.dart`), 70 em `test/` e centenas em `lib/core/content/` que são só endereços (`https://`), não comentários.
- A maior concentração fica no painel (`lib/features/admin/`, mais de 300 linhas), nos componentes (`lib/core/components/`) e no tema (`lib/core/theme/`).
- As regras do `docs/specs/README.md` ("Comentários e texto") já são seguidas na maior parte: uma busca por `spec`, `Fase`, `Q-0` e `protótipo` em comentários não acha ocorrência direta. Os problemas que restam são de outra natureza:
  - **Origem em vez de motivo:** frases como "porque o formulário antigo gravava o rótulo" (`content_model.dart`), que dependem do histórico do projeto. A busca por "porte do/igual ao Observatório" em comentários não achou nada, mas a revisão por leitura confere de novo.
  - **Tempo:** "antigo", "novo", "agora", "ainda não", "por enquanto". A busca acha cerca de 30 comentários com essas palavras; a maioria é legítima ("nova tentativa", "abre em nova aba", "de novo"), e uns poucos dependem do momento ("código novo", "documento antigo", "SDKs mais novos") e são reescritos.
  - **Redundância:** `///` que repete o nome do método ("Busca um conteúdo específico", "Busca todos os conteúdos de um subtema específico", em datasources e repositórios) ou o tipo do campo.
  - **Tamanho:** 10 blocos de 3 linhas ou mais (por exemplo `panel_filter_bar.dart`, `object_actions.dart`, `reference_code.dart`, cabeçalhos de `bin/seed_firestore_utils.dart`, `tool/*/generate*.sh` e dos workflows).
  - **Idioma:** comentários em inglês em `bin/extract_content_to_json.py` e `bin/extract_content_to_json_v2.py`.
- Fora do código Dart também há comentários: `.github/workflows/*.yml`, `pubspec.yaml`, `analysis_options.yaml` (22 linhas, a maioria padrão do Flutter), `run_seed.sh`, `bin/*.py`, `bin/seed_firestore_utils.dart`, `tool/**/*.sh` e `*.html`, `web/index.html`, `firebase.json`, `firestore.rules`, `.vscode/`.
- Os cabeçalhos de `lib/firebase_options_dev.dart` e `lib/firebase_options_prod.dart` são gerados pelo FlutterFire.

## Comportamento

### Regra de ouro
Um comentário só fica se quem lê o código **não consegue deduzir** o que ele diz e a informação continua útil sem conhecer a história do projeto.

### O que fica
- O **porquê** não óbvio: regra de negócio escondida, contorno de limitação do Flutter, do navegador ou de um pacote, número que parece arbitrário, ordem que importa, motivo de segurança ou de acessibilidade.
- No máximo **uma ou duas linhas** por comentário.
- Texto curto e direto, em português do Brasil, que se entende sem abrir outro arquivo.
- `///` em API pública (classe, método ou campo usado fora do arquivo) **só quando** agrega algo que o nome e o tipo não dizem (unidade, formato, efeito colateral, o que significa "nulo").

### O que sai
- Comentário que repete o código, o nome ou o tipo; descrição de "o que" em vez de "por que".
- Código comentado, `TODO`/`FIXME` sem dono e blocos de decoração (separadores, caixas, linhas de `====`).
- Qualquer menção a **spec, fase, tarefa, item numerado, protótipo, pergunta (Q-xx), critério de aceite, PR, redesign, "antigo/novo/agora/por enquanto"** e a números de spec (`009`, `T-04`). Os comentários devem ser genéricos: as specs vão sumir.
- Menção ao repositório vizinho como origem do código ("porte do Observatório", "igual ao Observatório"). O Observatório continua podendo ser citado quando é **parte do domínio** (o link "Observatório" da navbar, o bloco "Um projeto do Observatório").
- Comentário em inglês, exceto nomes técnicos (nomes de API, de pacote, de campo).
- Comentários gerados (FlutterFire em `firebase_options_*.dart`) e as linhas de padrão do Flutter em `analysis_options.yaml` ficam como estão se não houver como editá-los sem ruído; o resto é revisado.

### Onde vale
Todo o repositório, **exceto** `*.g.dart`, `*.freezed.dart`, `bin/venv/`, `build/`, `.dart_tool/`, arquivos de dados (`bin/content_seed_data.json`, `pubspec.lock`) e os `.md` (que são da spec 018):
`lib/` (inclusive `lib/core/content/`, onde os comentários de conteúdo, se houver, seguem a mesma regra), `test/`, `bin/` (`*.py`, `*.dart`), `tool/` (`*.sh`, `*.html`), `.github/workflows/`, `pubspec.yaml`, `analysis_options.yaml`, `firebase.json`, `firestore.rules`, `firestore.indexes.json`, `run_seed.sh`, `web/index.html`, `web/manifest.json` e `.vscode/`.

### Comentário de teste
Em `test/`, o comentário também só diz o porquê (por que aquela largura, por que aquele contorno). O nome do teste já diz o que ele confere; comentário que repete o nome do teste sai.

## Estados
Não se aplica.
- **Casos de borda:** comentário `// ignore:` e `// ignore_for_file:` (do analisador) **não são** comentários de texto: ficam como estão, mas cada `ignore` sem motivo evidente ganha uma linha de porquê ou é removido se o aviso não existir mais. Anotações `///` que o gerador do MobX/Freezed precisa ler continuam. Comentário que explica um contorno de bug do Flutter 3.35.5 no web fica, sem citar a spec que o descobriu.

## Responsivo
Não se aplica.

## Acessibilidade
Não se aplica. Comentários sobre contorno de acessibilidade (por exemplo, por que `announce` em vez de região viva) **ficam**, pelo valor que têm.

## Dados e regras de negócio
Nenhuma linha que não seja comentário muda. Nada de renomear, reformatar além do `dart format` de arquivo já alterado, mover código ou "aproveitar para" corrigir outra coisa.

## Critérios de aceite
- [ ] 1. Busca por comentário com `spec`, `specs`, `fase`, `tarefa`, `protótipo`, `prototipo`, `redesign`, `Q-NN`, `T-NN`, `CA NN`, `PR #NN`, `item N` ou número de spec entre parênteses (ex.: `(009)`) não acha nada em nenhum arquivo do escopo (comando exato no plano, tarefa 0.2).
- [ ] 2. Busca por `antigo`, `antiga`, `novo`, `nova`, `agora`, `por enquanto`, `ainda não`, `provisório`, `temporário`, `legado` em comentários só acha uso justificado (o adjetivo faz parte do domínio, não da história); cada uso restante é listado no `verificacao.md` com o motivo.
- [ ] 3. Nenhum comentário com mais de duas linhas seguidas em `lib/`, `test/`, `bin/`, `tool/`, workflows e `web/` (excetuando `firebase_options_*.dart`, gerados); o script de blocos do plano acha zero blocos de 3 ou mais linhas fora dessa exceção.
- [ ] 4. Nenhum comentário de texto em inglês (verificado por leitura dos arquivos de `bin/` e por busca de palavras comuns em inglês nos comentários).
- [ ] 5. Nenhum código comentado (busca por `// ` seguido de instrução Dart, `# ` seguido de comando, `<!-- <tag` e afins).
- [ ] 6. Nenhum `///` que apenas repita o nome do membro: revisão por área registrada no `verificacao.md`, com a lista dos removidos (contagem por área) e três exemplos do que ficou.
- [ ] 7. Cada área da lista do plano foi revisada por inteiro e marcada em `tasks.md`; os arquivos listados em "Onde vale" têm todos passagem registrada, inclusive os que ficaram sem alteração.
- [ ] 8. Nenhuma mudança de comportamento: o `git diff -U0` da entrega, depois de ignorar linhas que são só comentário ou em branco, não tem linha de código alterada (a única exceção são linhas de código com comentário no fim, listadas e justificadas no `verificacao.md`); `git diff --stat` não toca `*.g.dart`, `*.freezed.dart`, `bin/content_seed_data.json`, `pubspec.lock`.
- [ ] 9. `fvm flutter analyze` sem avisos e `fvm flutter test` passando, em cópia de caminho ASCII; `fvm dart format --set-exit-if-changed` nos `.dart` alterados sem diferenças; `fvm flutter build web --release` passa.
- [ ] 10. Os `ignore`/`ignore_for_file` restantes têm motivo evidente ou uma linha de porquê.
- [ ] 11. A regra de comentários do `docs/specs/README.md` continua dizendo o mesmo que esta spec (ou é atualizada em conjunto, com nota no histórico).

## Fora do escopo
- Reescrever documentação `.md` (spec 018) e remover código sem uso (spec 016).
- Renomear, reformatar ou reorganizar código; corrigir bugs vistos durante a revisão (anotar à parte se achar).
- Escrever docstrings novas onde não há: a spec só tira e encurta; só entra um `///` novo se um comentário removido ou reescrito for substituído por ele, mantendo o porquê.
- Comentários de arquivos gerados e de dependências.

## Perguntas em aberto
- Nenhuma.
- Decidido no modo autônomo: rodar esta spec depois da 016, porque a limpeza de código apaga muitos comentários junto e evita revisar o que vai sumir.
- Decidido no modo autônomo: manter os cabeçalhos gerados do FlutterFire (`firebase_options_*.dart`) e as linhas padrão do `analysis_options.yaml`, porque são gerados ou do modelo do Flutter e uma regeneração os traria de volta.
- Decidido no modo autônomo: números de tamanho de tela (390, 768, 1280) e valores como "200%" em comentário são permitidos, porque descrevem o motivo (contexto de teste ou de layout), não uma referência a spec; o critério 1 usa a regra de "número de spec entre parênteses" e não proíbe números.
- Decidido no modo autônomo: traduzir para o português, e não apagar, o que valer a pena dos comentários em inglês de `bin/*.py`; o que for óbvio sai.
- Decidido no modo autônomo: `///` novo só entra para substituir um porquê que seria perdido.

## Histórico de mudanças
- 2026-11-09: criada.
- 2026-11-09: aprovada (modo autônomo).
- 2026-11-10: implementada. `analysis_options.yaml` perdeu o texto padrão do modelo (critérios 3 e 5 prevalecem sobre a decisão de mantê-lo).
- 2026-11-10: verificada com ressalvas (`verificacao.md`).
