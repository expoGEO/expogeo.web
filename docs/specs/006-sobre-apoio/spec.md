# 006. Página Sobre, resumo na Home, apoio e bloco do Observatório

- **Status:** aprovada
- **Item do planejamento:** Fase 1, seções 1.5, 1.6 e 1.7 (tela T-05, Sobre, antecipada da Fase 3)
- **Protótipo:** abas "Home" (seções "Sobre a expoGEO", "Realização e apoio" e bloco do Observatório) e "Sobre" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

> **Por que T-05 entra aqui:** o resumo da Home (1.5) leva a `/sobre`, e a página Sobre reutiliza o apoio e o bloco do Observatório (1.6). Fazer tudo junto evita uma página provisória.

## Objetivo
Explicar quem faz a expoGEO e como a curadoria funciona, com o texto completo numa página própria e um resumo na Home, e deixar visível que a expoGEO é parte do Observatório.

## Situação atual
- Depois da 004 e da 005, a Home tem hero, "Por onde começar", "Como explorar" e "Adicionados recentemente", e termina aí, antes do rodapé.
- O texto de boas-vindas antigo saiu da Home na 004, mas o arquivo dele (`features/home/components/home_banner.dart`) ficou no repositório, sem uso, para servir de fonte a esta spec. Ao lado dele está `logo.dart`, também sem uso e sem conteúdo próprio.
- A constante `AppRouter.about` (`/sobre`) existe, mas não há rota. O item "Sobre" da navbar, o link "Sobre a expoGEO" do rodapé e o botão "Como fazemos a curadoria" do hero levam à página "não encontrada" (com "Sobre" já marcado na navbar, e a barra de endereço sem mudar).
- Os logos de apoio saíram do rodapé na 002 e estão em `assets/images/` em WebP desde a 003 (`ufu`, `faced`, `ppged`, `fapemig`, `capes`, `cnpq`), sem uso.
- "Metadados da curadoria" e "Tese de doutorado" só aparecem no rodapé.
- Ainda não existem migalhas nem cabeçalho de página no site (as páginas de tema e subtema ganham os seus na 007 e na 008).
- O estilo do código de referência é Figtree 600 com algarismos tabulares, não fonte monoespaçada (decisão da 001).

## Comportamento

### Resumo na Home (1.5)
- Seção em superfície, logo depois de "Adicionados recentemente", em duas colunas.
- Esquerda: rótulo "Sobre a expoGEO", título "Uma curadoria feita na universidade, pensada para a escola.", texto "Reunimos materiais confiáveis e recursos educacionais digitais que aproximam conhecimento científico, práticas pedagógicas e tecnologias contemporâneas." e link "Saiba mais sobre o projeto →" (`/sobre`).
- Direita: três públicos com ícone em círculo de acento suave, separados por filetes:
  - **Estudantes** — "Conteúdos para estudar e aprofundar cada tema, com acesso direto à fonte."
  - **Professores** — "Recursos já descritos e organizados por assunto para levar à sala de aula."
  - **Interessados em Geografia** — "Um ponto de partida confiável para compreender o mundo a partir do espaço."
- Os públicos são só texto (não são clicáveis); os ícones são decorativos.

### Realização e apoio (1.6)
- Título "Realização e apoio" e grade com os logos UFU, FACED, PPGED, FAPEMIG, CAPES e CNPq, nessa ordem.
- Mesmo efeito do Observatório: logos em cinza e meio transparentes; no hover e no foco ficam coloridos, sobem levemente e ganham fundo branco com borda e sombra.
- Cada logo é link para o site da instituição (aba nova), com os mesmos endereços do Observatório (Q-07): ufu.br, faced.ufu.br, ppged.faced.ufu.br, fapemig.br, gov.br/capes e gov.br/cnpq. O Observatório tem as seis.
- Na Home, a seção vem depois do resumo; no Sobre, depois do texto.

### Bloco do Observatório (1.6)
- Cartão escuro (mesmo fundo do rodapé), com círculos decorativos no canto, o símbolo do Observatório (os círculos concêntricos laranja do redesign do Observatório), o rótulo "A expoGEO faz parte do", o título "**Observatório do Ensino de História e Geografia**", o texto "Narrativas, pesquisas, documentos e uma biblioteca de teses e dissertações sobre o ensino de História e Geografia." e o botão primário "Visitar o Observatório ↗".
- Aparece no fim da Home (depois do apoio) e no fim da página Sobre.

### Página Sobre (T-05, rota `/sobre`)
- Cabeçalho em superfície: migalhas "Início › Sobre", título "Sobre a expoGEO" e "Conhecimento, tecnologia e interatividade a serviço do ensino de Geografia."
- Texto em coluna de leitura (até 720 px), com os três parágrafos do protótipo, que substituem o texto de boas-vindas antigo:
  1. "A expoGEO é um espaço pensado para estudantes, professores e todos que se interessam por compreender o mundo a partir da Geografia. Aqui você encontra uma seleção cuidadosa de conteúdos digitais que abordam os principais temas geográficos de forma dinâmica, interativa e pedagogicamente qualificada."
  2. "Reunimos materiais confiáveis, recursos educacionais digitais e propostas inovadoras que potencializam os processos de ensino e aprendizagem da Geografia escolar, aproximando conhecimento científico, práticas pedagógicas e tecnologias contemporâneas."
  3. "O projeto integra as ações do Programa de Pós-Graduação em Educação da Universidade Federal de Uberlândia (PPGED/UFU) e foi desenvolvido no âmbito do Observatório do Ensino de História e Geografia (OEHGEO/UFU), fortalecendo a articulação entre pesquisa, formação docente e curadoria de conteúdos educacionais."
- **"Como cada objeto é descrito"** (título de seção): "Todo objeto digital recebe uma ficha com autoria, conteúdo, origem, registro, direitos e ação de preservação. O código de referência diz onde ele está na curadoria:" e o exemplo em três blocos com borda: `RE` Tema geral · Representações Espaciais; `LM` Tema específico · Leitura de Mapas; `01` Número de referência na curadoria. As letras do código ficam grandes, em laranja forte, na fonte do código de referência do site (Figtree 600 com algarismos tabulares). Depois, "Os links são revisados ao longo do tempo para que continuem funcionando."
- Botões secundários "Metadados da curadoria ↗" e "Tese de doutorado ↗" (mesmos links do rodapé, aba nova).
- Realização e apoio e bloco do Observatório no fim.
- Item "Sobre" da navbar ativo.
- O arquivo do texto de boas-vindas antigo sai do repositório quando o texto novo estiver no ar; a frase final dele ("Para começar sua experiência, explore os cards abaixo…") não volta, porque falava dos cartões antigos da Home.

## Estados
- **Carregando / vazio / erro:** não se aplica; o conteúdo é fixo. As seções novas da Home não dependem do catálogo e aparecem mesmo quando as contagens ou os recentes falham.
- **Logo com falha:** some o logo e aparece a sigla da instituição no lugar; o nome da instituição continua como nome acessível do link; a grade não deixa buraco.
- **Casos de borda:** texto a 200% de zoom quebra sem cortar os blocos do código de referência nem o bloco do Observatório.

## Responsivo
- **390:** resumo em 1 coluna (texto, depois públicos); logos em 2 colunas; bloco do Observatório empilhado (símbolo, texto, botão); os três blocos do código em 1 coluna; botões do Sobre empilhados se não couberem.
- **768:** resumo em 1 coluna; logos em 3 colunas; bloco do Observatório empilhado; código em 3 colunas.
- **1280:** resumo em 2 colunas; logos em 6 colunas; bloco do Observatório em linha (símbolo, texto, botão); código em 3 colunas.

## Acessibilidade
- `/sobre` tem um único `h1`; seções com `h2` ("Como cada objeto é descrito", "Realização e apoio" e o título do bloco do Observatório). Na Home, o título do resumo, "Realização e apoio" e o título do bloco são `h2`; os públicos são `h3`.
- Migalhas com nome "Você está em" e a página atual marcada.
- Logos com o nome completo da instituição; efeito de hover também no foco por teclado; respeita "reduzir movimento" (muda cor e fundo, sem subir nem crescer).
- Links externos anunciam que abrem em aba nova.
- Ícones dos públicos, símbolo do Observatório e círculos decorativos ficam fora da leitura de tela.

## Dados e regras de negócio
- Rota nova `/sobre`, usando a constante `AppRouter.about` que já existe. Nenhuma rota existente muda.
- Textos fixos no código. Nada vem do Firestore.
- Endereços de metadados, tese e Observatório são os do rodapé (uma fonte só).

## Critérios de aceite
- [ ] 1. A Home mostra, depois de "Adicionados recentemente", o resumo com rótulo, título, texto, link e os três públicos, seguido de "Realização e apoio" e do bloco do Observatório.
- [ ] 2. "Saiba mais sobre o projeto", "Como fazemos a curadoria" (hero), "Sobre" (navbar e menu do celular) e "Sobre a expoGEO" (rodapé) abrem a página Sobre, e a barra de endereço mostra `/sobre`.
- [ ] 3. `/sobre` abre direto pelo endereço e ao recarregar, com cabeçalho, migalhas, os três parágrafos, a explicação do código, os dois botões, apoio e bloco do Observatório.
- [ ] 4. As migalhas têm o nome "Você está em", "Início" leva à Home e "Sobre" aparece como página atual.
- [ ] 5. `/sobre` tem um único `h1` ("Sobre a expoGEO") e `h2` em "Como cada objeto é descrito", "Realização e apoio" e no título do bloco do Observatório.
- [ ] 6. "Metadados da curadoria" e "Tese de doutorado" abrem os mesmos endereços do rodapé em aba nova e anunciam isso.
- [ ] 7. Os seis logos aparecem em cinza e meio transparentes e ficam coloridos, com fundo branco, no hover e no foco por teclado; com "reduzir movimento", não sobem nem crescem; cada um abre o site da instituição em aba nova e tem o nome completo da instituição como nome acessível.
- [ ] 8. Um logo que falha ao carregar mostra a sigla, mantém o link com o nome da instituição e não abre buraco na grade.
- [ ] 9. O bloco do Observatório aparece na Home e no Sobre e o botão abre `observatoriogeohistoria.net.br` em aba nova.
- [ ] 10. Item "Sobre" ativo na navbar (e no menu do celular) em `/sobre`.
- [ ] 11. Os blocos do código de referência (`RE`, `LM`, `01`) usam Figtree 600, ficam em 1 coluna em 390 e em 3 em 768 e 1280, e a 200% de zoom quebram sem cortar texto.
- [ ] 12. O arquivo do texto de boas-vindas antigo (`home_banner.dart`) não existe mais e nada o importa.
- [ ] 13. Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; resumo em 1, 1 e 2 colunas; logos em 2, 3 e 6 colunas; contraste ≥ 4,5:1 em todo texto.

## Fora do escopo
- Contato (spec 010).
- Equipe da expoGEO (não existe no protótipo).
- Título da aba do navegador por página.
- Migalhas e cabeçalho das páginas de tema, subtema e objeto (007 a 009; elas reaproveitam os componentes criados aqui).
- Imagens antigas (PNG) e o `AppImages.logo`, que a 016 limpa.

## Perguntas em aberto
- Nenhuma. (Respondida: Q-07, sites institucionais, iguais aos do Observatório quando a instituição for a mesma.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-07 respondida.
- 2026-10-27: aprovada.
- 2026-11-03: revisada diante da Fase 0, da 004 e da 005 (modo autônomo, sem a pessoa). "Situação atual" reescrita: a Home já tem hero, temas, "Como explorar" e recentes; `home_banner.dart` e `logo.dart` estão sem uso; a constante `/sobre` existe e os links caem na página não encontrada; os logos estão em WebP e fora do rodapé desde a 002; o código de referência usa Figtree 600 com algarismos tabulares (001), não monoespaçada como no protótipo. Decisões: (1) posição das seções novas na Home: depois de "Adicionados recentemente", na ordem do protótipo; (2) os três parágrafos são os do protótipo, transcritos aqui, e substituem o texto antigo, cuja frase final sobre "os cards abaixo" não volta; o arquivo antigo é apagado nesta spec (critério 12); (3) logos em 3 colunas no tablet (a spec dizia "3 a 4"); (4) bloco do Observatório escuro como no protótipo, empilhado também em 768, com o símbolo do redesign do Observatório (o PNG com o nome escrito em escuro não serve sobre fundo escuro); (5) logo com falha mostra a sigla, como no Observatório; (6) critérios detalhados e numerados (migalhas, títulos, botões do Sobre, falha de logo, código e remoção do arquivo antigo), passando de 7 para 13.
- 2026-11-03: decisões do plano (modo autônomo): apoio, bloco do Observatório, migalhas e cabeçalho viram componentes compartilhados portados do Observatório; símbolo do Observatório em SVG copiado do redesign de lá; rótulo, link "Saiba mais" e ícones dos públicos em laranja forte por contraste (como na 004 e na 005); `logo.dart`, sem uso e sem conteúdo, sai junto com `home_banner.dart`. Nenhuma mudança de comportamento.
- 2026-11-03: ajustes na implementação (modo autônomo, sem mudança de comportamento): (1) o Flutter 3.35 não tem papel de navegação na semântica, então as migalhas são um grupo com o nome "Você está em" (o leitor de tela anuncia o nome do grupo; o item atual sai como "Sobre, página atual"); (2) a caixa de cada logo usa a proporção da maioria das imagens daqui (512 × 216), não a do Observatório (280 × 186), e as outras cabem inteiras; (3) o teste de 200% da página Sobre cobre os blocos novos (código, bloco do Observatório, migalhas): a barra da navbar, de altura fixa, transborda com texto a 200% no teste e fica fora do escopo desta spec.
