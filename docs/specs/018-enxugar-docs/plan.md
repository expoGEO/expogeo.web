# Plano da 018. Enxugar a documentação

- **Spec:** spec.md
- **Criado em:** 2026-11-09

## Abordagem
Três movimentos, nesta ordem e **sem apagar nada antes do fim do segundo**:
1. **Escrever os documentos novos** a partir do código e dos documentos antigos (arquitetura, painel, deploy, histórico, README de specs, README).
2. **Conferir a extração:** cada item da lista abaixo (seção "Lista de extração") é marcado no `tasks.md` como encontrado no destino. Isso é o portão para apagar.
3. **Apagar e ajustar links e skills**, rodando o verificador de links; só então o diff é revisado.

Roda **por último** na fase (depois da 016 e da 017). Trata 016 e 017 como implementadas: elas entram no histórico como "limpeza de código, pacotes e assets" e "limpeza de comentários", com o que realmente saiu (ver os `verificacao.md` delas, se já existirem, e o `git log`). A 018 não consegue ler o próprio `verificacao.md` (a verificação roda depois); o histórico registra a 018 pela spec e pelo que o diff mostra, e a orquestradora acrescenta o resultado final no encerramento.

Estilo e tamanhos seguem o Observatório (`../observatorio_geo_hist/docs/`), lido antes: `architecture.md` (estrutura em árvore, camadas, tabela do `core`, rotas, convenções, "adicionando uma feature"), `admin-panel.md` (estrutura, moldura, CRUD, autenticação, pontos de atenção), `deployment.md` (ambientes, fluxo, workflows, segredos, diferenças, índices, operação, regras), `redesign-history.md` (decisões, fases, ressalvas, lições, como recuperar pela tag) e `specs/README.md`. Texto sempre **atemporal**: descreve como o projeto é, não como ficou.

Conferência dos fatos: tudo que o documento afirma sobre estrutura, rotas, tokens, regras e workflows é verificado no código (`ls lib`, `grep` em `app_router.dart`, leitura de `firestore.rules`, `firebase.json`, `.github/workflows/*.yml`, `pubspec.yaml`), nunca copiado de documento antigo sem checar.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `docs/architecture.md` | Fundação, estrutura, camadas, tema e design system, rotas, catálogo e Firestore, acessibilidade, convenções, decisões que ficaram |
| Criar | `docs/admin-panel.md` | Login, moldura, lista, editor, regras e formato de dados |
| Criar | `docs/deployment.md` | Conteúdo útil de `docs/cicd/planejamento.md` |
| Criar | `docs/redesign-history.md` | Fases, decisões, ressalvas abertas, lições, ideias futuras, tag |
| Alterar | `docs/specs/README.md` | Enxuto: fluxo, regras, depois do merge, tag, quando usar |
| Alterar | `README.md` | Curto: o que é, requisitos, comandos, ponteiros |
| Alterar | `.claude/skills/sdd-{fase,spec,plan,implement,verify}/SKILL.md` | Caminhos e nomes de arquivo (ajuste mínimo) |
| Apagar | `docs/specs/001-*` … `017-*` | Specs, planos, tarefas e verificações |
| Apagar | `docs/redesign/`, `docs/cicd/`, `docs/specs/historico-redesign.md` | Condensados |
| Apagar | `lib/features/theme/REFACTORING_SUMMARY.md` | Se a 016 não o apagou |
| Manter | `docs/specs/018-enxugar-docs/`, `docs/specs/execucao-fase-5.md` | A orquestradora apaga no encerramento |

## Lista de extração (portão antes de apagar)
Cada linha vira uma tarefa de conferência. "Destino" é o documento onde o item deve estar, em texto atemporal.

**De `docs/specs/README.md`**
- Regras de design ao implementar (tokens, tamanhos fixos por faixa, `#C94400`, degradê decorativo, contraste 4,5:1, foco e nome acessível, ilustrações em medalhão, 390/768/1280, estados obrigatórios, rotas em português com redirecionamento) → `architecture.md`.
- Comandos com FVM, `build_runner`, `dart format`, build web, onde ficam os testes → `README.md` (resumo) e `architecture.md` (detalhe).
- Git (push na `main` publica; branches; mensagens `tipo: descrição` em português) → `deployment.md` e `specs/README.md`.
- Comentários e texto (português, só o porquê, 1-2 linhas, sem citar spec/fase) → `specs/README.md` e `architecture.md` (convenções).
- Referências do projeto: protótipo (link do artifact) → `redesign-history.md`; base visual do Observatório → `architecture.md`.

**De `docs/redesign/planejamento.md`**
- Decisões 1: marca (sub-marca do Observatório), ligação com o Observatório (faixa, link, bloco, coluna), cor, degradê, fonte, marca na navbar, navbar fixa, ilustrações, rotas, contato por `mailto`, painel sem mudar dados nem regras → `architecture.md` (visuais) e `redesign-history.md` (tabela de decisões).
- Telas T-01 a T-10 com rotas → tabela de rotas em `architecture.md` e `admin-panel.md`.
- Princípios (reaproveitar o Observatório, tamanhos fixos por faixa, aceite em 390/768/1280) → `architecture.md`.
- Q-01 código na rota (`nma-bio-03`, original redireciona), Q-03 redes do rodapé do Observatório, **Q-04 catálogo único por `collectionGroup('contents')` com a regra de leitura**, Q-05 código gerado no editor e "Regras de registro" opcional, Q-07 destino dos logos → `architecture.md` e `admin-panel.md`.
- Fora do escopo (dados, campos, permissões, criar/editar temas e subtemas, busca geral, modo escuro) → `redesign-history.md` (ideias futuras).
- Riscos e cuidados da seção 6 → leitura obrigatória; o que continuar valendo vai para `architecture.md` ou `deployment.md`.

**De cada spec 001-015 (spec, plano, tarefas, verificação)** — ler `Dados e regras de negócio`, `Decisões técnicas`, `Perguntas em aberto` (respostas "Decidido"), `Histórico de mudanças` e as ressalvas da verificação. Candidatos já conhecidos:
- 001: tokens, fontes embutidas, breakpoints e largura máxima (1120), `AppTheme` → `architecture.md`.
- 002: botões (`AppButton`, `AppIconButton`, `InlineLink`), foco, navbar fixa e rodapé, faixa do Observatório → `architecture.md`.
- 003: `index.html`, metadados de compartilhamento, ícones e WebP geradas por `tool/` → `architecture.md` (pasta `web/` e `tool/`).
- 004 a 006: contagens e recentes pelo catálogo, medalhão, cartão de objeto, Sobre, apoio → `architecture.md`.
- 007 a 009: páginas de tema, subtema (busca sem acento, chips, "Carregar mais" de 6 em 6) e objeto (rotas de 3 segmentos, código original redireciona) → `architecture.md`.
- 010: contato por `mailto:` com validação e "Copiar mensagem"; links de texto sem `href` → `architecture.md`.
- 011: estados (esqueleto, vazio, erro, 404), `announce` e `LoadingRegion` → `architecture.md`.
- 012 a 015: login, moldura, lista com filtros no endereço, editor em página própria, código gerado, formato gravado (id do documento = código, siglas, tipo e formato pelo nome, datas só com o dia, transação de criar/mover), aviso de saída → `admin-panel.md`.
- 016 e 017: o que saiu e o que a regra de comentários passou a exigir → `redesign-history.md`.

**De `docs/specs/historico-redesign.md`**
- Tabela de fases (0 a 4; acrescentar a 5), as pendências em aberto e as lições → `redesign-history.md`. Cada pendência é reconferida: deploy da regra do Firestore na produção, navbar a 200%, primeiro Tab da página de objeto, reescrita de rotas e senha no `.htaccess` do dev, chave `preservationOperation`/`preservationAction`, ano de emissão, prévia em mensageiro, painel com Firestore real, menu estreito das listas do editor, leitor de tela real e aviso nativo ao fechar a aba, contato (e-mail não selecionável), `partner_logo` e o `InlineLink` externo. As já resolvidas pelo código atual saem.
- As 18 lições (cópia ASCII para ferramentas, `pubspec.lock`, WebP pelo Chrome, `SelectionArea` e Tab, semântica `toggled`/`aria-checked`, `announce`, `InlineLink` externo, cache vazio do Firestore, limites de uso e retomada etc.) → `redesign-history.md`, de forma breve.

**De `docs/cicd/planejamento.md`**
- Ambientes (dev `dev.expogeo.com.br` com `expogeo-dev`; produção `expogeo.com.br` com `expogeo-fad33`), fluxo `feature/* → develop → main`, branches protegidas e check **validar** → `deployment.md`.
- Workflows `ci.yml`, `deploy-dev.yml`, `deploy-prod.yml` (gatilhos, `paths-ignore`, `concurrency`, FTPS, versão do Flutter lida do `.fvmrc`, regras e índices antes do site) → `deployment.md`.
- `APP_ENV` (padrão dev local), faixa de ambiente de testes, Analytics entre marcadores (`analytics:inicio`/`fim`) removido no dev, `robots.txt` do dev → `deployment.md` e `architecture.md`.
- Environments `DEV`/`PROD` e segredos; papéis da conta de serviço; HostGator (subdomínio, usuário FTP restrito, `.htaccess` mantido só no servidor, cache, senha do dev) → `deployment.md`.
- Firebase: `firebase.json`, `firestore.indexes.json`, `firestore.rules` como fonte; mudança no console é desfeita no próximo deploy; índice de `contents` → `deployment.md`.
- Seed: `run_seed.sh <dev|prod>` com confirmação para produção → `deployment.md` e `README.md`.
- Riscos que ainda valem (merge que troca workflows, primeiro deploy FTPS, rodar local sem define, contas do painel só no ambiente certo) → `deployment.md` ("Operação").
- Pendências de infraestrutura abertas (E2, E7, E8, ou o que o `historico` mostrar como ainda aberto) → `deployment.md`.
- Formatação `dart format` com `page_width: 100` conferida no CI → `deployment.md`/`architecture.md`.

**Do `README.md` atual**
- Funcionalidades, estrutura de pastas, tecnologias, breakpoints e design system → `architecture.md` (o que ainda for verdade; a lista de "Temas implementados" não é, e sai); instalação, Firebase, seed e build → `README.md`/`deployment.md`.

## Decisões técnicas
- **Sem `future-ideas.md`.** Ideias futuras viram uma seção de `redesign-history.md` (ver spec).
- **Mesmos nomes do Observatório** (`architecture.md`, `admin-panel.md`, `deployment.md`, `redesign-history.md`), para quem cuida dos dois projetos.
- **Fatos, não cópia.** Se o documento antigo e o código divergem, vale o código e a divergência é lembrada na tarefa (ex.: `README` fala em Dartz 0.10.1 e MobX 2.4.0; ver `pubspec.yaml`).
- **Histórico curto.** Cada spec ganha uma linha no máximo duas, não parágrafos; o que importa é a decisão e a ressalva. Limite de 150 linhas.
- **Links.** Só relativos e para arquivos que existem; nada de âncora que dependa de título renomeado sem conferir. Dentro do histórico, a pasta apagada é citada em código (`docs/specs/009-pagina-objeto/`), sem link.
- **Skills:** ajuste mínimo, tarefa a tarefa, sem reescrever o fluxo. `sdd-fase` deixa explícito: "Se não houver planejamento da fase, divida o pedido em specs".
- **Alternativas descartadas:** manter o `planejamento.md` encolhido (duplica o histórico); manter `docs/cicd/` como histórico (deploy é documento vivo, não plano).

## Dependências e geração de código
Nenhuma. Nenhum código, pacote, rota ou workflow muda. `.github/workflows/ci.yml` e os deploys já ignoram `docs/` e `*.md`; conferir só que os caminhos citados nos documentos novos existem.

## Riscos e cuidados
- **Apagar antes de extrair.** Mitigação: portão da tarefa C (lista de extração 100% marcada) e a tag local `redesign-specs` criada pela orquestradora no encerramento, com o SHA anotado na tarefa D1. Até lá, tudo está recuperável pelo git do branch.
- **Pendência marcada como aberta já resolvida (ou o contrário).** Conferir cada uma no código; na dúvida, escrever "não conferida" em vez de afirmar.
- **Link quebrado em skill ou README.** O verificador (abaixo) varre todos os `.md`.
- **Skill que perde etapa.** Reler o fluxo depois do ajuste: spec, plano, implementação, verificação continuam como estão.
- **Documentos longos demais.** Os limites de linha da spec são conferidos com `wc -l`; se estourar, cortar detalhe de tela e deixar o que governa decisões futuras.
- **Datas e números.** Contagens (objetos, subtemas, temas, testes) só entram se conferidas; preferir não dizer o número.
- **Pasta com "ó".** Nada aqui roda `flutter` na pasta original; `analyze` e `test` só para provar que nada de código mudou, na cópia ASCII.

## Como conferir
```sh
# Verificador de links relativos de todos os .md (saída esperada: nenhuma linha "QUEBRADO")
python3 -I - <<'PY'
import re, pathlib
raiz = pathlib.Path('.')
for md in raiz.rglob('*.md'):
    if any(p in md.parts for p in ('venv', 'build', '.dart_tool', 'node_modules', '.git')):
        continue
    for alvo in re.findall(r'\]\(([^)#\s]+)(?:#[^)]*)?\)', md.read_text(encoding='utf-8')):
        if re.match(r'(https?:|mailto:)', alvo):
            continue
        if not (md.parent / alvo).resolve().exists():
            print('QUEBRADO', md, '->', alvo)
PY

# Menções que não podem sobrar fora do histórico e do README de specs
grep -rnE "redesign/planejamento|docs/cicd|specs/0[0-9]{2}-|Q-0[0-9]|historico-redesign" --include='*.md' . | grep -vE '^./(docs/redesign-history\.md|docs/specs/(README|018-enxugar-docs/))'
grep -rnE "redesign/planejamento|docs/cicd|historico-redesign" .claude/skills            # deve sair vazio
wc -l README.md docs/*.md docs/specs/README.md                                          # tamanhos-alvo
find docs -type f | sort                                                               # só os arquivos esperados
```
Depois, na cópia ASCII: `fvm flutter analyze` e `fvm flutter test` (provam que nenhum código mudou) e `git diff --stat` só com `.md` e `SKILL.md`.
