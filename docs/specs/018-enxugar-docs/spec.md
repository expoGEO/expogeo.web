# 018. Enxugar a documentação

- **Status:** implementada
- **Item do planejamento:** Fase 5, item 5.4
- **Protótipo:** não se aplica
- **Criada em:** 2026-11-09

> Modelo: `../observatorio_geo_hist/docs/` (`architecture.md`, `admin-panel.md`, `deployment.md`, `future-ideas.md`, `redesign-history.md`, `specs/README.md`) e o `README.md` dele.

## Objetivo
Reduzir os `.md` do repositório ao mínimo que continua verdadeiro depois do redesign: o que o projeto é, como rodar, como está organizado, como o painel funciona, como se publica e um histórico curto do redesign. Specs, planos, tarefas, verificações e o planejamento saem do repositório, depois de terem as decisões, regras e ressalvas ainda abertas passadas para os documentos que ficam. Quem usa o site **não vê mudança**.

## Situação atual
Conferida em 2026-11-09.
- `README.md` (cerca de 330 linhas): visão geral, estrutura, tecnologias, funcionalidades, temas de exemplo (lista que já não bate com os dados), configuração, breakpoints, design system, arquitetura, convenções, testes, links externos. Mistura o que é a entrada do projeto com arquitetura e design system.
- `docs/specs/README.md`: fluxo SDD, regras de design ao implementar, comandos, git, comentários. Concentra as regras visuais e de código que as specs seguiram.
- `docs/specs/001` a `015`: quinze pastas com `spec.md`, `plan.md`, `tasks.md` e `verificacao.md` (cerca de 4.500 linhas), mais `016` e `017` (que esta spec trata como já implementadas) e a própria `018`.
- `docs/specs/historico-redesign.md`: tabela das fases 0 a 4, 20 pendências em aberto e 18 lições.
- `docs/redesign/planejamento.md`: decisões de marca, telas do protótipo, princípios, fases, mapa das specs, perguntas respondidas (Q-01, Q-03, Q-04, Q-05, Q-07), fora do escopo e riscos.
- `docs/cicd/planejamento.md`: plano de CI/CD com o estado final dos ambientes, workflows, GitHub, HostGator, Firebase, etapas E0 a E9 (as manuais E2, E7, E8 ainda abertas) e riscos.
- `lib/features/theme/REFACTORING_SUMMARY.md`: apagado pela 016 (se ainda existir, apagar aqui).
- `.claude/skills/sdd-{fase,spec,plan,implement,verify}/SKILL.md` apontam para `docs/redesign/planejamento.md`, `docs/specs/historico-redesign.md`, `docs/cicd/` e para as pastas de spec.
- Não existe `CLAUDE.md`.
- `docs/specs/execucao-fase-5.md` e a pasta `018-enxugar-docs` existem enquanto a fase roda; saem no encerramento da fase, **não** por esta spec.

## Comportamento

### Estrutura final dos `.md`
| Arquivo | Conteúdo | Tamanho-alvo |
|---|---|---|
| `README.md` | O que é o projeto, requisitos, como rodar, build, testes e seed, ponteiros para `docs/` | até 60 linhas |
| `docs/architecture.md` | Fundação (Flutter Web, Firebase, MobX, GetIt, GoRouter, `Either`), estrutura de pastas, camadas de uma feature, `core`, tema e tokens, design system e regras visuais, rotas, catálogo único e Firestore, acessibilidade, páginas e componentes principais, decisões que ainda valem, convenções e como adicionar uma feature | até 260 linhas |
| `docs/admin-panel.md` | Login, moldura, lista de objetos, editor, regras de acesso e de gravação, formato dos dados, pontos de atenção | até 180 linhas |
| `docs/deployment.md` | Ambientes, fluxo de branches, workflows, segredos, diferenças entre dev e produção, Firebase (índices, regras), servidor, operação | até 130 linhas |
| `docs/redesign-history.md` | Fases e specs condensadas (incluindo 016, 017 e 018), decisões de design e de produto que ficaram, ressalvas ainda abertas, lições, fora do escopo e ideias futuras, como recuperar o material apagado | até 150 linhas |
| `docs/specs/README.md` | Fluxo SDD, regras, o que fazer depois do merge, tag `redesign-specs`, quando usar | até 50 linhas |

Todos em português do Brasil, sem emoji, sem tabela de "andamento" e sem citar spec, fase ou protótipo como fonte de uma regra (o histórico é o único lugar onde fases e specs aparecem).

### O que vai para onde (antes de apagar)
- **De `docs/specs/README.md` para `docs/architecture.md`:** regras de design ao implementar (tokens, breakpoints, `#C94400`, degradê só decorativo, contraste 4,5:1, foco e nome acessível, medalhão 1:1, estados obrigatórios, larguras 390/768/1280, rotas em português), comandos, padrão de git e de comentários (resumido). Fluxo e regras SDD ficam no README de specs.
- **De `docs/redesign/planejamento.md`:** as decisões de marca/cor/degradê/fonte/ilustrações/rotas/contato/painel e as respostas Q-01, Q-03, Q-04, Q-05 e Q-07 viram texto atemporal em `architecture.md` e `admin-panel.md`, e uma tabela curta de decisões em `redesign-history.md`; fora do escopo e ideias (busca geral do site, modo escuro, criar/editar temas e subtemas) vão para a seção de ideias futuras do histórico; telas T-01 a T-10 viram a tabela de rotas da arquitetura; o mapa das specs vira a tabela de fases.
- **De cada spec/plano/tarefas/verificação (001 a 017):** as decisões técnicas que continuam valendo (formato dos dados, regras de acesso, padrões de componente, contornos de limitação do Flutter), as perguntas "Decidido", as ressalvas em aberto e as lições. Detalhe de tarefa, critério de aceite e evidência de conferência não sobrevivem.
- **De `docs/redesign/historico-redesign.md` (em `docs/specs/`):** a tabela, as pendências ainda abertas (conferidas contra o código e o estado atual, descartando as resolvidas) e as lições, de forma breve.
- **De `docs/cicd/planejamento.md`:** o estado final (ambientes, fluxo, workflows, GitHub, HostGator, Firebase) e os riscos que ainda valem vão para `deployment.md`; as etapas manuais E2, E7 e E8 ainda abertas e o que faltar viram "Pendências de infraestrutura" no mesmo documento ou nas ressalvas do histórico; a lista de etapas concluídas não sobrevive.

### O que é apagado
`docs/specs/001-*` a `017-*` (pastas inteiras), `docs/redesign/` (o `planejamento.md`), `docs/cicd/`, `docs/specs/historico-redesign.md` (depois de condensado em `docs/redesign-history.md`) e `lib/features/theme/REFACTORING_SUMMARY.md` (se ainda existir). **Não apaga** `docs/specs/018-enxugar-docs/` nem `docs/specs/execucao-fase-5.md`: a orquestradora os apaga no encerramento da fase. O `verificacao.md` e a própria spec 018, assim como as 016 e 017, entram no histórico condensado antes de sumirem.

### Links e skills
- Todos os links relativos de `.md` do repositório (README, docs, skills) apontam para arquivos que existem. Não sobra link para `docs/redesign/planejamento.md`, `docs/cicd/`, `docs/specs/NNN-*` (exceto dentro do histórico, onde a pasta é citada como "recuperável pela tag", sem link clicável).
- As skills em `.claude/skills/sdd-*` recebem ajuste mínimo (caminhos e nomes de arquivo):
  - `sdd-spec`: lê `docs/specs/README.md` e `docs/architecture.md`; o item vem do pedido (ou de `docs/redesign-history.md`, seção de ideias futuras); sem planejamento por fase.
  - `sdd-plan`, `sdd-implement`, `sdd-verify`: trocam `docs/redesign/planejamento.md` e "seção Arquitetura de Código do README" por `docs/architecture.md`; o passo de "marcar o item no planejamento" some (a verificação só atualiza o status da spec).
  - `sdd-fase`: o histórico passa a ser `docs/redesign-history.md` (criar o arquivo se faltar); o texto deixa claro que, **sem planejamento da fase, a divisão em specs vem do pedido da pessoa**; as partes que mandam "ler a seção da fase em planejamento.md" e "lista de perguntas Q-xx" passam a "ler o pedido e o `docs/architecture.md`"; as referências a `execucao-<fase>.md` e à tabela de execução continuam.
  - Nome do arquivo de verificação continua `verificacao.md`.

### Tag
Antes de remover, o plano anota o commit (SHA) em que as pastas ainda existem. A orquestradora, no encerramento da fase, cria a tag **local** `redesign-specs` apontando para esse commit (sem `git push` de tag), como o Observatório faz. O `docs/specs/README.md` e o `docs/redesign-history.md` explicam como consultar o material apagado (`git show redesign-specs:docs/redesign/planejamento.md`, `git ls-tree -r --name-only redesign-specs docs/specs`). A spec e o plano **não criam** a tag.

## Estados
Não se aplica.
- **Casos de borda:** link âncora para um título que mudou; tabelas com `|` dentro de código; documento que o `.github/workflows/ci.yml` trata como "só docs" (continua valendo: `docs/` e `*.md` pulam o CI e o deploy).

## Responsivo
Não se aplica.

## Acessibilidade
Não se aplica ao site. Nos `.md`: títulos em ordem, tabelas só quando comparam dados, texto de link que diz o destino.

## Dados e regras de negócio
Nenhum código, dado, rota ou workflow muda. As regras do Firestore e dos deploys são descritas como estão, conferidas em `firestore.rules`, `firebase.json` e `.github/workflows/*.yml`.

## Critérios de aceite
- [ ] 1. Existem `README.md` (até 60 linhas), `docs/architecture.md`, `docs/admin-panel.md`, `docs/deployment.md`, `docs/redesign-history.md` e `docs/specs/README.md`, cada um dentro do tamanho-alvo da tabela.
- [ ] 2. Não existem mais `docs/specs/001-*` a `017-*`, `docs/redesign/`, `docs/cicd/`, `docs/specs/historico-redesign.md` nem `lib/features/theme/REFACTORING_SUMMARY.md`; **existem** `docs/specs/018-enxugar-docs/` e `docs/specs/execucao-fase-5.md`.
- [ ] 3. Cada item da lista de extração do plano (tarefa B) está no documento de destino; a lista foi marcada item a item em `tasks.md` antes de qualquer remoção.
- [ ] 4. As regras de design, de git, de comentários e os comandos do antigo `docs/specs/README.md` estão em `docs/architecture.md` (e o fluxo SDD em `docs/specs/README.md`), sem perda: cada regra do original aparece no destino.
- [ ] 5. As decisões Q-01, Q-03, Q-04, Q-05 e Q-07 e as decisões de marca do planejamento aparecem como texto atemporal em `architecture.md`, `admin-panel.md` ou `redesign-history.md`, sem o rótulo "Q-xx" fora do histórico.
- [ ] 6. `docs/redesign-history.md` tem: tabela de fases (0 a 5), decisões de design, ressalvas ainda em aberto (cada uma conferida contra o código ou marcada "não conferida"), lições, fora do escopo e ideias futuras, e como recuperar o material pela tag; as specs 016, 017 e 018 e as verificações aparecem condensadas.
- [ ] 7. `docs/deployment.md` descreve ambientes, fluxo, workflows, segredos, diferenças dev e produção, Firebase e servidor como estão em `.github/workflows/`, `firebase.json` e `firestore.*`, e lista como pendência o que ainda depende de ação manual.
- [ ] 8. Nenhum link relativo quebrado em qualquer `.md` do repositório (verificação por script do plano, tarefa D1) e nenhuma menção a `docs/redesign/planejamento.md`, `docs/cicd/` ou `docs/specs/NNN-` fora do histórico.
- [ ] 9. As cinco skills `sdd-*` não citam arquivos apagados; `sdd-fase` usa `docs/redesign-history.md` e explica que, sem planejamento, a fase vem do pedido; cada skill continua legível e o fluxo (spec, plano, implementação, verificação) não perde etapa.
- [ ] 10. Nenhum `.md` novo fora da lista, sem emoji, sem "Fase N"/"spec NNN" fora do histórico e do README de specs.
- [ ] 11. O README de specs e o plano registram que a orquestradora cria a tag local `redesign-specs` no encerramento (sem push de tag); a tag **não** foi criada por esta spec.
- [ ] 12. `fvm flutter analyze` e `fvm flutter test` continuam verdes e `git diff --stat` só tem `.md` e `.claude/skills/*/SKILL.md`.

## Fora do escopo
- Qualquer mudança de código, dados, rotas, workflows ou regras.
- Reescrever o conteúdo das skills além do ajuste mínimo.
- Criar a tag `redesign-specs`, fazer push de tag, apagar a própria pasta 018 e o `execucao-fase-5.md` (da orquestradora).
- Criar `CLAUDE.md`, `future-ideas.md` separado ou novos documentos.

## Perguntas em aberto
- Nenhuma.
- Decidido no modo autônomo: ideias futuras e fora do escopo ficam numa seção de `redesign-history.md`, sem criar `future-ideas.md`, porque são poucas (busca geral, modo escuro, criar/editar temas e subtemas) e a lista de arquivos alvo da fase não o inclui.
- Decidido no modo autônomo: a 018 roda por último e trata 016 e 017 como implementadas; se uma delas ficar com ressalva, o histórico registra a ressalva em vez de a limpeza ser refeita aqui.
- Decidido no modo autônomo: as pendências do histórico atual são reconferidas contra o código antes de entrar no novo histórico; as já resolvidas (por exemplo, a dos botões antigos pela 016) saem.
- Decidido no modo autônomo: o plano de CI/CD vira `docs/deployment.md` (não `deploy-ambientes.md`), porque é o nome do Observatório e o mesmo conteúdo.
- Decidido no modo autônomo: a tag aponta para o último commit antes da remoção, e quem a cria é a orquestradora, local e sem push, porque tag é publicação de referência e fica fora de uma spec de documentação.

## Histórico de mudanças
- 2026-11-09: criada.
- 2026-11-09: aprovada (modo autônomo).
- 2026-11-10: implementada. Ideias futuras ficaram no histórico; a pendência do `.htaccess` do dev e a proteção de branches entraram como não conferidas.
