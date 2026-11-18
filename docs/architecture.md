# Arquitetura da expoGEO

Flutter Web organizado em **features**, com camadas inspiradas em Clean Architecture. Backend Firebase (Firestore e Auth), **MobX** para estado, **GetIt** para injeção, **GoRouter** para rotas e **dartz** (`Either`) para erros.

A expoGEO é uma sub-marca do Observatório e reaproveita a base visual do projeto vizinho `observatorio_geo_hist` (tokens, fontes, botões, navbar, rodapé, estados); antes de criar um componente, procure o equivalente lá e no `core`. O painel administrativo tem documento próprio: [admin-panel.md](admin-panel.md). O deploy está em [deployment.md](deployment.md).

## Pilha

Versões em [pubspec.yaml](../pubspec.yaml) e [.fvmrc](../.fvmrc) (Flutter 3.35.5, Dart ^3.9): `go_router`, `mobx`/`flutter_mobx`, `get_it`, `dartz`, `freezed_annotation`, `firebase_core`, `cloud_firestore`, `firebase_auth`, `flutter_svg`, `url_launcher`. As fontes são embutidas; o site não usa `google_fonts`.

## Estrutura de diretórios

```
lib/
├── main.dart                 # Firebase.initializeApp (por ambiente), setups e MaterialApp.router
├── firebase_options_dev.dart / firebase_options_prod.dart
├── core/                     # Código compartilhado
│   ├── components/           # Widgets compartilhados
│   ├── content/              # Objetos do acervo em Dart, origem do seed (bin/)
│   ├── models/               # Tema, subtema, objeto, parceiro, ilustração
│   ├── navigation/           # app_router.dart, route_meta.dart (título e descrição por rota) e home_sections.dart
│   ├── pages/                # not_found_page.dart (404)
│   ├── theme/                # app_colors, app_dimensions, app_typography, app_gradients, app_theme
│   └── utils/                # accessibility, browser, constants, date, enums, environment,
│                             # messenger, screen, string, url, validators
└── features/                 # home, theme, about, contact, catalog, admin
assets/{fonts,icons,images}/  # Fontes embutidas, ícones SVG das redes, ilustrações e logos em WebP
web/                          # index.html (título, descrição, metadados de compartilhamento, tela de
                              # carregamento inicial, Analytics), .htaccess, robots.txt, manifest, ícones e
                              # og-image.png
tool/web_icons/               # Gera os ícones e a imagem de compartilhamento (generate.sh)
tool/seo/                     # Gera as páginas HTML por rota e o sitemap.xml no deploy (ver deployment.md)
bin/                          # Seed do Firestore (Python) e o JSON de objetos
test/{core,features,support}/ # Testes, espelhando lib/
```

## Camadas de uma feature

Cada feature com dados tem um `{feature}_setup.dart` (DI) e duas camadas:

- **`infra/`**: `datasources/` (consultas ao Firebase), `repositories/` (contrato + implementação, convertendo exceções em `Either<Failure, T>`), `models/` e `errors/` (`Failure`s).
- **`presentation/`**: `pages/`, `components/` e `stores/` (MobX; `*.g.dart` gerado pelo `build_runner`).

Fluxo: `Widget → Store → Repository → Datasource → Firebase`. O resultado volta como `Either<Failure, T>`; a store trata os dois lados com `fold` e guarda o estado observável (carregando, sucesso, erro). As features só de tela (`home`, `about`, `contact`) têm apenas `pages/` e `components/`; `theme` tem páginas, componentes e a store do subtema.

## Core (`lib/core/`)

| Pasta | Conteúdo |
|---|---|
| `components/button` | `AppButton` (primary, secondary, ghost, danger; `isLoading` ignora toques durante a ação), `AppIconButton` (só ícone; dica obrigatória no hover e no foco, nome acessível) e `InlineLink` |
| `components/structure` | `SiteScaffold` (faixa do Observatório que rola, navbar fixa com menu Temas e rodapé escuro, tudo sob um `SelectionArea`), `PageContent` (caixa de 1120 px), `ObservatoryCard` |
| `components/card`, `chip`, `image` | `ObjectCard` e sua grade, `FilterChipButton` (chip com contagem), `AppMedallion` (ilustração 1:1 com placeholder e tratamento de falha) |
| `components/field`, `form`, `dialog` | `AppSearchField`, `AppFilterSelect` (seletor com menu, teclado e nome acessível), `FormTextField`, `FormSelectField`, `FormErrorAlert`, `showConfirmDialog` (foco inicial em "Cancelar") |
| `components/state`, `skeleton` | `StateMessageBox` (vazio e busca sem resultado), `StateErrorBox` (erro de página com "Tentar de novo"), `StateErrorInline` (erro de seção), `AppSkeleton` e `LoadingRegion` (lido uma vez como "Carregando…") |
| `components/reading`, `partners`, `brand`, `focus`, `environment` | Base das páginas de texto (migalhas, cabeçalho, coluna, código de referência), Realização e apoio, marca, `AppFocusRing`, faixa de ambiente de testes |
| `models/` | `ThemeEnum`/`SubthemeEnum` (em `theme_data_model.dart`), `ContentModel`, `Partner`, `ThemeIllustration` |
| `utils/` | `ScreenUtils`, `AppImages`, `AppLinks`, `SiteCopy` (textos de home, sobre e contato que a tela e o gerador de páginas compartilham), `PageMeta` e `applyPageMeta` (metadados por rota), `AppEnvironment`, `Messenger` (aviso curto em caixa escura, um por vez, anunciado), `announce`, `foldForSearch`/`referenceCodeSlug`, `MailDraft`, `openUrl`, `FormValidators`, `leave_guard` (aviso do navegador ao fechar a aba) |

## Tema e design system

`AppTheme.colors`, `.dimensions`, `.typography` e `.gradients` são a única fonte de cores, espaçamentos, raios, sombras e tipografia.

- **Fontes:** Bricolage Grotesque nos títulos e Figtree no texto, embutidas em `assets/fonts/`. O logo é imagem.
- **Cor:** `#C94400` (acento do Observatório) em tudo que é clicável: botões, links, foco, chips. O laranja `#F97316` tem 2,8:1 no branco e não passa no mínimo de 4,5:1.
- **Degradê:** `#F97316 → #FB923C → #FACC15` (`AppGradients.brand`) só em superfícies decorativas, como o anel do hero e a faixa dos cartões de tema. Nunca sob texto pequeno nem em botões.
- **Marca:** sub-marca do Observatório, com o mesmo sistema visual. Navbar com o símbolo, "expo**GEO**" (GEO no acento) e a linha "Curadoria digital do saber geográfico". A navbar é fixa, de fundo branco translúcido; a faixa escura "Um projeto do Observatório do Ensino de História e Geografia · UFU" rola com a página. A ligação com o Observatório também aparece no link da navbar, num bloco na Home e no Sobre e numa coluna do rodapé, cujas redes são as do Observatório (a expoGEO não tem as próprias).
- **Ilustrações:** as de temas e subtemas ficam inteiras em medalhão (1:1, `contain`, fundo branco), nunca no recorte 16:10 das fotos do Observatório. Logos de apoio apontam para os sites das instituições. Todas em WebP (`AppImages`), convertidas fora do projeto; os ícones e a imagem de compartilhamento saem de `tool/web_icons/`.
- **Faixas de largura:** celular < 600, tablet 600–1023, desktop ≥ 1024 (`Breakpoint`, `ScreenUtils`), largura máxima de conteúdo 1120. Componentes usam tamanhos fixos por faixa; nada escala pela largura da tela. A navbar e o painel viram menu/gaveta abaixo de 900 px.
- **Regras visuais:** texto secundário nunca em cinza claro (contraste mínimo 4,5:1 para texto e ícones informativos); telas funcionam em 390, 768 e 1280 px sem rolagem horizontal nem `overflow`; toda tela com dados tem carregando (esqueleto), vazio e erro.

## Decisões de design e de produto

| Tema | Decisão |
|---|---|
| Marca | Sub-marca do Observatório: mesmo sistema visual, mantendo o logo "expoGEO", o degradê laranja-amarelo e a navegação por temas e subtemas |
| Ligação com o Observatório | Faixa escura no topo, link na navbar, bloco na Home e no Sobre, coluna no rodapé |
| Cor e degradê | `#C94400` em tudo que é clicável (o `#F97316` antigo tinha 2,8:1); degradê só decorativo |
| Fontes | Bricolage Grotesque e Figtree embutidas, as do Observatório; a Aleo e o `google_fonts` saíram |
| Navbar | Fixa, de fundo branco translúcido; a variação transparente sobre o topo foi testada e descartada |
| Ilustrações | Inteiras em medalhão 1:1 (`contain`), não no recorte 16:10 do Observatório |
| Rotas | As públicas continuam; rotas novas em português, minúsculas, sem acento e com hífen |
| Código na rota | `nma-bio-03`; o original `NMA_BIO_03` também abre e redireciona |
| Redes do rodapé | Não há redes próprias da expoGEO: o rodapé leva às do Observatório, com nome acessível "… do Observatório" |
| Fonte das contagens e listas | Catálogo único por `collectionGroup('contents')`, com regra de leitura própria no `firestore.rules`; no lugar das consultas `count()` e da paginação por cursor |
| Código no editor | Gerado a partir do prefixo que o subtema já usa; "Regras de registro" segue opcional |
| Logos de apoio | Levam aos sites institucionais, iguais aos do Observatório quando a instituição é a mesma |
| Contato | Abre o programa de e-mail com tudo preenchido, valida e confirma com "Copiar mensagem" |
| Painel | No padrão do Observatório, sem mudar dados, campos nem regras, sem situação de publicação, temas e subtemas só para consulta |
| Indexação | Metas por rota no app, mais uma página HTML por rota gerada no deploy e `sitemap.xml` em produção ([deployment.md](deployment.md)) |

**Referências visuais**

- Protótipo navegável (todas as telas, inclusive login, painel e editor): https://claude.ai/artifact/6tQuscgpFQk87MU2JZPNNs. Continua sendo a referência visual; leia-o com a ferramenta Artifact (`action: read`), não com WebFetch.
- Base visual e de código: o redesign do Observatório (`../observatorio_geo_hist`, protótipo em https://claude.ai/artifact/PimRbbQyUDbqrapiv8HseH). Tokens, fontes, botões, navbar, rodapé, estados e componentes do painel foram copiados e adaptados, não redesenhados.
- Aceite visual: 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`, com contraste mínimo de 4,5:1 e navegação por teclado.

## Rotas

Em [app_router.dart](../lib/core/navigation/app_router.dart). Rotas em português, minúsculas, sem acento e com hífen; ao renomear uma rota pública, a antiga continua redirecionando.

| Rota | Tela |
|---|---|
| `/` | Home: hero com contagens e anel dos 4 temas, cartões dos temas, como explorar, adicionados recentemente, resumo do Sobre, apoio e bloco do Observatório |
| `/representacoes-espaciais`, `/natureza-meio-ambiente`, `/espacos-urbanos-rurais`, `/cultura-politica` | Tema: migalhas, contagens, medalhão, grade de subtemas e "Outros temas" |
| `/:tema/:subtema` | Subtema: busca, chips de tipo, assuntos frequentes, linhas de objeto e "Carregar mais" |
| `/:tema/:subtema/:codigo` | Objeto: página própria, abre por link direto |
| `/sobre` | Sobre: boas-vindas, código de referência, metadados e tese, apoio |
| `/contato` | Contato por `mailto:` |
| `/admin` | Login (com sessão, vai para o painel) |
| `/admin/painel/objetos`, `/admin/painel/temas` | Painel, dentro da moldura |
| `/admin/painel/objetos/novo`, `/admin/painel/objetos/:codigo/editar` | Editor de objeto |
| qualquer outra | 404 ("Este lugar não está no mapa") |

O código do objeto vai na rota em minúsculas e com hífen (`nma-bio-03`); o original (`NMA_BIO_03`) também abre o objeto, redirecionando para a forma curta (`referenceCodeSlug`). `/admin/painel` redireciona para `/admin/painel/objetos`. As rotas dos objetos são irmãs das de subtema, para não empilhar a página do subtema por baixo. Detalhes do painel em [admin-panel.md](admin-panel.md).

## Catálogo único e Firestore

Objetos ficam em `themes/{sigla do tema}/subthemes/{sigla do subtema}/contents/{código}`. Títulos, descrições e ilustrações de temas e subtemas estão no código (`ThemeDataModel`), não no banco.

Todas as telas leem o mesmo **catálogo**: `lib/features/catalog/` faz uma consulta `collectionGroup('contents')`, uma vez por sessão, e o `CatalogStore` serve contagens, listas, recentes (por `originInfo.insertionDate`, texto ISO), busca e a ficha do objeto. Busca, filtros e "Carregar mais" (de 6 em 6) rodam no navegador sobre ele. Cada subtema tem poucas dezenas de objetos, então não há paginação por cursor.

- **Regra de leitura:** `firestore.rules` tem `match /{path=**}/contents/{contentId} { allow read: if true; }`, necessária para a consulta por grupo de coleções; quem pode gravar continua sendo quem tem sessão. O índice de grupo de `originInfo.insertionDate` fica em `firestore.indexes.json`. Os deploys publicam regras e índices ([deployment.md](deployment.md)).
- **Sem rede**, o Firestore responde com o cache local, que pode vir vazio: o datasource trata acervo vazio vindo do cache como falha (`CatalogOfflineException`) e tem tempo-limite de 15 s, para a tela mostrar o erro com "Tentar de novo" em vez de "nenhum objeto".
- O subtema Movimentos da Terra existe em `SubthemeEnum` e tem ilustração (`AppImages.movimentosTerra`, hoje sem uso), mas não tem objetos nem entra nas telas: o site mostra os subtemas de `ThemeDataModel`.
- Os prefixos dos códigos nem sempre coincidem com o enum (Poluição da Água usa `NMA_PAG_*`); o código novo segue o prefixo que os objetos do subtema já usam ([admin-panel.md](admin-panel.md)).

## Acessibilidade

- Toda área clicável tem foco visível por teclado e nome acessível (`Semantics`/dica); preferir `InkWell` e os botões do Material a `GestureDetector` solto. Cartão inteiro como link usa um clique numa camada fora da árvore de acessibilidade, para não criar um segundo ponto de foco que engula o título.
- Estados de carregamento, sucesso e erro são anunciados por `announceToScreenReader` (`SemanticsService.announce`) ou `LoadingRegion`.
- Limites do Flutter 3.35.5 no web: `toggled` sai como `aria-checked` (não há `aria-pressed`); `hint` de campo de texto é ignorado; `liveRegion` não vale num nó com papel nem em título; `InlineLink` com `linkUrl` externo faz o motor navegar a própria aba além de abrir a nova, por isso links de texto externos não levam `href`.
- O `SelectionArea` cria uma visão de plataforma que vira parada invisível de Tab; envolver em `ExcludeFocusTraversal` onde ele for aninhado.
- Dica de botão aberta por foco deve conferir se o botão ainda tem o foco ao abrir; seletor recriado a cada escolha tira o foco do campo, então só é recriado quando a mudança vem de fora.

## Páginas principais

- **Home:** contagens do catálogo, anel dos temas (`ThemesOrbit`), cartões dos 4 temas (sem carrossel) com descrição, contagens e subtemas, "Como explorar" em 3 passos com exemplos fixos, 6 recentes e resumo do Sobre.
- **Tema e subtema:** `ThemePage` e `SubthemePage`; busca ignora acentos e maiúsculas (`foldForSearch`) e procura em título, descrição, assunto e autor; "Assuntos frequentes" vêm do campo `subjects`.
- **Objeto:** tipo, título, descrição, "Acessar o recurso", "Copiar link", nota de conteúdo, ficha da curadoria com o código em destaque (grupos Autoria, Conteúdo, Origem, Registro, Direitos e preservação) e "Outros objetos" do subtema. O ano de emissão só aparece quando o objeto tem o dado.
- **Contato:** abre o programa de e-mail (`expogeoufu@gmail.com`) com tudo preenchido (`MailDraft`), valida os campos e mostra confirmação com "Copiar mensagem".
- **404:** `NotFoundPage`; endereços de tema, subtema ou objeto inexistentes caem nela.

## Convenções

- Interface, documentação, comentários e commits em **português do Brasil**; nomes de código em inglês. Classes em PascalCase, métodos e variáveis em camelCase, arquivos em snake_case.
- Comentários são exceção: só o porquê que o código não mostra, em uma ou duas linhas; sem referência a spec, fase ou protótipo; descrevem a regra de hoje, sem "antigo", "novo" ou "agora". `///` só quando traz o que o nome e o tipo não dizem.
- Commits `tipo: descrição` (`feat`, `fix`, `refactor`, `docs`, `chore`), só quando pedidos; push só com pedido explícito. Push na `main` publica a produção e nunca é direto; o fluxo está em [deployment.md](deployment.md).
- Comandos com FVM: `fvm flutter pub get`, `fvm flutter run -d chrome`, `fvm flutter analyze`, `fvm dart run build_runner build --delete-conflicting-outputs` (após mudar stores MobX ou modelos Freezed; os `*.g.dart` ficam no repositório e não passam pelo format), `fvm dart format` (largura 100, conferida no CI), `fvm flutter build web --release`, `fvm flutter test`.
- Testes em `test/`, espelhando `lib/`, com apoios em `test/support/` (`fake_auth`, `fake_content`, `fake_url_launcher`, `semantics`). Numa pasta com acento no caminho, `analyze`, `test` e `format` falham ou perdem o `analysis_options.yaml`: rode numa cópia em caminho ASCII.
- O ambiente vem de `--dart-define=APP_ENV=dev|prod` (padrão dev; ver [deployment.md](deployment.md)).

## Adicionando uma feature

1. Crie `lib/features/{feature}/` com `pages/` e `components/` (e `infra/` + `presentation/stores/` se houver dados).
2. Registre as dependências em `{feature}_setup.dart` e chame o setup em `main.dart`.
3. Rotas: constante e `GoRoute` em `app_router.dart`, em português; redirecione a rota antiga se renomear.
4. Use os tokens de `AppTheme`, os componentes do `core` e os estados de carregando, vazio e erro; confira 390, 768 e 1280 px e a navegação por teclado.
5. Rode `build_runner` se criou store ou modelo gerado, e adicione testes em `test/features/{feature}/`.

## Limitações conhecidas

- **Primeiro Tab de cada página** cai numa parada invisível (visão de plataforma do `SelectionArea` do `SiteScaffold`). Tirar a área do Tab tiraria tudo que está dentro dela.
- **Navbar de altura fixa** transborda com texto a 200%, e os títulos das colunas do rodapé são `h2`, somando-se aos da página. Não reconferido.
- **Leitor de tela real** (VoiceOver, NVDA), texto a 200% e o aviso nativo do navegador ao fechar a aba do editor: só árvore de semântica e testes. Não conferido.
- **Links de texto sem `href`** (contato e demais externos): o leitor de tela não os lê como link. `PartnerLogo` usa `linkUrl` externo e pode abrir a própria aba além da nova. Não conferido.
- **Contato:** "Copiar mensagem" copia assunto e corpo, sem o destinatário.
- **Ano de emissão:** nenhum objeto do dev tem o dado; só foi visto com o datasource alterado.
- **Nome longo de subtema** parte a palavra abaixo de cerca de 346 px (fora das larguras exigidas).
- Painel com Firestore real: [admin-panel.md](admin-panel.md). Produção, servidor e indexação: "Pendências manuais" de [deployment.md](deployment.md).

## Ideias futuras

- Busca geral do site.
- Modo escuro.
- Criar e editar temas e subtemas pelo painel (hoje só consulta; vêm do código), o que também permitiria descrições próprias para o Google.
- Situação de publicação (rascunho e publicado) e papéis de usuário no painel (hoje as regras só pedem sessão).
- Redes sociais próprias da expoGEO.
- Testes automatizados no CI (hoje só formatação, `analyze` e build) e previews por PR.
- Indexação: rodar o pré-render a cada mudança no painel (agendado ou disparado por ele), o que mantém o sitemap atual e permitiria devolver 404 de verdade para endereço inexistente; enriquecer as descrições curtas dos objetos.

## Fluxo de trabalho com specs (SDD)

Cada feature maior (de mais ou menos meio dia para cima, ou que mude várias telas) ganha uma pasta `docs/specs/NNN-nome-curto/` enquanto está em andamento; correções pequenas e ajustes pontuais dispensam spec. As skills do projeto criam os arquivos em sequência e **param** para a sua aprovação em cada etapa:

| Arquivo | Criado por | Conteúdo |
|---|---|---|
| `spec.md` | `/sdd-spec` | **O quê e por quê**: comportamento, estados, critérios de aceite, fora do escopo |
| `plan.md` | `/sdd-plan` | **Como**: abordagem técnica, arquivos afetados, decisões e riscos |
| `tasks.md` | `/sdd-plan` (atualizado por `/sdd-implement`) | Lista de tarefas ordenadas, com o progresso |
| `verificacao.md` | `/sdd-verify` | Resultado da conferência contra os critérios de aceite |

```
pedido ou ideia ──► /sdd-spec ──► (aprovação) ──► /sdd-plan ──► /sdd-implement ──► /sdd-verify ──► merge
 ("Ideias futuras")  spec.md                      plan.md        código +           verificacao.md
                                                  tasks.md       tasks.md marcadas
```

**Modo autônomo:** `/sdd-fase <pedido ou itens>` roda o fluxo inteiro sem paradas: divide o pedido em specs, faz cada etapa numa sessão separada, corrige o que a verificação achar (até 2 tentativas por problema), faz commits por entrega numa branch própria (`refactor/redesign-<fase>`, criada a partir da branch de integração) e termina com um resumo e um PR. O andamento fica em `docs/specs/execucao-<fase>.md`, que também serve para retomar se a execução for interrompida; no encerramento ele é apagado e o resumo vai para a descrição do PR.

**Regras**

- Numeração sequencial de três dígitos. As 001 a 019 já foram usadas e removidas; a próxima é a **020**. O nome é curto, em `kebab-case`, sem acentos.
- A spec tem um **status** no topo: `rascunho`, `aprovada`, `implementada` ou `verificada`.
- Uma spec só vai para o plano com **zero perguntas em aberto** e status `aprovada`.
- Se, durante a implementação, algo precisar divergir da spec, **atualize a spec primeiro** (e registre em "Histórico de mudanças"), depois o código.
- Cada critério de aceite deve poder ser conferido como "passou" ou "não passou".

**Depois do merge** a pasta da spec sai do repositório, no mesmo PR ou logo depois (a pasta `docs/specs/` só existe enquanto há spec em andamento). Antes disso:

- regras e padrões novos vão para este documento, o [admin-panel.md](admin-panel.md) ou o [deployment.md](deployment.md);
- ressalvas que seguem em aberto vão para "Limitações conhecidas" daqui, ou para as "Pendências manuais" do [deployment.md](deployment.md) quando dependem de servidor ou de conferência em produção;
- se a feature vinha de uma ideia futura, o item sai de "Ideias futuras".

Para consultar uma spec removida: `git log --all --oneline -- 'docs/specs/019-*'` e `git show <commit>:docs/specs/019-pre-render-seo/spec.md`.
