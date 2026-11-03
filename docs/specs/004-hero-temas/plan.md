# Plano da 004. Home: hero, contagens e cartões dos temas

- **Spec:** spec.md
- **Criado em:** 2026-11-03

## Abordagem
Três frentes, nesta ordem: o **catálogo** (dados), as **peças visuais** que faltam no tema (esqueleto e tokens) e a **Home** nova.

**Catálogo.** Uma feature nova, `lib/features/catalog/`, no mesmo desenho das outras (Datasource → Repository → Store MobX, `Either` na volta, registro no `catalog_setup.dart` chamado pelo `main.dart`). O datasource faz uma única `collectionGroup('contents').get()` e entrega os documentos com caminho, id e dados. Um modelo puro (`CatalogModel`) transforma essa lista: tema e subtema saem do caminho (`themes/{RE}/subthemes/{RE_CG}/contents/{doc}`), comparados com `ThemeEnum.id` e `SubthemeEnum.id`; só entram os subtemas que estão na lista do tema no `ThemeDataModel`; caminhos de outro formato e documentos que não se convertem em `ContentResponseModel` ficam de fora. O modelo responde total, total por tema e total por subtema, e guarda os objetos para as specs 005, 007, 008, 009 e 014. O store é um singleton: `ensureLoaded()` só consulta se ainda não carregou nem está carregando, e tenta de novo apenas depois de um erro. Assim, sair da Home e voltar não repete a consulta. A consulta tem limite de 15 s; passou disso, vira erro (sem rede o SDK pode ficar esperando).

**Regra do Firestore.** Entra no `firestore.rules`, fora do `match /themes/...`, o bloco `match /{path=**}/contents/{contentId} { allow read: if true; }`. Nada de gravação muda. O arquivo não é publicado pelo deploy (o `firebase.json` só aponta os índices) e a publicação fica com a pessoa. Conferido em 2026-11-03 pela API REST do dev: a leitura por grupo de coleções hoje é negada (`PERMISSION_DENIED`) e a leitura por subtema soma 190 objetos (35, 74, 42 e 39 por tema).

**Esqueleto e tokens.** O `Skeleton` do Observatório (`lib/app/core/components/skeleton/skeleton.dart`) vem para `lib/core/components/skeleton/app_skeleton.dart`, com `skeletonBase`/`skeletonHighlight` no `AppColors` e `skeletonShimmer` no `ComponentSizes` (mesmos valores de lá; parado quando "reduzir movimento" está ligado). As medidas do protótipo viram tokens no `ComponentSizes` (anel, medalhões, cartão, contagens, mini-chips) e a cor do anel tracejado vira token no `AppColors`.

**Home.** `HomePage` passa a montar dois slivers: `HomeHero` e `HomeThemesSection`, sobre fundo `page`. O hero tem fundo `surface` com os círculos concêntricos desenhados por um `CustomPainter` (dois focos, como no `.hero::before` do protótipo, com esmaecimento para baixo), excluídos da semântica. À esquerda (ou embaixo, abaixo de 1024 px): rótulo, `h1` em duas partes, texto, `AppButton.primary` "Explorar os temas" com seta para baixo e `AppButton.secondary` "Como fazemos a curadoria" (vai para `AppRouter.about`), e a linha de contagens (`HeroCounts`). À direita (ou em cima): `ThemesOrbit`, um quadrado com lado limitado por faixa (230, 300, 440 px) e o resto proporcional, como no CSS do protótipo: anel com o degradê `AppGradients.brand` pintado em traço, anel tracejado interno, símbolo (`AppImages.logoSimple`) ao centro e os 4 medalhões em norte, leste, sul e oeste. A seção de temas tem rótulo, `h2` "Por onde começar" e a grade de `ThemeOverviewCard` (2 colunas a partir de 760 px de largura de conteúdo, 1 abaixo; na prática 2 colunas em 1280, 1 em 768 e 390, como a spec pede).

O pedido de rolagem que já existe (`HomeSections.themesRequested`, usado pela navbar) continua apontando para a seção; "Explorar os temas" usa o mesmo método e, além de rolar, põe o foco num `FocusNode` do título "Por onde começar".

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `firestore.rules` | Leitura por grupo de coleções em `contents` |
| Criar | `lib/features/catalog/infra/datasources/catalog_datasource.dart` | Uma consulta `collectionGroup('contents')` com limite de 15 s |
| Criar | `lib/features/catalog/infra/models/catalog_model.dart` | Lista de objetos com tema e subtema tirados do caminho; totais por tema e subtema |
| Criar | `lib/features/catalog/infra/errors/catalog_failure.dart` | Falhas do catálogo |
| Criar | `lib/features/catalog/infra/repositories/catalog_repository.dart` | `Either<CatalogFailure, CatalogModel>` |
| Criar | `lib/features/catalog/presentation/stores/catalog_state.dart` | Estados selados: inicial, carregando, sucesso, erro |
| Criar | `lib/features/catalog/presentation/stores/catalog_store.dart` (+ `.g.dart`) | Store MobX singleton com `ensureLoaded()` |
| Criar | `lib/features/catalog/catalog_setup.dart` | Registro no `GetIt` |
| Alterar | `lib/main.dart` | Chama `CatalogSetup.setup()` |
| Alterar | `lib/core/theme/app_colors/app_colors.dart` | `skeletonBase`, `skeletonHighlight`, `orbitDashed` |
| Alterar | `lib/core/theme/app_dimensions/app_dimensions.dart` | Tokens do hero, do anel, do cartão, das contagens, dos mini-chips e do esqueleto |
| Criar | `lib/core/components/skeleton/app_skeleton.dart` | Esqueleto do Observatório |
| Criar | `lib/features/home/components/home_hero.dart` | Hero: fundo, textos, botões, contagens e anel |
| Criar | `lib/features/home/components/hero_counts.dart` | Linha das três contagens com esqueleto e estado de erro |
| Criar | `lib/features/home/components/themes_orbit.dart` | Anel dos temas com os 4 medalhões clicáveis |
| Criar | `lib/features/home/components/home_themes_section.dart` | Rótulo, `h2` com foco e grade dos cartões |
| Criar | `lib/features/home/components/theme_overview_card.dart` | Cartão do tema com faixa, medalhão, contagens e mini-chips |
| Alterar | `lib/features/home/pages/home_page.dart` | Monta hero e seção; rolagem e foco em "Por onde começar"; carrega o catálogo |
| Apagar | `lib/features/home/components/carousel/themes_row.dart`, `carousel/theme_card.dart` | Substituídos pelos cartões (a spec manda substituir) |
| Criar | `test/features/catalog/catalog_model_test.dart` | Caminho → tema/subtema, totais, descartes |
| Criar | `test/features/catalog/catalog_store_test.dart` | Uma consulta só; nova tentativa só após erro |
| Criar | `test/features/home/hero_counts_test.dart` | Esqueleto, sucesso, erro e frase lida pelo leitor de tela |
| Criar | `test/features/home/theme_overview_card_test.dart` | Até 4 chips + "+N", um único ponto de foco, toque leva ao tema, placeholder |
| Criar | `test/features/home/themes_orbit_test.dart` | 4 medalhões com nome acessível e toque no tema |

`home_banner.dart` e `logo.dart` saem da Home mas o arquivo fica (ver Decisões).

## Decisões técnicas
- **Catálogo como feature própria (`lib/features/catalog/`), não em `lib/core/`.** Tem datasource, repositório e store, que pela arquitetura ficam numa feature; várias telas vão ler o mesmo store pelo `GetIt`.
- **Tema e subtema pelo caminho do documento**, não pelos campos `themeId`/`subthemeId`: o `ContentResponseModel.fromJson` cai num valor padrão (Coordenadas Geográficas) quando não reconhece o campo, o que contaria objetos no lugar errado. O caminho é o que as páginas de subtema já leem hoje.
- **Documento que não converte fica fora do catálogo**, sem derrubar a carga inteira. Se a conferência der menos de 190 no dev, o motivo aparece no teste do modelo e na comparação por subtema.
- **Nova tentativa só depois de erro.** "Uma vez por visita" vale para a carga que deu certo; depois de uma falha (sem rede, regra não publicada), voltar à Home tenta de novo. Sem recarga automática em segundo plano.
- **Limite de 15 s na consulta**, igual ao aviso de demora da tela de carregamento (003). Sem ele, offline o esqueleto poderia ficar para sempre.
- **Esqueleto só no número de objetos.** Subtemas (31) e temas (4) vêm do código e aparecem na hora; na falha, some só o bloco "objetos digitais" e, nos cartões, o trecho "· N objetos". Registrado no histórico da spec.
- **Parte em destaque do título e rótulo do hero em `accentStrong`.** O `accent` sobre o `surface` dá 4,45:1 (fica abaixo de 4,5:1, como o próprio `AppColors` avisa); o critério de contraste da spec pede 4,5:1. Fora do hero (fundo branco), o rótulo "Temas" fica no `accent`. Registrado no histórico da spec.
- **Foco em "Por onde começar" sem anel visível.** O título recebe foco (para leitor de tela e para o próximo Tab ir ao primeiro cartão), mas não é clicável, então não ganha anel. A navbar segue só rolando, como hoje.
- **Cartão com um único ponto de foco.** O `InkWell` do cartão inteiro tem o foco e o nome acessível (`Semantics(link: true)` com o nome do tema); o nome dentro dele é `Text` com `Semantics(header: true, headingLevel: 3)`, sem link próprio. O protótipo tem um `<a>` no `h3`; aqui não, pela regra de foco único da spec.
- **Anel pintado com `CustomPainter`.** Degradê em traço (`Paint.shader` com o `AppGradients.brand`) e tracejado calculado sobre o círculo. Alternativa: `DecoratedBox` com borda em degradê, que o Flutter não tem pronta.
- **Medalhões do anel reaproveitam o `AppMedallion`** dentro de um disco branco com sombra (`shadows.soft`), como o `.orbit .m` do protótipo; hover e foco aumentam 6% (`AnimatedScale`), sem animação com "reduzir movimento". Cada um é `InkWell` circular com `AppFocusRing` e `Semantics(link: true, label: <nome do tema>)`; o medalhão interno fica sem rótulo (decorativo).
- **Hover do cartão:** borda `accent`, `shadows.elevated`, sobe 3 px e o medalhão gira −8°. Com "reduzir movimento", só borda e sombra mudam.
- **Círculos de fundo do hero.** O protótipo da Home (`.hero-x`) não tem os círculos; a spec aprovada tem. Seguir a spec, com os valores do `.hero::before` do protótipo (traço de 1 px a cada 27 e 35 px, acento a 11% e tinta a 6%, esmaecendo a partir de 55% da altura).
- **`home_banner.dart` e `logo.dart` ficam no repositório, fora de uso.** O texto de boas-vindas é conteúdo real e vai para `/sobre` na 006; apagar o arquivo antes disso tiraria a fonte de quem implementa a 006. A 006 (ou a 016) apaga. O `analyze` não reclama de arquivo sem uso. `themes_row.dart` e `theme_card.dart` não têm conteúdo próprio e saem agora.
- **Nomes das ilustrações:** `ThemeEnum.illustration` (extensão `ThemeIllustration`, criada na Fase 0), não o `ThemeModel.imagePath` (`.jpg` antigo, inexistente).
- **Descrição do tema com `trim()`** na exibição (a de Cultura e Política termina com espaço), sem mexer no modelo.
- **Testes sem pacote novo.** O datasource devolve registros simples (caminho, id, dados); o modelo e o store são testados com dados simulados e um repositório falso. Nada de `fake_cloud_firestore`.

## Dependências e geração de código
- Nenhum pacote novo (`cloud_firestore`, `mobx`, `flutter_mobx`, `get_it`, `dartz` já existem). `carousel_slider` continua no `pubspec` (sai na 016). Se o `pub get` mexer no `pubspec.lock`, restaurar com `git restore pubspec.lock`.
- `fvm dart run build_runner build --delete-conflicting-outputs` depois de criar o `catalog_store.dart` (gera `catalog_store.g.dart`).
- Registro: `CatalogSetup.setup()` no `main.dart`, depois do `ThemeSetup.setup()` (que registra o `FirebaseFirestore`; o setup do catálogo registra também se faltar).
- Rotas: nenhuma nova nem alterada. O botão usa `AppRouter.about` (constante já existente; a rota nasce na 006).
- Assets: nenhum novo (ilustrações WebP e `logo_simple.png` já existem).

## Riscos e cuidados
- **Regra não publicada no dev.** Até a pessoa publicar, a consulta é negada e a Home fica no estado de erro das contagens (o resto funciona). A conferência do critério 4 depende disso: sem publicação, o número 190 é conferido no teste do modelo com os totais por subtema e o critério fica pendente. **No `main`, publicar a regra na produção antes do merge**, senão o site publicado perde as contagens.
- **Custo de leitura:** 190 documentos por visita (uma vez). Hoje cada subtema já lê 20 + 1 contagem; a carga única cresce com o acervo. Aceito em Q-04.
- **`HomeSections`** é usado pela navbar ("Ver todos na página inicial"): conferir que o link ainda rola até "Por onde começar" vindo de outra página e de dentro da Home.
- **`AppMedallion`, `AppButton` e tokens** são compartilhados (navbar, menu Temas, rodapé, 404). Os tokens novos só se somam; conferir o menu Temas e a 404 depois.
- **Semântica do cartão:** um `InkWell` com `Semantics` por cima pode fundir o título e perder o nível do cabeçalho. Teste de widget confere o nó de link único e, no navegador, a árvore de acessibilidade (`read_page`).
- **Contraste:** tabela na tarefa de conferência (inkSecondary sobre surface e sobre os mini-chips, accentStrong sobre surface, texto do botão).
- **Asserções de layout** (grade, `Wrap` dos chips, anel quadrado dentro de `Column`) só aparecem em debug: rodar ao menos uma vez com `flutter run -d web-server`.
- **Caminho com "ó":** `analyze`, `test` e `build_runner` na cópia ASCII do scratchpad; trazer só os arquivos gerados de volta.
- **Painel admin:** não muda (não usa o catálogo nesta entrega). Sem credenciais de teste, fica "não conferido na tela".

## Como conferir
- `fvm flutter analyze` e `fvm flutter test` na cópia ASCII; `fvm dart format` nos `.dart` alterados (fora os gerados).
- `git diff --stat` sem `lib/features/admin/`, `app_router.dart`, modelos, `pubspec.*`; `firestore.rules` só com o bloco novo.
- `fvm flutter build web --release`, servidor Python próprio com fallback para `index.html`, navegador embutido em 390, 768 e 1280 px: hero, anel, contagens (erro enquanto a regra não for publicada; números se já estiver), "Explorar os temas", "Como fazemos a curadoria", cartões, hover, teclado, rede (uma consulta ao Firestore, sem repetição ao voltar). Uma vez em debug. Voltar o navegador ao preset desktop e parar os servidores.
