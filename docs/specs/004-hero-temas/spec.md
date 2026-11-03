# 004. Home: hero, contagens e cartões dos temas

- **Status:** implementada
- **Item do planejamento:** Fase 1, seções 1.1 e 1.2
- **Protótipo:** aba "Home", topo e seção "Temas" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Quem chega à Home entende em uma frase o que é a expoGEO, vê quanto há para explorar e enxerga os 4 temas de uma vez, sem depender de carrossel.

## Situação atual
- Depois da Fase 0 (001 a 003), a Home já usa a faixa do Observatório, a navbar e o rodapé novos, os tokens novos e as ilustrações em WebP. O conteúdo ainda é o antigo: `features/home/pages/home_page.dart` monta `HomeBanner` (logo grande e um texto longo de boas-vindas) e `ThemesRow`, uma fileira com rolagem lateral de `ThemeCard` com botão "Explorar" (o pacote `carousel_slider` continua no `pubspec`, mas nenhum arquivo o importa mais).
- "Ver todos na página inicial" (menu Temas da navbar) já pede à Home que role até a fileira de temas (`HomeSections`).
- O medalhão (`AppMedallion`, criado na 002) e os botões novos (`AppButton`) já existem.
- Não há contagens em lugar nenhum do site.
- Títulos, descrições e ilustrações dos temas e subtemas estão no código (`ThemeDataModel`); os objetos ficam no Firestore em `themes/{tema}/subthemes/{subtema}/contents`. Hoje só há leitura por subtema; a leitura por grupo de coleções é negada (conferido no dev em 2026-11-03).

## Comportamento

### Hero (1.1)
- Fundo de superfície com círculos concêntricos discretos (decorativos).
- Rótulo "Curadoria digital do saber geográfico".
- Título: "Conteúdos digitais de Geografia, **escolhidos para a sala de aula.**" (a segunda parte no acento).
- Texto: "Sites, vídeos, mapas e aplicativos confiáveis, organizados por tema para estudantes, professores e quem quer entender o mundo pela Geografia."
- Botões: **"Explorar os temas ↓"** (primário, rola até a seção Temas e põe o foco no título dela) e **"Como fazemos a curadoria"** (secundário, leva a `/sobre`). A página `/sobre` nasce na spec 006; até lá o endereço abre a página "não encontrada".
- Contagens abaixo dos botões, separadas por uma linha: **N objetos digitais**, **N subtemas**, **N temas**. Números em Bricolage, rótulos em texto secundário.
- **Anel dos temas** à direita: anel com o degradê expoGEO, anel tracejado interno, o símbolo no centro e os 4 medalhões dos temas nas posições norte, leste, sul e oeste. Cada medalhão leva ao tema, cresce levemente no hover e no foco.

### Cartões dos temas (1.2)
- Seção com rótulo "Temas" e título "Por onde começar". Âncora de destino de "Explorar os temas" e de "Ver todos na página inicial" da navbar (este segue o pedido que a navbar já faz hoje, agora apontando para esta seção).
- Grade de 4 cartões (2 colunas no desktop; 1 coluna no tablet e no celular, como em "Responsivo" e no protótipo). Cada cartão:
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
- **Catálogo único (Q-04):** esta spec cria a carga de todos os objetos numa consulta só (`collectionGroup('contents')`), feita uma vez por visita e pensada para ser reaproveitada por todas as telas (Home, tema, subtema, objeto e painel). Aqui só a Home passa a usá-lo; as outras telas o adotam nas próprias specs (005, 007, 008, 009, 014). Contagem total e por tema saem dele, por isso vão bater com as páginas de tema e subtema.
- **Regra do Firestore:** entra no `firestore.rules` a leitura para grupo de coleções (`match /{path=**}/contents/{id} { allow read: if true; }`). Só leitura; quem pode gravar continua igual. O deploy publica só os índices, então a regra é publicada à mão pela pessoa no `expogeo-dev` e depois no `expogeo-fad33`, antes do merge na `main`. Esta entrega só altera o arquivo. Sem a regra publicada, a consulta é negada e a Home fica no estado "erro nas contagens".
- Tema e subtema de cada objeto saem do caminho do documento (`themes/{RE}/subthemes/{RE_CG}/contents/...`). Objetos com tema ou subtema que não está no `ThemeDataModel` (por exemplo, Movimentos da Terra, que não está na lista do tema) são ignorados nas contagens.
- Números esperados no dev (contados por subtema em 2026-11-03): 190 objetos; Representações Espaciais 35, Natureza e Meio Ambiente 74, Espaços Urbanos e Rurais 42, Cultura e Política 39; subtemas 7, 12, 6 e 6 (31).

## Critérios de aceite
- [ ] Hero com rótulo, título, texto, dois botões e as três contagens como no protótipo.
- [ ] "Explorar os temas" rola até "Por onde começar" e move o foco para lá.
- [ ] "Como fazemos a curadoria" leva ao endereço `/sobre`.
- [ ] Com a regra publicada no dev, as contagens batem com os dados do ambiente (190 objetos, 31 subtemas, 4 temas; por tema 35, 74, 42 e 39 objetos). Se a regra ainda não estiver publicada na conferência, vale o teste do catálogo com dados simulados e o critério fica pendente da publicação.
- [ ] O catálogo é carregado numa consulta só; sair da Home e voltar não repete a consulta.
- [ ] `firestore.rules` tem a regra de leitura para grupo de coleções; as regras de gravação não mudaram. (A publicação no dev e na produção é feita à mão pela pessoa.)
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
- 2026-11-03: revisada diante da Fase 0 (modo autônomo, sem a pessoa). "Situação atual" atualizada (navbar, rodapé, `AppMedallion`, `AppButton` e `HomeSections` já existem; a fileira de temas não usa mais `carousel_slider`). Registrado que `/sobre` só nasce na 006. O catálogo é usado só pela Home nesta entrega. A regra do Firestore entra no arquivo e a publicação fica com a pessoa: no dev a leitura por grupo de coleções ainda é negada, então o critério das contagens passa a depender da publicação, com números por tema conferidos por subtema (190 = 35 + 74 + 42 + 39). Tema e subtema de cada objeto saem do caminho do documento.
- 2026-11-03: decisões do plano (modo autônomo): (1) a grade de cartões tem 2 colunas só no desktop; "Comportamento" dizia "desktop e tablet" e contradizia "Responsivo" e o protótipo, que mandam 1 coluna em 768. (2) No carregamento, só o número de objetos mostra esqueleto; subtemas e temas vêm do código e aparecem na hora. (3) O rótulo e a parte em destaque do título do hero usam o laranja forte (`accentStrong`), porque o acento sobre o fundo de superfície fica em 4,45:1, abaixo do mínimo de 4,5:1. (4) "Explorar os temas" põe o foco no título "Por onde começar" sem anel visível (o título não é clicável). (5) O arquivo do texto de boas-vindas (`home_banner.dart`) sai da Home mas fica no repositório até a 006 levar o texto para `/sobre`.
- 2026-11-03: implementação (modo autônomo). Os mini-chips mostram o nome do subtema em caixa normal (o do `SubthemeEnum`), porque os títulos de subtema no `ThemeDataModel` estão em maiúsculas. O nome do tema no anel e nos cartões é o título do `ThemeModel` ("Meio Ambiente e Natureza"), o mesmo da navbar. O critério das contagens com dados reais segue pendente da publicação da regra no dev.
- 2026-11-03: implementada.
