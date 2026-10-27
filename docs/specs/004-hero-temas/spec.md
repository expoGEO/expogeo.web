# 004. Home: hero, contagens e cartões dos temas

- **Status:** aprovada
- **Item do planejamento:** Fase 1, seções 1.1 e 1.2
- **Protótipo:** aba "Home", topo e seção "Temas" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Quem chega à Home entende em uma frase o que é a expoGEO, vê quanto há para explorar e enxerga os 4 temas de uma vez, sem depender de carrossel.

## Situação atual
- `features/home/pages/home_page.dart` monta `HomeBanner` (logo, "ExpoGEO", "Conhecimento, Tecnologia e Interatividade" e um texto longo de boas-vindas) e `ThemesRow`, um carrossel (`carousel_slider`) de `ThemeCard` com botão "Explorar".
- Não há contagens em lugar nenhum do site.
- Títulos, descrições e ilustrações dos temas e subtemas estão no código (`ThemeDataModel`); os objetos ficam no Firestore em `themes/{tema}/subthemes/{subtema}/contents`.

## Comportamento

### Hero (1.1)
- Fundo de superfície com círculos concêntricos discretos (decorativos).
- Rótulo "Curadoria digital do saber geográfico".
- Título: "Conteúdos digitais de Geografia, **escolhidos para a sala de aula.**" (a segunda parte no acento).
- Texto: "Sites, vídeos, mapas e aplicativos confiáveis, organizados por tema para estudantes, professores e quem quer entender o mundo pela Geografia."
- Botões: **"Explorar os temas ↓"** (primário, rola até a seção Temas e põe o foco no título dela) e **"Como fazemos a curadoria"** (secundário, leva a `/sobre`).
- Contagens abaixo dos botões, separadas por uma linha: **N objetos digitais**, **N subtemas**, **N temas**. Números em Bricolage, rótulos em texto secundário.
- **Anel dos temas** à direita: anel com o degradê expoGEO, anel tracejado interno, o símbolo no centro e os 4 medalhões dos temas nas posições norte, leste, sul e oeste. Cada medalhão leva ao tema, cresce levemente no hover e no foco.

### Cartões dos temas (1.2)
- Seção com rótulo "Temas" e título "Por onde começar". Âncora de destino de "Explorar os temas" e de "Ver todos na página inicial" da navbar.
- Grade de 4 cartões (2 colunas no desktop e tablet, 1 no celular). Cada cartão:
  - faixa de 4 px com o degradê no topo;
  - medalhão do tema (ilustração inteira, 1:1, fundo branco, borda fina);
  - nome do tema (link), descrição real do tema;
  - "**N** subtemas · **N** objetos";
  - até 4 nomes de subtemas em mini-chips não clicáveis e "+N" quando houver mais.
- O cartão inteiro é clicável e leva ao tema; hover com borda no acento, elevação e o medalhão gira levemente.
- Substitui o carrossel (`themes_row`, `theme_card`). O texto de boas-vindas sai da Home e vai para `/sobre` (spec 006).

### Componente de medalhão
Criado na spec 002 (menu Temas da navbar) e reutilizado aqui, nas páginas de tema e subtema, no painel e no editor: ilustração inteira em círculo (1:1, `contain`), fundo branco, borda de linha, tamanho definido por quem usa. Sem imagem ou com falha: fundo acento suave com ícone de mapa.

## Estados
- **Carregando:** as contagens mostram um esqueleto do tamanho dos números; título, texto, anel e cartões aparecem na hora (vêm do código). Nos cartões, o trecho "N objetos" mostra esqueleto.
- **Erro nas contagens:** os números de objetos somem (fica "N subtemas" e "4 temas", que vêm do código); o resto da Home funciona. Sem mensagem de erro aqui.
- **Vazio:** tema sem objetos mostra "0 objetos"; não acontece hoje, mas não quebra.
- **Sem imagem / falha:** placeholder do medalhão.
- **Casos de borda:** tema com menos de 4 subtemas não mostra "+N"; nomes longos de subtema quebram linha dentro do chip sem estourar o cartão.

## Responsivo
- **390:** anel em cima (até ~230 px), depois rótulo, título, texto, botões empilhados se não couberem e contagens. Cartões em 1 coluna, medalhão de 68 px.
- **768:** anel em cima (até ~300 px); cartões em 1 coluna.
- **1280:** texto à esquerda e anel à direita (até 440 px); cartões em 2 colunas, medalhão de 116 px.

## Acessibilidade
- Título do hero é o `h1` da página; "Por onde começar" é `h2`; nome do tema no cartão é `h3`.
- Medalhões do anel têm nome acessível com o nome do tema; o anel e os círculos de fundo são decorativos (ignorados por leitores de tela).
- Contagens lidas como frase ("190 objetos digitais").
- Hover e giro do medalhão respeitam "reduzir movimento".
- Cartão clicável com foco visível e um único ponto de foco (sem link duplicado no título e no cartão).

## Dados e regras de negócio
- Temas, descrições, subtemas e ilustrações: `ThemeDataModel`.
- Contagem de subtemas e de temas: do código.
- **Catálogo único (Q-04):** esta spec cria a carga de todos os objetos numa consulta só (`collectionGroup('contents')`), feita uma vez por visita e reaproveitada por todas as telas (Home, tema, subtema, objeto e painel). Contagem total e por tema saem dele, por isso batem com as páginas de tema e subtema.
- **Regra do Firestore:** entra no `firestore.rules` a leitura para grupo de coleções (`match /{path=**}/contents/{id} { allow read: if true; }`). Só leitura; quem pode gravar continua igual. O deploy publica só os índices, então a regra é publicada à mão no `expogeo-dev` e depois no `expogeo-fad33`, antes do merge na `main`.
- Objetos com tema ou subtema que não está no `ThemeDataModel` são ignorados nas contagens.

## Critérios de aceite
- [ ] Hero com rótulo, título, texto, dois botões e as três contagens como no protótipo.
- [ ] "Explorar os temas" rola até "Por onde começar" e move o foco para lá.
- [ ] "Como fazemos a curadoria" leva a `/sobre`.
- [ ] As contagens batem com os dados do ambiente (no dev, 190 objetos, 31 subtemas, 4 temas).
- [ ] O catálogo é carregado numa consulta só; navegar para outra página não repete a consulta.
- [ ] `firestore.rules` tem a regra de leitura para grupo de coleções, publicada no dev; as regras de gravação não mudaram.
- [ ] O anel mostra os 4 medalhões, cada um leva ao seu tema e tem nome acessível.
- [ ] Os 4 cartões mostram faixa em degradê, medalhão, nome, descrição, contagens corretas e até 4 subtemas + "+N".
- [ ] Clicar em qualquer parte do cartão leva ao tema; o foco por teclado passa uma vez por cartão.
- [ ] Contagens com esqueleto ao carregar e somem sem quebrar a Home quando a consulta falha (testar offline).
- [ ] Ilustração ausente mostra o placeholder do medalhão.
- [ ] O carrossel e o texto longo de boas-vindas não aparecem mais na Home.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1.

## Fora do escopo
- Como explorar e Adicionados recentemente (spec 005).
- Resumo do Sobre, apoio e bloco do Observatório (spec 006).
- Remover `carousel_slider` do `pubspec.yaml` (spec 016).

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único com a regra de leitura para grupo de coleções.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida; a spec passa a criar o catálogo único e a regra do Firestore.
- 2026-10-27: aprovada.
- 2026-10-27: o componente de medalhão passa a nascer na 002 (o menu Temas precisa dele antes); aqui ele é reaproveitado. A seção de temas da Home deve manter a chave usada por "Ver todos na página inicial" (`HomeSections`).
