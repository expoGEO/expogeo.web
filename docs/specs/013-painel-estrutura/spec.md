# 013. Painel: estrutura, menu e consulta de temas e subtemas

- **Status:** aprovada
- **Item do planejamento:** Fase 4, entrega 4.2 (tela T-09, moldura e "Temas e subtemas")
- **Protótipo:** aba "Painel" (link em docs/specs/README.md); referência no Observatório: `docs/specs/030-painel-estrutura/`
- **Criada em:** 2026-10-27

> A tela T-09 foi dividida em duas specs: **013** moldura do painel e consulta de temas e subtemas (esta) e **014** lista de objetos com filtros e ações.

## Objetivo
Dar ao painel a moldura do Observatório (barra superior, menu lateral com contagens, gaveta no celular) para que a curadoria navegue entre os objetos de cada tema e consulte a estrutura de temas e subtemas.

## Situação atual
- `features/admin/panel/presentation/pages/panel_page.dart`: barra com "PAINEL ADMINISTRATIVO" e botão de sair; seletor de tema e subtema (`theme_subtheme_selector.dart`) que carrega a tabela do tema ou do subtema escolhido.
- Não há menu lateral, contagens nem tela de temas e subtemas.
- Login por Firebase Auth, sem perfis nem nomes de usuário.

## Comportamento

### Barra superior
- Marca (símbolo + "expo**GEO**" + "Painel"), que leva ao início do painel.
- À direita: "Ver site ↗" (abre a Home em aba nova) e a pessoa logada: círculo com as iniciais do e-mail e o e-mail. Não há papel a mostrar (o painel não tem perfis).

### Menu lateral
Grupo **"Curadoria"**:
- **Objetos digitais** com o total, e um submenu com os 4 temas, cada um com sua contagem. Escolher um tema abre a lista filtrada por ele (spec 014).
- **Temas e subtemas** com o total de subtemas.
- **Sair** no pé do menu.
- Item atual em fundo acento suave; com um tema escolhido, "Objetos digitais" fica destacado como pai.

### Temas e subtemas (só consulta)
- Cabeçalho: rótulo "Curadoria", título "Temas e subtemas" e "Só para consulta. Os temas e subtemas não são criados nem apagados pelo painel."
- Um bloco por tema: nome, "N subtemas · N objetos" e a lista de subtemas em linhas: medalhão, nome, caminho (`/natureza-meio-ambiente/biomas`), "N objetos" e o botão de ícone "Ver objetos" (abre a lista filtrada por tema e subtema).

### Endereços
- `/admin/painel` abre "Objetos digitais".
- Endereços novos para cada vista, para recarregar sem perder o lugar: `/admin/painel/objetos`, `/admin/painel/objetos?tema=natureza-meio-ambiente` e `/admin/painel/temas`. Sem sessão, todos voltam ao login.

### Celular
- Até 900 px, o menu lateral some e vira **gaveta** aberta pelo botão "Abrir menu do painel" na barra; fecha ao escolher um item, ao tocar fora ou com Esc.

### Avisos e confirmações (peças compartilhadas da fase)
- **Aviso curto** (toast) no rodapé da tela depois de cada ação, também anunciado a leitores de tela.
- **Dica** em todo botão só de ícone, ao passar o mouse e ao receber foco, dizendo o que acontece.
- **Diálogo de confirmação** com foco em "Cancelar", Esc fecha e devolve o foco ao botão que abriu.

## Estados
- **Carregando:** contagens do menu com esqueleto curto; "Temas e subtemas" com esqueleto de linhas.
- **Erro nas contagens:** o menu mostra os itens sem números; a lista de temas e subtemas mostra os nomes e caminhos, sem "N objetos".
- **Sem imagem:** placeholder do medalhão.
- **Casos de borda:** e-mail longo na barra é cortado com reticências e aparece inteiro na dica; tema com 12 subtemas sem quebra de layout.

## Responsivo
- **390:** barra com botão de menu, marca e iniciais (sem e-mail); gaveta; linhas de subtema viram cartões compactos.
- **768:** como o celular, com o e-mail visível.
- **1280:** menu lateral fixo de ~248 px e conteúdo ao lado.

## Acessibilidade
- Menu lateral como navegação "Seções do painel", com o item atual marcado.
- Botão da gaveta anuncia aberto/fechado; foco preso na gaveta enquanto aberta.
- Todo botão só de ícone tem nome e dica.
- Faixa "Ambiente de testes" no dev.

## Dados e regras de negócio
- Temas e subtemas vêm do código (`ThemeDataModel`); o painel **não** cria, edita nem apaga temas e subtemas.
- Contagens do catálogo único da spec 004 (Q-04), recarregado ao entrar no painel e atualizado depois de criar, editar ou excluir.
- A regra de acesso continua: sem sessão, volta ao login.
- Nenhuma mudança em dados, coleções ou regras do Firestore.

## Critérios de aceite
- [ ] Depois do login, `/admin/painel` mostra barra, menu lateral e "Objetos digitais".
- [ ] O menu mostra total de objetos, os 4 temas com contagem e o total de subtemas, iguais aos do site.
- [ ] "Temas e subtemas" lista os 4 temas e seus subtemas com caminho e contagem; "Ver objetos" abre a lista filtrada.
- [ ] Recarregar cada endereço novo mantém a vista; sem sessão, todos voltam ao login.
- [ ] "Ver site" abre a Home em aba nova; "Sair" encerra a sessão e volta ao login.
- [ ] Até 900 px o menu vira gaveta, que fecha ao escolher, ao tocar fora e com Esc.
- [ ] Todo botão só de ícone tem dica no hover e no foco.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1; navegação completa por teclado.

## Fora do escopo
- Lista de objetos, filtros e exclusão (spec 014).
- Editor (spec 015).
- Perfis de usuário, gestão de usuários.

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único da spec 004.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida.
- 2026-10-27: aprovada.
