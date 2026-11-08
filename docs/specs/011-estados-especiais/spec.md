# 011. Estados especiais: carregando, vazio, erro e 404

- **Status:** aprovada
- **Item do planejamento:** Fase 3, entrega 3.2 (tela T-07)
- **Protótipo:** aba "Estados" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Garantir que todas as telas públicas tratem do mesmo jeito o que acontece entre o clique e os dados: esqueleto enquanto carrega, mensagem clara quando não há nada, caminho de volta quando dá erro e uma 404 com a cara da expoGEO.

## Situação atual
As Fases 1 e 2 já criaram quase todas as peças, e cada tela trata os próprios estados:
- **Peças prontas em `lib/core/components/`:** caixa de estado (`state/state_message_box.dart`: borda tracejada, ícone em círculo, título, texto, ação e tom de erro com círculo vermelho-claro), erro compacto de seção (`state/state_error_inline.dart`) e bloco de esqueleto com brilho de 1,4 s que para com "reduzir movimento" (`skeleton/app_skeleton.dart`). Os esqueletos de cartão de objeto, linha de objeto, cabeçalho e ficha do objeto já existem nos componentes de cada tela.
- **Home:** contagens do hero e dos cartões de tema com esqueleto, somem no erro (004); "Como explorar" com esqueleto curto (005); "Adicionados recentemente" com 6 cartões-esqueleto, seção oculta sem dados e erro compacto "Não conseguimos carregar os objetos recentes" com "Tentar de novo" (005).
- **Tema:** cabeçalho e cartões vêm do código; só as contagens têm esqueleto e somem no erro (007).
- **Subtema:** 3 linhas-esqueleto; erro "Não conseguimos carregar os objetos" com "Tentar de novo" **secundário** e ícone de nuvem; vazio "Nenhum objeto neste subtema ainda" com "Voltar a {Tema}"; busca sem resultado já com o texto e o "Limpar busca" desta spec (008).
- **Objeto:** esqueleto do cabeçalho e da ficha; erro "Não conseguimos carregar o objeto" com "Tentar de novo" primário e ícone de nuvem (009).
- **404:** `core/pages/not_found_page.dart` ainda no visual antigo ("Página não encontrada", "A página que você está procurando não existe ou foi movida.", "Voltar ao início", fundo em degradê azul, cores e tamanhos soltos). Já é usada pelo roteador (endereço inexistente), pelo subtema (inexistente, de outro tema ou fora da lista do tema) e pelo objeto (código inexistente ou de outro subtema). Em endereços que começam por um tema, a navbar marca "Temas" como ativo.
- **Componentes antigos:** `subtheme_error.dart` e o "Conteúdo em Desenvolvimento" já saíram na 008. Sobram `CircularLoading` (`loading/circular_loading.dart`), `ContentError` e `ContentEmpty`, todos usados só pelo painel e pelos botões antigos (`PrimaryButton`/`SecondaryButton`, também do painel).
- **Leitura de tela:** os blocos de esqueleto ficam fora da leitura, mas a lista de linhas, a ficha e os cartões-esqueleto não dizem que estão carregando. O título da caixa de estado é região anunciada nos dois tons; o erro não é anunciado como alerta.
- **Offline:** o catálogo consulta o Firestore com tempo-limite de 15 s, mas uma resposta vazia vinda do cache seria tratada como acervo vazio.

## Comportamento

### Peças compartilhadas
- **Caixa de estado:** como já existe (borda tracejada, cantos arredondados, conteúdo centralizado: ícone em círculo, título em Bricolage, texto de até ~44 caracteres por linha e ação opcional). Tom **erro** com ícone de alerta em círculo vermelho-claro; tom neutro com ícone de busca (busca sem resultado) ou de caixa (vazio). Ganha a variante **404**, com o "404" grande em acento no lugar do ícone.
- **Erro compacto de seção:** para seção secundária de uma página que continua de pé (hoje só "Adicionados recentemente" na Home), mantido como na 005.
- **Erro de carregamento padrão:** caixa de erro com o texto "Confira sua conexão com a internet e tente de novo." e "Tentar de novo" **primário**, igual no subtema e no objeto.
- **Esqueleto:** blocos nas cores quentes com brilho que corre em ~1,4 s; parado com "reduzir movimento". Formatos em uso: linha de objeto (ícone, rótulo, título, descrição), cartão de objeto, cabeçalho e ficha do objeto, número de contagem e frase curta. Cada grupo de esqueletos é anunciado uma vez como "Carregando…" e os blocos não são lidos.
- Todas as telas das Fases 1 e 2 seguem usando essas peças, sem mudança de texto (salvo o que a tabela abaixo indica).

### Textos padrão
| Situação | Título | Texto | Ação |
|---|---|---|---|
| Busca sem resultado (subtema) | "Nenhum objeto encontrado" | "Nada em {Subtema} combina com "{busca}". Tente outra palavra ou veja todos os tipos." | "Limpar busca" (secundário) |
| Subtema sem objetos | "Nenhum objeto neste subtema ainda" | (sem texto) | "Voltar a {Tema}" (fantasma) |
| Erro ao carregar objetos (subtema) | "Não conseguimos carregar os objetos" | "Confira sua conexão com a internet e tente de novo." | "Tentar de novo" (primário; hoje secundário) |
| Erro ao carregar um objeto | "Não conseguimos carregar o objeto" | idem | "Tentar de novo" (primário) |
| Erro nos recentes (Home, compacto) | — | "Não conseguimos carregar os objetos recentes" | "Tentar de novo" (secundário pequeno) |

### Página 404
- Caixa de estado com "404" grande em acento, título "**Este lugar não está no mapa**", texto "O endereço pode ter mudado ou o conteúdo saiu da curadoria. Volte aos temas para continuar explorando." e botão primário "Ir para o início", que leva à Home.
- Com navbar e rodapé; nenhum item da navbar nem do menu do celular ativo, mesmo quando o endereço começa por um tema; o endereço digitado continua na barra.
- Usada para rota inexistente (inclusive com segmentos demais), subtema inexistente, subtema de outro tema ou fora da lista do tema e código de objeto inexistente ou de outro subtema. No objeto e no subtema, a 404 só aparece depois que os dados chegam, quando depende deles.

### Limpeza
- Sai o visual antigo da 404 (degradê azul, cores e medidas soltas).
- `CircularLoading`, `ContentError` e `ContentEmpty` ficam: são do painel, que não muda nesta fase (saem nas Fases 4 e 5, specs 013 a 016).

## Estados
Esta spec é sobre eles; ver acima.
- **Casos de borda:** "Tentar de novo" várias vezes seguidas não empilha consultas; erro seguido de sucesso troca a caixa pelo conteúdo, passando pelo esqueleto, sem caixa e lista ao mesmo tempo; endereço muito longo não quebra a 404 (ele não é mostrado na página); offline com resposta vazia vinda do cache conta como erro, não como vazio (lição do Observatório).

## Responsivo
Caixa de estado com largura máxima de texto (~44 caracteres) em 390, 768 e 1280 px. O "404" tem tamanho fixo por faixa (celular, tablet, desktop), sem escalar com a tela. Sem rolagem horizontal nem `overflow`.

## Acessibilidade
- Caixa neutra anunciada como status quando aparece; caixa de erro anunciada como alerta.
- Na 404, o título é o único `h1`; o "404" é decorativo e fica fora da leitura.
- Esqueleto marcado como "Carregando…" para leitores de tela, sem ler os blocos.
- Brilho desligado com "reduzir movimento".
- "Ir para o início" e "Tentar de novo" com foco visível por teclado.

## Dados e regras de negócio
- Nenhum dado novo. Só a forma de mostrar os estados.
- Rotas, modelos e regras do Firebase não mudam. O painel não muda.

## Critérios de aceite
- [ ] 1. A 404 aparece em `/nao-existe`, `/natureza-meio-ambiente/nao-existe`, `/cultura-politica/biomas`, `/natureza-meio-ambiente/biomas/nao-existe` (código inexistente) e `/a/b/c/d`, com "404", título, texto e botão do protótipo, navbar e rodapé, e o endereço digitado na barra.
- [ ] 2. "Ir para o início" leva à Home.
- [ ] 3. Na 404 nenhum item da navbar nem do menu do celular fica ativo, inclusive em `/natureza-meio-ambiente/nao-existe`.
- [ ] 4. Na 404, o título é o único `h1` e o "404" não é lido.
- [ ] 5. Subtema e objeto mostram, no erro, a caixa de erro com ícone de alerta, o texto padrão e "Tentar de novo" primário; "Adicionados recentemente" mostra o erro compacto; com a falha removida, "Tentar de novo" carrega os dados.
- [ ] 6. Clicar "Tentar de novo" várias vezes seguidas faz uma única consulta.
- [ ] 7. Resposta vazia vinda do cache (offline) vira erro, não estado vazio.
- [ ] 8. A caixa de erro é anunciada como alerta e a caixa neutra como status.
- [ ] 9. Busca sem resultado mostra a caixa com "Limpar busca", que restaura a lista.
- [ ] 10. Os esqueletos têm brilho, ficam parados com "reduzir movimento", e cada grupo (linhas do subtema, cartões dos recentes, cabeçalho e ficha do objeto) é anunciado como "Carregando…" sem ler os blocos.
- [ ] 11. Nenhuma tela pública usa `CircularLoading`, `CircularProgressIndicator`, `ContentError`, `ContentEmpty` ou cores e medidas soltas em estados; a 404 antiga não existe mais; nenhum arquivo do painel muda.
- [ ] 12. Em 390, 768 e 1280 px, a 404 e as caixas de estado não têm rolagem horizontal nem `overflow` (inclusive com endereço muito longo); contraste ≥ 4,5:1 nos textos.

## Fora do escopo
- Estados do painel e a remoção de `CircularLoading`, `ContentError` e `ContentEmpty` (Fases 4 e 5, specs 013 a 016).
- Esqueleto de medalhões dos subtemas (ver perguntas).
- Mudança de rotas, modelos ou regras do Firebase.

## Perguntas em aberto
- Esqueleto de medalhões ("Carregando os subtemas" da aba "Estados"): decidido no modo autônomo: não usar, porque na expoGEO medalhão e nome dos subtemas vêm do código e aparecem na hora; só a contagem espera os dados e já tem esqueleto (decisão igual à da 007).
- Erro na Home: decidido no modo autônomo: manter o erro compacto nos recentes e as contagens que somem em silêncio, porque a 004 e a 005 decidiram assim e a Home continua útil sem esses dados; a caixa grande tomaria a página por uma seção secundária.
- Botão de "Tentar de novo" no subtema: decidido no modo autônomo: primário, porque a caixa de erro do protótipo e a tabela desta spec pedem primário e a 009 já segue assim.
- Ícone do erro: decidido no modo autônomo: alerta, e não nuvem, porque o protótipo usa o ícone de alerta.
- "404" na leitura de tela: decidido no modo autônomo: decorativo, porque o título já diz que o lugar não existe e ler "404" antes dele só atrasaria.
- Navbar na 404 sob endereço de tema: decidido no modo autônomo: nenhum item ativo, como a spec já pedia, porque marcar "Temas" num endereço que não existe indicaria um lugar que não está no mapa.
- Componentes de estado antigos do painel: decidido no modo autônomo: ficam até as Fases 4 e 5, porque o painel não pode mudar nesta fase.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
- 2026-11-08: revisada diante das Fases 0 a 2 e da 010 (modo autônomo, sem a pessoa). "Situação atual" reescrita: as peças compartilhadas e quase todos os estados já existem; `subtheme_error.dart` e "Conteúdo em Desenvolvimento" já tinham saído na 008; os componentes antigos que restam são do painel e ficam. "Comportamento" passa a cobrir o erro compacto da Home, o vazio do subtema, o erro padrão primário com ícone de alerta, o anúncio "Carregando…" dos esqueletos e a navbar neutra na 404. Critérios refeitos para serem conferíveis um a um (de 7 para 12), com os endereços reais. Decisões registradas em "Perguntas em aberto".
- 2026-11-08: plano e tarefas criados (modo autônomo): 12 critérios ligados a 15 tarefas.
- 2026-11-08: ajustes da implementação (modo autônomo). Caixa neutra com papel de status e caixa de erro com papel de alerta, as duas com anúncio explícito do título ao aparecer (educado no neutro, urgente no erro), porque o Flutter não aceita região anunciada no mesmo nó de um papel e o motor web não lê `liveRegion` em título; a 404 não anuncia, porque a leitura da página já começa pelo `h1`. No objeto, "Carregando…" fica só na ficha-esqueleto e vale pelo grupo: o cabeçalho tem trilha e voltar reais, que continuam legíveis, e os blocos do título já ficam fora da leitura.
