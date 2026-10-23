# Redesign da expoGEO: planejamento

Este documento registra as decisões de design, as telas do protótipo e a ordem de implementação no Flutter. É a fonte de verdade do redesign: cada item vira uma spec em `docs/specs/NNN-nome/`, no fluxo SDD (spec → plano → implementação → verificação) já usado no Observatório.

- **Protótipo (v1, todas as telas, inclusive login, painel e editor):** https://claude.ai/artifact/6tQuscgpFQk87MU2JZPNNs
- **Referência:** protótipo e código do redesign do Observatório (https://claude.ai/artifact/PimRbbQyUDbqrapiv8HseH e o repositório `observatorio_geo_hist`).
- **Situação:** protótipo aprovado em 2026-10-23. Nenhuma fase iniciada.

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
| # | Entrega | Principais arquivos |
|---|---|---|
| 0.0 | Ambiente de testes: branch `develop` com deploy para um endereço de dev. Hoje só existe a `main`, e todo push nela publica o site. Plano em [docs/cicd/planejamento.md](../cicd/planejamento.md) | `.github/workflows/*` |
| 0.1 | Tokens de cor, raios, espaçamentos e sombras do Observatório, mais o token do degradê | `core/theme/app_colors`, `app_dimensions`, `app_gradients` |
| 0.2 | Tipografia nova com Bricolage Grotesque e Figtree **embutidas** em `assets/fonts` (sai o `GoogleFonts.aleo` em tempo de execução) | `core/theme/app_typography`, `pubspec.yaml` |
| 0.3 | Breakpoints e largura máxima de conteúdo | `core/utils/screen/screen_utils.dart` |
| 0.4 | Botões primário, secundário e discreto, com foco visível e estado desativado | `core/components/button/*` |
| 0.5 | Faixa do Observatório e navbar fixa: menu Temas (4 temas com medalhão e quantidade de subtemas), Sobre, Contato, link Observatório; sanfona no celular | `core/components/structure/navbar.dart` |
| 0.6 | Rodapé escuro em colunas: marca, Temas, Curadoria (Sobre, metadados, tese, contato), Observatório (site e redes) | `core/components/structure/footer.dart` |
| 0.7 | `<title>`, descrição e ícones do `web/index.html` | `web/index.html`, `web/manifest.json` |

**Aceite:** todas as páginas atuais abrem sem erro com navbar, rodapé e botões novos. Navegação por teclado na navbar.

### Fase 1: Home (T-01)
| # | Seção | Notas técnicas |
|---|---|---|
| 1.1 | Hero, contagens e anel dos temas | Contagens vêm dos dados (ver Riscos) |
| 1.2 | Cartões dos 4 temas | Substituem `themes_row` e `theme_card` (carrossel) |
| 1.3 | Como explorar | Exemplos com links reais |
| 1.4 | Adicionados recentemente | 6 objetos mais recentes por data de inserção; consulta nova |
| 1.5 | Resumo do Sobre e públicos | Depende da rota `/sobre` (T-05) |
| 1.6 | Realização e apoio, bloco do Observatório | Logos com hover; mesmo componente do Observatório |

### Fases seguintes
| Fase | Escopo | Motivo da posição |
|---|---|---|
| 2 | Navegação de conteúdo: Tema (T-02), Subtema (T-03) e Objeto (T-04, rota nova) | Núcleo do site e maior volume de uso |
| 3 | Sobre (T-05), Contato (T-06) e estados especiais (T-07) | Páginas simples, reaproveitam o layout de leitura e o formulário do Observatório |
| 4 | Login (T-08), painel (T-09) e editor (T-10) | Mesmo desenho da Fase 8 do Observatório, sem mudar dados nem regras |
| 5 | Limpeza: tokens e cores antigas, Aleo, `num_extension`, `carousel_slider` e assets sem uso | Só depois que nenhuma tela usa o que sai |

**Aceite das Fases 2 a 4:** telas iguais ao protótipo nas três larguras, com estados de carregando, vazio e erro. No painel, entrar, listar, filtrar, criar, editar e excluir funcionam como antes. Todo botão só de ícone tem dica e nome acessível.

---

## 4. Perguntas em aberto
| ID | Pergunta | Onde decidir |
|---|---|---|
| Q-01 | Formato do código na rota do objeto: `nma_bio_03` como está ou `nma-bio-03` (hífen, como as outras rotas)? | Spec da página do objeto (Fase 2) |
| Q-03 | A expoGEO terá redes sociais próprias? Hoje o rodapé leva às do Observatório | Spec do rodapé (0.6) |

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
- **Adicionados recentemente:** exige `collectionGroup('contents')` ordenado por `originInfo.insertionDate` (texto ISO), com índice novo no Firestore.
- **Página do objeto:** a rota antiga de conteúdo está comentada no `app_router.dart` e dependia de `extra`. A nova precisa carregar o objeto só pelo endereço, para funcionar ao abrir um link direto.
- **Imagens das ilustrações:** são PNGs de cerca de 400 KB. Vale gerar versões menores (WebP) antes da Fase 1.
- **Regras do projeto:** o Expogeo não tem `CLAUDE.md`. Regras de design, comandos, git e referências ficam em [docs/specs/README.md](../specs/README.md), que as skills `sdd-*` (em `.claude/skills/`) leem primeiro.
