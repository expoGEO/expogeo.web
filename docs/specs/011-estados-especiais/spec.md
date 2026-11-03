# 011. Estados especiais: carregando, vazio, erro e 404

- **Status:** aprovada
- **Item do planejamento:** Fase 3, entrega 3.2 (tela T-07)
- **Protótipo:** aba "Estados" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Garantir que todas as telas públicas tratem do mesmo jeito o que acontece entre o clique e os dados: esqueleto enquanto carrega, mensagem clara quando não há nada, caminho de volta quando dá erro e uma 404 com a cara da expoGEO.

## Situação atual
- `core/pages/not_found_page.dart`: "Página não encontrada", "A página que você está procurando não existe ou foi movida." e "Voltar ao início", no visual antigo.
- `features/theme/components/subtheme_error.dart` ("Erro ao carregar conteúdos" e "Tentar Novamente") e um "Conteúdo em Desenvolvimento" para subtema sem conteúdo.
- Nas Fases 1 e 2, cada spec cria os estados da própria tela. Esta spec unifica as peças e cobre o que sobrar.

## Comportamento

### Peças compartilhadas
- **Caixa de estado:** borda tracejada, cantos arredondados, conteúdo centralizado: ícone em círculo, título (Bricolage), texto e ação opcional. Variante **erro** com ícone em círculo vermelho-claro.
- **Esqueleto:** blocos nas cores quentes com brilho que corre em ~1,4 s; parado com "reduzir movimento". Formatos: medalhão + duas linhas (cartão de subtema), linha de objeto (ícone, rótulo, título, descrição), cartão de objeto e número de contagem.
- Todas as telas das Fases 1 e 2 passam a usar essas peças (sem mudança de texto).

### Textos padrão
| Situação | Título | Texto | Ação |
|---|---|---|---|
| Busca sem resultado (subtema) | "Nenhum objeto encontrado" | "Nada em {Subtema} combina com "{busca}". Tente outra palavra ou veja todos os tipos." | "Limpar busca" (secundário) |
| Erro ao carregar objetos | "Não conseguimos carregar os objetos" | "Confira sua conexão com a internet e tente de novo." | "Tentar de novo" (primário) |
| Erro ao carregar um objeto | "Não conseguimos carregar o objeto" | idem | "Tentar de novo" |

### Página 404
- Caixa de estado com "404" grande em acento, título "**Este lugar não está no mapa**", texto "O endereço pode ter mudado ou o conteúdo saiu da curadoria. Volte aos temas para continuar explorando." e botão "Ir para o início".
- Com navbar e rodapé; nenhum item da navbar ativo; o endereço digitado continua na barra.
- Usada para rota inexistente, tema ou subtema inexistente, subtema de outro tema e código de objeto inexistente.

### Limpeza
- Saem `subtheme_error.dart`, o "Conteúdo em Desenvolvimento" e os demais componentes de estado antigos que ficarem sem uso.

## Estados
Esta spec é sobre eles; ver acima.
- **Casos de borda:** "Tentar de novo" várias vezes seguidas não empilha consultas; erro seguido de sucesso troca a caixa pela lista sem piscar; endereço muito longo não quebra a 404; offline com cache vazio do Firestore conta como erro, não como vazio (lição do Observatório).

## Responsivo
Caixa de estado com largura máxima de texto (~44 caracteres) e botões que quebram em coluna quando não cabem, em 390, 768 e 1280 px.

## Acessibilidade
- Título da caixa de estado é anunciado quando ela aparece (região de status); erro anunciado como alerta.
- Na 404, o título é o `h1`.
- Esqueleto marcado como "carregando" para leitores de tela, sem ler os blocos.
- Brilho desligado com "reduzir movimento".

## Dados e regras de negócio
- Nenhum dado novo. Só a forma de mostrar os estados.

## Critérios de aceite
- [ ] A 404 aparece em `/nao-existe`, `/natureza-meio-ambiente/nao-existe`, `/cultura-politica/biomas` e num código de objeto inexistente, com o texto e o botão do protótipo.
- [ ] Home, tema, subtema e objeto usam a mesma caixa de estado e o mesmo esqueleto.
- [ ] Os esqueletos têm brilho e ficam parados com "reduzir movimento".
- [ ] Offline, subtema e objeto mostram o erro com "Tentar de novo"; ao voltar a conexão, "Tentar de novo" carrega os dados.
- [ ] Busca sem resultado mostra a caixa com "Limpar busca", que restaura a lista.
- [ ] Os componentes antigos de erro e de "Conteúdo em Desenvolvimento" não existem mais no código.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1.

## Fora do escopo
- Estados do painel (Fase 4, specs 013 a 015).

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
