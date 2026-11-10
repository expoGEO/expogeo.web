# Redesign da expoGEO: planejamento

Este documento registra as decisões de design, as telas do protótipo e a ordem de implementação no Flutter. É a fonte de verdade do redesign: cada item vira uma spec em `docs/specs/NNN-nome/`, no fluxo SDD (spec → plano → implementação → verificação) já usado no Observatório.

- **Protótipo (v1, todas as telas, inclusive login, painel e editor):** https://claude.ai/artifact/6tQuscgpFQk87MU2JZPNNs
- **Referência:** protótipo e código do redesign do Observatório (https://claude.ai/artifact/PimRbbQyUDbqrapiv8HseH e o repositório `observatorio_geo_hist`).
- **Situação:** protótipo aprovado em 2026-10-23. Item 0.0 em andamento pelo [plano de CI/CD](../cicd/planejamento.md). Specs 001 a 016 criadas e **aprovadas** em 2026-10-27 (ver [mapa das specs](#mapa-das-specs)).

---

## 1. Decisões já tomadas

| Tema | Decisão |
|---|---|
| Marca | A expoGEO passa a ser **sub-marca do Observatório**: mesmo sistema visual (fontes, neutros, componentes, rodapé escuro), mantendo o logo "expoGEO", o degradê laranja-amarelo e a navegação por temas e subtemas |
| Ligação com o Observatório | Faixa escura no topo ("Um projeto do Observatório do Ensino de História e Geografia · UFU"), link "Observatório" na navbar, bloco na Home e no Sobre, coluna no rodapé |
| Cor | `#C94400` (acento do Observatório) em tudo que é funcional: botões, links, foco, chips. O laranja atual `#F97316` tem 2,8:1 no branco e não passa no mínimo de 4,5:1 |
| Degradê | `#F97316 → #FB923C → #FACC15` só em superfícies decorativas: anel do hero, faixa no topo dos cartões de tema. Nunca sob texto pequeno nem em botões |
| Fonte | Bricolage Grotesque nos títulos e Figtree no texto, as mesmas do Observatório. A Aleo sai. O logo continua como imagem |
| Marca na navbar | Símbolo (`logo_simple.png`) + "expo**GEO**" em texto (GEO no acento) + linha "Curadoria digital do saber geográfico" |
| Navbar | Fixa no topo, com fundo branco translúcido, igual à do Observatório. A variação com o menu transparente sobre o topo foi testada e descartada |
| Ilustrações | As ilustrações redondas de temas e subtemas ficam **inteiras em medalhões** (proporção 1:1, `contain`, fundo branco). Não usam o recorte 16:10 das fotos do Observatório |
| Rotas | As atuais continuam valendo (`/representacoes-espaciais`, `/natureza-meio-ambiente/biomas` etc.). Rotas novas em português, minúsculas, sem acento e com hífen |
| Contato | Mesmo padrão do Observatório: abre o programa de e-mail (`expogeoufu@gmail.com`) com tudo preenchido, valida os campos e mostra confirmação com "Copiar mensagem" |
| Painel | Login, painel e editor no padrão da Fase 8 do Observatório, **sem mudar dados nem regras**: mesmos campos da ficha, sem situação de publicação (rascunho/publicado), temas e subtemas só para consulta |
| Modo escuro e busca geral | Fora do escopo |

---

## 2. Telas do protótipo

| ID | Tela | Rota | Observações |
|---|---|---|---|
| T-01 | Home | `/` | Hero com proposta em uma frase, botões "Explorar os temas" e "Como fazemos a curadoria", contagens (objetos, subtemas, temas) e anel com os 4 temas. Cartões dos 4 temas (sem carrossel) com descrição, contagens e nomes dos subtemas. "Como explorar" em 3 passos com exemplos reais. "Adicionados recentemente" (6 objetos pela data de inserção). Resumo do Sobre com públicos. Realização e apoio (UFU, FACED, PPGED, FAPEMIG, CAPES, CNPq) com hover do Observatório. Bloco do Observatório |
| T-02 | Tema | `/:tema` | Migalhas, título, descrição, contagens e medalhão. Grade de subtemas (medalhão, nome em caixa normal, quantidade de objetos); duas colunas no celular. "Outros temas" no final |
| T-03 | Subtema | `/:tema/:subtema` | Voltar ao tema e migalhas. Busca por título, descrição, assunto ou autor, ignorando acentos. Filtro por tipo em chips, com contagem. "Assuntos frequentes" (do campo `subjects`) como filtro rápido. Linhas com ícone do tipo, tipo e formato, título, descrição, criador, ano, domínio, assuntos, "Ver ficha" e "Acessar". "Carregar mais" de 6 em 6 no lugar de anterior/próxima. Busca sem resultado com "Limpar busca" |
| T-04 | Objeto | `/:tema/:subtema/:codigo` (novo) | Página própria. Tipo, título, descrição, "Acessar o recurso", "Copiar link" e o endereço visível. Nota de conteúdo. Ficha da curadoria com o código em destaque e os grupos Autoria, Conteúdo, Origem, Registro e Direitos e preservação. "Outros objetos" do mesmo subtema |
| T-05 | Sobre | `/sobre` (novo) | Texto de boas-vindas que hoje ocupa a Home. Explica o código de referência (tema geral, tema específico, número). Links para os metadados da curadoria e a tese. Apoio e bloco do Observatório |
| T-06 | Contato | `/contato` (a constante existe, a página não) | Formulário com validação, confirmação e contatos ao lado |
| T-07 | Estados | — | Esqueletos no formato dos medalhões e das linhas, busca vazia, erro com "Tentar de novo" e 404 ("Este lugar não está no mapa") |
| T-08 | Login | `/admin` | Duas colunas (marca sobre fundo escuro e formulário). Erro único de credenciais, botão "Entrando…", "Voltar ao site" |
| T-09 | Painel | `/admin/painel` | Barra superior, menu lateral com "Objetos digitais" (submenu por tema, com contagens) e "Temas e subtemas" (só consulta). Lista em linhas com medalhão do subtema, título, código, subtema, criador, data e tipo. Filtros em linha: busca, tema, subtema, tipo. Ações com dica: abrir o recurso, editar, excluir (pede confirmação). Gaveta no celular |
| T-10 | Editor | `/admin/painel/objetos/novo` e `/admin/painel/objetos/:codigo/editar` (novos) | Página própria no lugar do diálogo. Campos da ficha atual agrupados em Conteúdo, Autoria, Origem e registro, Direitos e preservação. À direita: tema, subtema, código gerado e prévia do cartão. Resumo do que falta ao salvar, com link para cada campo |

A aba Fundamentos do protótipo resume paleta, tipografia, regra das ilustrações e as trocas em relação ao site atual.

---

## 3. Plano de implementação

### Princípios
1. **Reaproveitar o Observatório.** Tokens (`app_colors`, `app_dimensions`, `app_typography`), fontes embutidas, botões, navbar, rodapé, estados e componentes do painel são copiados e adaptados de `observatorio_geo_hist`, não redesenhados.
2. **Componentes compartilhados primeiro.** A Fase 0 entrega navbar, rodapé e botões juntos. As demais páginas continuam funcionando com a roupa nova até serem redesenhadas.
3. **Tokens novos ao lado dos antigos.** Os antigos só saem na limpeza, quando nada mais os usa.
4. **Tamanhos fixos por faixa de largura** (celular < 600, tablet 600–1023, desktop ≥ 1024) e largura máxima de conteúdo (~1120 px). Os componentes novos não usam `num_extension` (hoje em 31 arquivos).
5. **Cada fase termina com aceite** conferido contra o protótipo em 390, 768 e 1280 px: sem rolagem horizontal, sem `overflow`, contraste mínimo de 4,5:1 e navegação por teclado.

### Fase 0: Ambiente, fundação e casco
Dividida em três specs: 0.1 a 0.3 → 001-fundacao; 0.4 a 0.6 → 002-botoes-navbar-rodape; 0.7 e 0.8 → 003-index-ilustracoes. O 0.0 segue o plano de CI/CD, sem spec.

| # | Entrega | Principais arquivos |
|---|---|---|
| 0.0 | Ambiente de testes: branch `develop` com deploy para um endereço de dev. Hoje só existe a `main`, e todo push nela publica o site. Plano em [docs/cicd/planejamento.md](../cicd/planejamento.md) | `.github/workflows/*` |
| 0.1 | Tokens de cor, raios, espaçamentos e sombras do Observatório, mais o token do degradê → specs/001-fundacao (concluído) | `core/theme/app_colors`, `app_dimensions`, `app_gradients` |
| 0.2 | Tipografia nova com Bricolage Grotesque e Figtree **embutidas** em `assets/fonts` (sai o `GoogleFonts.aleo` em tempo de execução) → specs/001-fundacao (concluído) | `core/theme/app_typography`, `pubspec.yaml` |
| 0.3 | Breakpoints e largura máxima de conteúdo → specs/001-fundacao (concluído) | `core/utils/screen/screen_utils.dart` |
| 0.4 | Botões primário, secundário e discreto, com foco visível e estado desativado → specs/002-botoes-navbar-rodape (concluído) | `core/components/button/*` |
| 0.5 | Faixa do Observatório e navbar fixa: menu Temas (4 temas com medalhão e quantidade de subtemas), Sobre, Contato, link Observatório; sanfona no celular → specs/002-botoes-navbar-rodape (concluído) | `core/components/structure/navbar.dart` |
| 0.6 | Rodapé escuro em colunas: marca, Temas, Curadoria (Sobre, metadados, tese, contato), Observatório (site e redes) → specs/002-botoes-navbar-rodape (concluído) | `core/components/structure/footer.dart` |
| 0.7 | `<title>`, descrição, metadados de compartilhamento, ícones e tela de carregamento inicial do `web/index.html` → specs/003-index-ilustracoes (concluído) | `web/index.html`, `web/manifest.json`, `web/icons/` |
| 0.8 | Ilustrações de temas e subtemas e logos de apoio em WebP leve (os PNGs saem só na Fase 5) → specs/003-index-ilustracoes (concluído) | `assets/images/`, `core/utils/enums/app_images.dart` |

**Aceite:** todas as páginas atuais abrem sem erro com navbar, rodapé e botões novos. Navegação por teclado na navbar.

### Fase 1: Home (T-01) e Sobre (T-05)
Três specs: 1.1 e 1.2 → 004-hero-temas; 1.3 e 1.4 → 005-como-explorar-recentes; 1.5, 1.6 e 1.7 → 006-sobre-apoio. A página Sobre veio da Fase 3 porque o resumo da Home leva a ela e as duas usam o apoio e o bloco do Observatório; assim não é preciso página provisória.

| # | Seção | Notas técnicas | Depende de |
|---|---|---|---|
| 1.1 | Hero, contagens e anel dos temas → specs/004-hero-temas (concluído com ressalvas) | Contagens vêm dos dados (Q-04). Cria o componente de medalhão | 0.x, Q-04 |
| 1.2 | Cartões dos 4 temas → specs/004-hero-temas (concluído com ressalvas) | Substituem `themes_row` e `theme_card` (carrossel) | 1.1 |
| 1.3 | Como explorar → specs/005-como-explorar-recentes (concluído com ressalvas) | Exemplos fixos (Natureza e Meio Ambiente → Biomas), título e contagem dos dados | 1.4 (cartão), 2.3 (link do passo 3) |
| 1.4 | Adicionados recentemente → specs/005-como-explorar-recentes (concluído com ressalvas) | 6 objetos mais recentes por `originInfo.insertionDate`; cria o cartão de objeto | Q-04 |
| 1.5 | Resumo do Sobre e públicos → specs/006-sobre-apoio (concluído com ressalvas) | Leva a `/sobre` | 1.7 |
| 1.6 | Realização e apoio, bloco do Observatório → specs/006-sobre-apoio (concluído com ressalvas) | Logos com hover; mesmo componente do Observatório | Q-07 |
| 1.7 | Página Sobre (T-05) → specs/006-sobre-apoio (concluído com ressalvas) | Rota nova `/sobre`, texto de boas-vindas, código de referência, metadados e tese | 1.6 |

**Aceite:** a Home e o Sobre reproduzem o protótipo em 390, 768 e 1280 px, com estados de carregando e erro nas contagens e nos recentes.

### Fase 2: Navegação de conteúdo
Uma spec por tela: 2.1 → 007-pagina-tema; 2.2 → 008-pagina-subtema; 2.3 → 009-pagina-objeto.

| # | Tela | Notas técnicas | Depende de |
|---|---|---|---|
| 2.1 | Tema (T-02) → specs/007-pagina-tema (concluído com ressalvas) | Cabeçalho com contagens e medalhão, grade de subtemas com "N objetos", "Outros temas" | 1.1 (medalhão), Q-04 |
| 2.2 | Subtema (T-03) → specs/008-pagina-subtema (concluído com ressalvas) | Busca sem acento, chips de tipo, assuntos frequentes, linhas de objeto, "Carregar mais" de 6 em 6. Sai a paginação por cursor | Q-04 |
| 2.3 | Objeto (T-04) → specs/009-pagina-objeto (concluído com ressalvas) | Rota nova `/:tema/:subtema/:codigo` que abre por link direto; ficha completa; "Outros objetos" | 1.4 (cartão), Q-01 |

**Aceite:** telas iguais ao protótipo nas três larguras, com carregando, vazio, erro e 404 para endereços inexistentes.

### Fase 3: Contato e estados
Duas specs: 3.1 → 010-contato; 3.2 → 011-estados-especiais.

| # | Entrega | Notas técnicas | Depende de |
|---|---|---|---|
| 3.1 | Contato (T-06) → specs/010-contato (concluído com ressalvas) | `/contato` com `mailto:` preenchido, validação, confirmação e "Copiar mensagem", como no Observatório | 0.x |
| 3.2 | Estados (T-07) → specs/011-estados-especiais (concluído) | Caixa de estado e esqueletos compartilhados, 404 "Este lugar não está no mapa", remoção dos componentes de estado antigos | Fases 1 e 2 |

### Fase 4: Painel
Quatro specs: 4.1 → 012-login; 4.2 → 013-painel-estrutura; 4.3 → 014-painel-objetos; 4.4 → 015-editor-objeto.

| # | Entrega | Notas técnicas | Depende de |
|---|---|---|---|
| 4.1 | Login (T-08) → specs/012-login (concluído) | Duas colunas, erro único de credenciais, "Entrando…" | 0.x |
| 4.2 | Moldura do painel e "Temas e subtemas" (T-09) → specs/013-painel-estrutura (concluído) | Barra, menu lateral com contagens, gaveta, endereços por vista, toast, dica e diálogo compartilhados | 4.1, Q-04 |
| 4.3 | Lista de objetos (T-09) → specs/014-painel-objetos (concluído) | Linhas no lugar da `DataTable`, busca e filtros no endereço, ações com dica, exclusão com confirmação | 4.2 |
| 4.4 | Editor (T-10) → specs/015-editor-objeto (concluído com ressalvas) | Página própria em `/admin/painel/objetos/novo` e `/:codigo/editar`, resumo de pendências, prévia, código gerado | 4.3, Q-01, Q-05 |

**Aceite das Fases 2 a 4:** telas iguais ao protótipo nas três larguras, com estados de carregando, vazio e erro. No painel, entrar, listar, filtrar, criar, editar e excluir funcionam como antes. Todo botão só de ícone tem dica e nome acessível. O que exige login precisa de credenciais de teste no dev.

### Fase 5: Limpeza
Três specs: 5.1 e 5.2 → 016-limpeza-legado; 5.3 → 017-limpeza-comentarios; 5.4 → 018-enxugar-docs.

| # | Entrega | Notas técnicas |
|---|---|---|
| 5.1 | Código, tokens, Aleo, `google_fonts`, `num_extension` e pacotes sem uso | Só o que nenhuma tela usa; README atualizado |
| 5.2 | Assets sem uso | PNGs substituídos pelos WebP e arquivos sem referência |
| 5.3 | Comentários do repositório | Só comentários breves e de real importância (o porquê), sem redundância, sem citar spec, fase, tarefa ou protótipo; genéricos, pois as specs somem |
| 5.4 | Enxugar a documentação | Reduzir os `.md` (specs, planos, tarefas, verificações, planejamento) ao mínimo que registre fundação, arquitetura, estrutura, painel e deploy, no estilo de `../observatorio_geo_hist/docs/` (`architecture.md`, `admin-panel.md`, `deployment.md`, `redesign-history.md`, `specs/README.md`); manter só o histórico condensado |

### Mapa das specs
| Spec | Itens | Status |
|---|---|---|
| [001-fundacao](../specs/001-fundacao/spec.md) | 0.1–0.3 | verificada |
| [002-botoes-navbar-rodape](../specs/002-botoes-navbar-rodape/spec.md) | 0.4–0.6 | verificada |
| [003-index-ilustracoes](../specs/003-index-ilustracoes/spec.md) | 0.7–0.8 | verificada |
| [004-hero-temas](../specs/004-hero-temas/spec.md) | 1.1–1.2 | verificada com ressalvas |
| [005-como-explorar-recentes](../specs/005-como-explorar-recentes/spec.md) | 1.3–1.4 | verificada com ressalvas |
| [006-sobre-apoio](../specs/006-sobre-apoio/spec.md) | 1.5–1.7 | verificada com ressalvas |
| [007-pagina-tema](../specs/007-pagina-tema/spec.md) | 2.1 | verificada com ressalvas |
| [008-pagina-subtema](../specs/008-pagina-subtema/spec.md) | 2.2 | verificada com ressalvas |
| [009-pagina-objeto](../specs/009-pagina-objeto/spec.md) | 2.3 | verificada com ressalvas |
| [010-contato](../specs/010-contato/spec.md) | 3.1 | verificada com ressalvas |
| [011-estados-especiais](../specs/011-estados-especiais/spec.md) | 3.2 | verificada |
| [012-login](../specs/012-login/spec.md) | 4.1 | verificada |
| [013-painel-estrutura](../specs/013-painel-estrutura/spec.md) | 4.2 | verificada |
| [014-painel-objetos](../specs/014-painel-objetos/spec.md) | 4.3 | verificada |
| [015-editor-objeto](../specs/015-editor-objeto/spec.md) | 4.4 | verificada com ressalvas |
| [016-limpeza-legado](../specs/016-limpeza-legado/spec.md) | 5.1–5.2 | aprovada |

Todas as perguntas foram respondidas e as 16 specs aprovadas em 2026-10-27. Fase 0 (001 a 003) e Fase 1 (004 a 006) concluídas em 2026-11-03; Fase 2 (007 a 009) concluída em 2026-11-05; Fase 3 (010 e 011) concluída em 2026-11-08; Fase 4 (012 a 015) concluída em 2026-11-09; próximo passo: Fase 5 (016).

---

## 4. Perguntas e respostas

### Respondidas (2026-10-27, todas pela recomendação)
| ID | Pergunta | Resposta | Specs |
|---|---|---|---|
| Q-01 | Formato do código na rota do objeto | `nma-bio-03` (minúsculas e hífen) no endereço; o código original (`NMA_BIO_03`) também abre o objeto | 009, 015 |
| Q-03 | Redes sociais próprias da expoGEO | Não por enquanto: o rodapé leva às redes do Observatório, com nome acessível "… do Observatório" | 002 |
| Q-04 | Fonte das contagens e listas | **Catálogo único:** todos os objetos são carregados uma vez por `collectionGroup('contents')` e servem Home, tema, subtema, objeto e painel. Entra no `firestore.rules` a regra de leitura para grupo de coleções (`match /{path=**}/contents/{id} { allow read: if true; }`); quem pode gravar não muda. A regra não é publicada pelo deploy (só os índices) e precisa ser publicada à mão no dev e na produção | 004 (cria), 005, 007, 008, 009, 013, 014 |
| Q-05 | Código de referência no editor e campo "Regras de registro" | Código **gerado**: prefixo que os objetos do subtema já usam (ex.: `NMA_PAG`) + próximo número com 2 dígitos; o do enum só em subtema vazio; ao editar sem trocar de subtema, não muda. "Regras de registro" continua como campo opcional | 015 |
| Q-07 | Destino dos logos de apoio | Sites institucionais, iguais aos do Observatório quando a instituição for a mesma | 006 |

### Em aberto
Nenhuma no momento.

---

## 5. Fora do escopo
- Mudanças de dados, campos da ficha, permissões ou regras do painel.
- Criar ou editar temas e subtemas pelo painel.
- Busca geral do site e modo escuro.

---

## 6. Riscos e cuidados
- **Deploy direto na produção:** sem `develop`, qualquer push na `main` publica o site. Por isso a Fase 0 começa pelo ambiente de testes.
- **Contagens:** os objetos ficam em `themes/{tema}/subthemes/{subtema}/contents`, enquanto títulos, descrições e imagens de temas e subtemas estão no código (`ThemeDataModel`). Contar por tema e por subtema pede consultas `count()` no Firestore ou um contador mantido pelo painel.
- **Busca e filtros do subtema:** cada subtema tem de 4 a 10 objetos (190 nos dados de seed em `lib/core/content`). Carregar o subtema inteiro e filtrar no navegador é mais simples que a paginação por cursor atual. "Carregar mais" passa a ser só visual. Confirmar se o volume continua pequeno.
- **Adicionados recentemente:** exige `collectionGroup('contents')` ordenado por `originInfo.insertionDate` (texto ISO). O índice de grupo de coleções já está em `firestore.indexes.json`; falta a regra de leitura para grupo de coleções (Q-04).
- **Prefixos de código:** em Poluição da Água os objetos usam `NMA_PAG_*`, mas o enum diz `NMA_PA`. Gerar código pelo enum criaria uma sequência paralela (Q-05).
- **Movimentos da Terra:** existe no `SubthemeEnum` (`RE_MOT`) e tem ilustração, mas não está em `ThemeDataModel` nem nos dados de seed. As telas novas seguem o `ThemeDataModel` (7 subtemas em Representações Espaciais, 31 no total).
- **Página do objeto:** a rota antiga de conteúdo está comentada no `app_router.dart` e dependia de `extra`. A nova precisa carregar o objeto só pelo endereço, para funcionar ao abrir um link direto.
- **Imagens das ilustrações:** são PNGs de cerca de 400 KB. Vale gerar versões menores (WebP) antes da Fase 1.
- **Regras do projeto:** o Expogeo não tem `CLAUDE.md`. Regras de design, comandos, git e referências ficam em [docs/specs/README.md](../specs/README.md), que as skills `sdd-*` (em `.claude/skills/`) leem primeiro.
