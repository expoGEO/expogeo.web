# 006. Página Sobre, resumo na Home, apoio e bloco do Observatório

- **Status:** aprovada
- **Item do planejamento:** Fase 1, seções 1.5, 1.6 e 1.7 (tela T-05, Sobre, antecipada da Fase 3)
- **Protótipo:** abas "Home" (seções "Sobre a expoGEO", "Realização e apoio" e bloco do Observatório) e "Sobre" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

> **Por que T-05 entra aqui:** o resumo da Home (1.5) leva a `/sobre`, e a página Sobre reutiliza o apoio e o bloco do Observatório (1.6). Fazer tudo junto evita uma página provisória.

## Objetivo
Explicar quem faz a expoGEO e como a curadoria funciona, com o texto completo numa página própria e um resumo na Home, e deixar visível que a expoGEO é parte do Observatório.

## Situação atual
- O texto de boas-vindas ocupa o `HomeBanner`. Não existe rota `/sobre`.
- Os logos de apoio estão em `assets/images/` (`ufu`, `faced`, `ppged`, `fapemig`, `capes`, `cnpq`), sem uso destacado.
- Metadados da curadoria e tese só aparecem no rodapé.

## Comportamento

### Resumo na Home (1.5)
- Seção em superfície, duas colunas.
- Esquerda: rótulo "Sobre a expoGEO", título "Uma curadoria feita na universidade, pensada para a escola.", texto "Reunimos materiais confiáveis e recursos educacionais digitais que aproximam conhecimento científico, práticas pedagógicas e tecnologias contemporâneas." e link "Saiba mais sobre o projeto →" (`/sobre`).
- Direita: três públicos com ícone em círculo de acento suave:
  - **Estudantes** — "Conteúdos para estudar e aprofundar cada tema, com acesso direto à fonte."
  - **Professores** — "Recursos já descritos e organizados por assunto para levar à sala de aula."
  - **Interessados em Geografia** — "Um ponto de partida confiável para compreender o mundo a partir do espaço."

### Realização e apoio (1.6)
- Título "Realização e apoio" e grade com os logos UFU, FACED, PPGED, FAPEMIG, CAPES e CNPq.
- Mesmo efeito do Observatório: logos em cinza e meio transparentes; no hover e no foco ficam coloridos, sobem levemente e ganham fundo branco com borda e sombra.
- Cada logo é link para o site da instituição (aba nova), com os mesmos endereços do Observatório quando a instituição for a mesma (Q-07). Conferir no código do Observatório e usar os sites institucionais para as que ele não tiver (ufu.br, faced.ufu.br, ppged.faced.ufu.br, fapemig.br, gov.br/capes, gov.br/cnpq).

### Bloco do Observatório (1.6)
- Cartão com o símbolo do Observatório, "A expoGEO faz parte do", "**Observatório do Ensino de História e Geografia**", "Narrativas, pesquisas, documentos e uma biblioteca de teses e dissertações sobre o ensino de História e Geografia." e o botão "Visitar o Observatório ↗".
- Aparece no fim da Home e da página Sobre.

### Página Sobre (T-05, rota `/sobre`)
- Cabeçalho em superfície: migalhas "Início › Sobre", título "Sobre a expoGEO" e "Conhecimento, tecnologia e interatividade a serviço do ensino de Geografia."
- Texto em coluna de leitura (até ~720 px), os três parágrafos de boas-vindas que saem da Home (textos do protótipo).
- **"Como cada objeto é descrito":** "Todo objeto digital recebe uma ficha com autoria, conteúdo, origem, registro, direitos e ação de preservação. O código de referência diz onde ele está na curadoria:" e o exemplo em três blocos: `RE` Tema geral · Representações Espaciais; `LM` Tema específico · Leitura de Mapas; `01` Número de referência na curadoria. Depois, "Os links são revisados ao longo do tempo para que continuem funcionando."
- Botões secundários "Metadados da curadoria ↗" e "Tese de doutorado ↗" (mesmos links do rodapé).
- Realização e apoio e bloco do Observatório no fim.
- Item "Sobre" da navbar ativo.

## Estados
- **Carregando / vazio / erro:** não se aplica; o conteúdo é fixo.
- **Logo com falha:** some o logo, o nome da instituição continua como nome acessível do link; a grade não deixa buraco.
- **Casos de borda:** texto a 200% de zoom quebra sem cortar os blocos do código de referência.

## Responsivo
- **390:** resumo em 1 coluna (texto, depois públicos); logos em 2 colunas; bloco do Observatório empilhado; os três blocos do código em 1 coluna.
- **768:** resumo em 1 coluna; logos em 3 a 4 colunas; código em 3 colunas.
- **1280:** resumo em 2 colunas; logos em 6 colunas.

## Acessibilidade
- `/sobre` tem um único `h1`; seções com `h2`.
- Migalhas com nome "Você está em" e a página atual marcada.
- Logos com nome da instituição; efeito de hover também no foco; respeita "reduzir movimento".
- Links externos anunciam que abrem em aba nova.

## Dados e regras de negócio
- Rota nova `/sobre` como constante do `AppRouter`.
- Textos fixos no código. Nada vem do Firestore.

## Critérios de aceite
- [ ] A Home mostra o resumo com título, texto, link e os três públicos.
- [ ] "Saiba mais sobre o projeto" e "Como fazemos a curadoria" (hero) levam a `/sobre`.
- [ ] `/sobre` abre direto pelo endereço, com cabeçalho, migalhas, os três parágrafos, a explicação do código, os dois botões, apoio e bloco do Observatório.
- [ ] Os seis logos aparecem em cinza e ficam coloridos no hover e no foco por teclado; cada um abre o site da instituição em aba nova.
- [ ] O bloco do Observatório aparece na Home e no Sobre e abre `observatoriogeohistoria.net.br` em aba nova.
- [ ] Item "Sobre" ativo na navbar em `/sobre`.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1.

## Fora do escopo
- Contato (spec 010).
- Equipe da expoGEO (não existe no protótipo).

## Perguntas em aberto
- Nenhuma. (Respondida: Q-07, sites institucionais, iguais aos do Observatório quando a instituição for a mesma.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-07 respondida.
- 2026-10-27: aprovada.
