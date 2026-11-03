# 005. Home: Como explorar e Adicionados recentemente

- **Status:** implementada
- **Item do planejamento:** Fase 1, seções 1.3 e 1.4
- **Protótipo:** aba "Home", seções "Como explorar" e "Adicionados recentemente" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Mostrar a quem chega o caminho tema → subtema → objeto com exemplos reais e, logo abaixo, o que entrou de novo na curadoria, para a Home não parecer estática.

## Situação atual
- Desde a spec 004, a Home tem o hero (contagens e anel dos temas) e os cartões dos temas em "Por onde começar". Nada equivalente a "Como explorar" ou aos recentes existe.
- O catálogo único da 004 (`lib/features/catalog/`) já carrega todos os objetos numa consulta só, com tema e subtema de cada um, e é compartilhado pelas telas. Esta spec só lê o que ele já tem.
- Os objetos têm `originInfo.insertionDate` (texto ISO no Firestore, data no app).
- A regra de leitura por grupo de coleções está no `firestore.rules`, mas ainda não foi publicada no dev: hoje a consulta é negada e a Home fica no estado de erro do catálogo.
- Não existe cartão de objeto fora da lista do subtema (`content_card.dart`, que embute a ficha). A página do objeto (spec 009) ainda não existe.

## Comportamento

### Como explorar (1.3)
- Seção em fundo de superfície, rótulo "Como explorar" e título "Do tema ao recurso, em três passos".
- Três passos em colunas, cada um com número em círculo, título, texto e um exemplo com link real:
  1. **Escolha um tema** — "Quatro grandes temas da Geografia escolar, do mapa à política." Ex.: *Meio Ambiente e Natureza* (leva ao tema; o nome é o mesmo da navbar e dos cartões dos temas).
  2. **Entre num subtema** — "Cada subtema reúne objetos sobre um assunto, com busca e filtro por tipo." Ex.: *Biomas* · N objetos (leva ao subtema; N vem dos dados).
  3. **Acesse o recurso** — "Veja a ficha da curadoria e abra o site, vídeo ou aplicativo na fonte original." Ex.: título do primeiro objeto de Biomas, o de menor código de referência (leva à página do objeto, spec 009; até ela existir, leva ao subtema Biomas).
- Os exemplos são fixos no código (Meio Ambiente e Natureza → Biomas), mas o título do objeto e a contagem vêm dos dados.
- Cada passo tem um filete escuro em cima, como no protótipo; o exemplo fica numa caixa clara com "Ex.:" e o link em laranja.

### Adicionados recentemente (1.4)
- Título "Adicionados recentemente".
- Os **6 objetos com a data de inserção mais recente**, de qualquer tema, em grade de cartões.
- **Cartão de objeto** (componente novo, reutilizado na página do objeto e na prévia do editor):
  - ícone do tipo em quadrado de acento suave e a linha "Tipo · Formato" em rótulo (o formato some quando é "Outro" ou igual ao tipo, como "Vídeo · Vídeo");
  - título (link), descrição em até 2 linhas;
  - rodapé com o mini-medalhão do subtema, "Subtema · Criador" (nome do subtema em caixa normal, como nos cartões dos temas: "Biomas", não "BIOMAS").
- O cartão inteiro leva à página do objeto (spec 009). Até ela existir, leva ao subtema do objeto.

## Estados
- **Carregando:** 6 cartões-esqueleto no formato do cartão de objeto. "Como explorar" mostra o texto na hora; o título do exemplo 3 e a contagem do exemplo 2 mostram esqueleto curto.
- **Vazio:** sem nenhum objeto, a seção "Adicionados recentemente" não aparece; o exemplo 3 de "Como explorar" fica sem o link (a linha "Ex.:" do passo 3 não aparece). Sem objetos em Biomas, o exemplo 2 mostra "Biomas · 0 objetos" e o exemplo 3 some do mesmo jeito.
- **Erro:** a seção mostra o estado de erro compacto "Não conseguimos carregar os objetos recentes" com "Tentar de novo"; o resto da Home segue. "Tentar de novo" recarrega o catálogo (as contagens do hero e dos cartões voltam junto, se a carga der certo). Em "Como explorar", o exemplo 2 fica só com "Biomas" (sem a contagem) e o exemplo 3 fica sem o link, como no vazio.
- **Sem imagem:** mini-medalhão com placeholder.
- **Casos de borda:** menos de 6 objetos mostra os que houver; objetos com a mesma data seguem uma ordem estável (código de referência em ordem crescente); título muito longo quebra em até 3 linhas; descrição vazia não deixa espaço em branco; "1 objeto" no singular.

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
- Ordem por `originInfo.insertionDate` decrescente, sobre o catálogo único criado na spec 004 (Q-04). Sem consulta nova: a Home lê o mesmo catálogo que já alimenta as contagens.
- O subtema e o tema de cada objeto vêm do catálogo (caminho do documento), não dos campos `themeId`/`subthemeId`.
- Tipo e formato: enums `ContentType` e `ContentFormat` do `content_model.dart`; os ícones do protótipo substituem as cores por tipo do enum na interface nova (as cores antigas continuam para o painel até a Fase 4).

## Critérios de aceite
- [ ] "Como explorar" mostra os três passos com os textos acima e os três exemplos levam ao destino certo.
- [ ] A contagem de Biomas e o título do exemplo 3 vêm dos dados do ambiente.
- [ ] "Adicionados recentemente" mostra os 6 objetos de data de inserção mais recente (conferir contra o Firestore do dev; enquanto a regra de leitura por grupo de coleções não estiver publicada, conferir com os dados do dev lidos por subtema e servidos por um datasource falso só na cópia de conferência).
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
- 2026-11-03: revisada diante do que a Fase 0 e a 004 entregaram (modo autônomo, sem a pessoa). Situação atual atualizada (Home com hero e cartões, catálogo único pronto, regra ainda não publicada no dev, página do objeto inexistente). Nome do tema no exemplo 1 igual ao do site ("Meio Ambiente e Natureza", decisão da 004). "Primeiro objeto de Biomas" = menor código de referência; o exemplo 3 leva ao subtema até a 009 existir, como o cartão. Nome do subtema em caixa normal no cartão. Estados de erro e vazio de "Como explorar" detalhados; "Tentar de novo" recarrega o catálogo inteiro. Desempate por código em ordem crescente. Critério 3 com conferência por dados do dev enquanto a regra não for publicada. Status mantido em `aprovada`.
- 2026-11-03: implementada (modo autônomo). Sem divergência da spec. Sucesso conferido com dados do dev servidos por datasource falso; conferência com o Firestore real pendente até a regra de leitura por grupo de coleções ser publicada.
