# 005. Home: Como explorar e Adicionados recentemente

- **Status:** aprovada
- **Item do planejamento:** Fase 1, seções 1.3 e 1.4
- **Protótipo:** aba "Home", seções "Como explorar" e "Adicionados recentemente" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Mostrar a quem chega o caminho tema → subtema → objeto com exemplos reais e, logo abaixo, o que entrou de novo na curadoria, para a Home não parecer estática.

## Situação atual
- Nada equivalente existe. A Home tem só o banner e o carrossel.
- Os objetos têm `originInfo.insertionDate` (texto ISO). O índice de `collectionGroup('contents')` por essa data, decrescente, já está em `firestore.indexes.json`.
- Não existe cartão de objeto fora da lista do subtema (`content_card.dart`, que embute a ficha).

## Comportamento

### Como explorar (1.3)
- Seção em fundo de superfície, rótulo "Como explorar" e título "Do tema ao recurso, em três passos".
- Três passos em colunas, cada um com número em círculo, título, texto e um exemplo com link real:
  1. **Escolha um tema** — "Quatro grandes temas da Geografia escolar, do mapa à política." Ex.: *Natureza e Meio Ambiente* (leva ao tema).
  2. **Entre num subtema** — "Cada subtema reúne objetos sobre um assunto, com busca e filtro por tipo." Ex.: *Biomas* · N objetos (leva ao subtema; N vem dos dados).
  3. **Acesse o recurso** — "Veja a ficha da curadoria e abra o site, vídeo ou aplicativo na fonte original." Ex.: título do primeiro objeto de Biomas (leva à página do objeto, spec 009).
- Os exemplos são fixos no código (Natureza e Meio Ambiente → Biomas), mas o título do objeto e a contagem vêm dos dados.

### Adicionados recentemente (1.4)
- Título "Adicionados recentemente".
- Os **6 objetos com a data de inserção mais recente**, de qualquer tema, em grade de cartões.
- **Cartão de objeto** (componente novo, reutilizado na página do objeto e na prévia do editor):
  - ícone do tipo em quadrado de acento suave e a linha "Tipo · Formato" em rótulo (o formato some quando é "Outro" ou igual ao tipo, como "Vídeo · Vídeo");
  - título (link), descrição em até 2 linhas;
  - rodapé com o mini-medalhão do subtema, "Subtema · Criador".
- O cartão inteiro leva à página do objeto (spec 009). Até ela existir, leva ao subtema do objeto.

## Estados
- **Carregando:** 6 cartões-esqueleto no formato do cartão de objeto. "Como explorar" mostra o texto na hora; o título do exemplo 3 e a contagem do exemplo 2 mostram esqueleto curto.
- **Vazio:** sem nenhum objeto, a seção "Adicionados recentemente" não aparece; o exemplo 3 de "Como explorar" fica sem o link.
- **Erro:** a seção mostra o estado de erro compacto "Não conseguimos carregar os objetos recentes" com "Tentar de novo"; o resto da Home segue.
- **Sem imagem:** mini-medalhão com placeholder.
- **Casos de borda:** menos de 6 objetos mostra os que houver; objetos com a mesma data seguem uma ordem estável (pelo código de referência); título muito longo quebra em até 3 linhas.

## Responsivo
- **390:** passos em 1 coluna; cartões em 1 coluna.
- **768:** passos em 1 coluna; cartões em 2 colunas.
- **1280:** passos em 3 colunas; cartões em 3 colunas.

## Acessibilidade
- Títulos de seção `h2`; título de cada passo e de cada cartão `h3`.
- Número do passo é decorativo (a ordem vem da lista).
- Ícone do tipo é decorativo; o tipo está escrito no rótulo.
- Cartão com um único ponto de foco e foco visível.

## Dados e regras de negócio
- Ordem por `originInfo.insertionDate` decrescente, sobre o catálogo único criado na spec 004 (Q-04). Sem consulta nova.
- Tipo e formato: enums `ContentType` e `ContentFormat` do `content_model.dart`; os ícones do protótipo substituem as cores por tipo do enum na interface nova (as cores antigas continuam para o painel até a Fase 4).

## Critérios de aceite
- [ ] "Como explorar" mostra os três passos com os textos acima e os três exemplos levam ao destino certo.
- [ ] A contagem de Biomas e o título do exemplo 3 vêm dos dados do ambiente.
- [ ] "Adicionados recentemente" mostra os 6 objetos de data de inserção mais recente (conferir contra o Firestore do dev).
- [ ] O cartão mostra tipo · formato (com a regra de omissão), título, descrição em até 2 linhas, mini-medalhão, subtema e criador.
- [ ] Clicar no cartão leva à página do objeto (ou ao subtema, enquanto a spec 009 não existir).
- [ ] Esqueleto ao carregar, seção oculta sem dados e erro com "Tentar de novo" que funciona (testar offline e voltar).
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1.

## Fora do escopo
- Página do objeto (spec 009).
- "Ver todos os recentes" ou listagem geral de objetos.

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único da spec 004.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida.
- 2026-10-27: aprovada.
