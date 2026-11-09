# 013. Painel: estrutura, menu e consulta de temas e subtemas

- **Status:** implementada
- **Item do planejamento:** Fase 4, entrega 4.2 (tela T-09, moldura e "Temas e subtemas")
- **Protótipo:** aba "Painel" (link em docs/specs/README.md); referência no Observatório: o painel de `lib/app/features/admin/panel/` e o menu de `lib/app/features/admin/sidebar/` (o Observatório não guarda specs no repositório)
- **Criada em:** 2026-10-27

> A tela T-09 foi dividida em duas specs: **013** moldura do painel e consulta de temas e subtemas (esta) e **014** lista de objetos com filtros e ações. O editor em página própria é a **015**.

## Objetivo
Dar ao painel a moldura do Observatório (barra superior, menu lateral com contagens, gaveta no celular) para que a curadoria navegue entre os objetos de cada tema e consulte a estrutura de temas e subtemas.

## Situação atual
- `lib/features/admin/panel/presentation/pages/panel_page.dart`, em `/admin/painel` (subrota de `/admin`, que continua montada por baixo, spec 012): barra preta com "PAINEL ADMINISTRATIVO" e um ícone de sair sem nome nem dica; cartão "Selecione um Tema e Subtema" (`theme_subtheme_selector.dart`); botão "Novo Conteúdo" (só com subtema escolhido); tabela `content_list.dart` com ícones de editar e excluir sem nome nem dica; diálogos `content_form_dialog.dart` e "Confirmar Exclusão". Usa `num_extension`, `PrimaryButton`/`SecondaryButton`, `CircularLoading`, `ContentError`/`ContentEmpty` e avisos de erro em faixa vermelha (`Messenger`).
- O roteador decide `/admin` e `/admin/painel` esperando a sessão recuperada (`AppRouter.adminRedirect`, spec 012); nenhum outro endereço do painel existe.
- Não há menu lateral, contagens nem tela de temas e subtemas.
- As contagens do site vêm do catálogo único (`lib/features/catalog/`, spec 004, Q-04), carregado uma vez por visita; ainda não há como recarregá-lo.
- Login por Firebase Auth, sem perfis nem nomes de usuário.

## Comportamento

### Barra superior
- Marca (símbolo + "expo**GEO**" + "Painel"), que leva a "Objetos digitais".
- À direita: **"Ver site ↗"** (abre a Home em aba nova) e a pessoa logada: círculo com as iniciais do e-mail e o e-mail. Não há papel a mostrar (o painel não tem perfis).
- Iniciais: até duas letras maiúsculas do que vem antes do `@`; se houver separador (`.`, `_` ou `-`), a primeira letra de cada uma das duas primeiras partes (`ana.souza@…` → "AS"); sem separador, as duas primeiras letras (`curadoria@…` → "CU").

### Menu lateral
Grupo **"Curadoria"**:
- **Objetos digitais** com o total, e um submenu com os 4 temas, cada um com sua contagem. Escolher um tema abre "Objetos digitais" filtrado por ele.
- **Temas e subtemas** com o total de subtemas (31, os do site).
- **Sair** no pé do menu.
- Item atual em fundo acento suave; com um tema escolhido, "Objetos digitais" fica destacado como pai e o tema como atual.

### Objetos digitais (nesta entrega)
- Cabeçalho com o rótulo "Curadoria" e o título "Objetos digitais" (ou o nome do tema escolhido).
- Abaixo, a **área de objetos de hoje**, sem mudar o que ela faz: seletor de tema e subtema, "Novo Conteúdo", tabela, formulário e exclusão. O tema e o subtema do endereço chegam já escolhidos no seletor e carregam a tabela deles; escolher no seletor não muda o endereço. A lista nova, com filtros, busca e ações, é a spec 014.
- Os ícones de editar e excluir da tabela ganham nome e dica ("Editar a ficha deste objeto"; "Excluir: pede confirmação antes de apagar"), e a exclusão passa a usar o diálogo de confirmação compartilhado, com os textos de hoje ("Confirmar Exclusão", "Tem certeza que deseja deletar o conteúdo "…"?", "Cancelar", "Deletar"). Textos novos, aviso "Objeto excluído" e linha que some ficam para a 014.

### Temas e subtemas (só consulta)
- Cabeçalho: rótulo "Curadoria", título "Temas e subtemas" e "Só para consulta. Os temas e subtemas não são criados nem apagados pelo painel."
- Um bloco por tema, na ordem do site: nome, "N subtemas · N objetos" e a lista de subtemas em linhas: medalhão, nome, caminho (`/natureza-meio-ambiente/biomas`), selo "N objetos" ("1 objeto" no singular) e o botão de ícone **"Ver objetos"** (dica "Ver os objetos deste subtema"), que abre "Objetos digitais" com o tema e o subtema já escolhidos.

### Endereços
- `/admin/painel` (destino do login, como hoje) leva a `/admin/painel/objetos`.
- Endereços por vista, para recarregar sem perder o lugar: `/admin/painel/objetos`, `/admin/painel/objetos?tema=natureza-meio-ambiente`, `/admin/painel/objetos?tema=natureza-meio-ambiente&subtema=biomas` e `/admin/painel/temas`. Os valores são os mesmos dos endereços do site.
- Tema desconhecido é ignorado (mostra todos); subtema desconhecido ou de outro tema é ignorado (fica só o tema).
- Sem sessão, todos voltam ao login. Outro endereço dentro de `/admin/painel/` com sessão mostra a página "não encontrada" do site.

### Celular e tablet
- Até 900 px (a mesma largura em que a navbar do site recolhe), o menu lateral some e vira **gaveta** aberta pelo botão "Abrir menu do painel" na barra; fecha ao escolher um item, ao tocar fora ou com Esc. Fechada sem escolha, o foco volta ao botão.
- No celular (abaixo de 600 px, a faixa do projeto; o protótipo usa 640), "Ver site" sai da barra e passa para o pé da gaveta, acima de "Sair", e a marca fica só com o símbolo.

### Avisos e confirmações (peças compartilhadas da fase)
- **Aviso curto** (toast) no rodapé da tela, em fundo escuro com ícone, também anunciado a leitores de tela. Substitui a faixa vermelha atual nos avisos da área de objetos e aparece quando "Sair" falha ("Não deu para sair. Tente de novo.").
- **Dica** em todo botão só de ícone do painel, ao passar o mouse e ao receber foco pelo teclado, dizendo o que acontece. Esc fecha a dica sem fechar a gaveta ou o diálogo por baixo.
- **Diálogo de confirmação**: título, texto, "Cancelar" (secundário, foco inicial) e a ação (vermelha quando apaga). Esc ou clique fora fecha e devolve o foco ao botão que abriu. Lido como alerta.

## Estados
- **Carregando:** contagens do menu com esqueleto curto no lugar do número; "Temas e subtemas" com nomes e caminhos (vêm do código) e esqueleto no lugar de cada "N objetos".
- **Erro nas contagens:** o menu mostra os itens sem números; "Temas e subtemas" mostra nomes e caminhos, sem "N objetos", e o aviso "Não conseguimos carregar as contagens." com "Tentar de novo".
- **Vazio:** não se aplica à moldura (os temas e subtemas vêm do código); subtema sem objetos mostra "0 objetos". A área de objetos mantém os estados de hoje até a 014.
- **Sem imagem / imagem com falha:** placeholder do medalhão.
- **Casos de borda:** e-mail longo na barra é cortado com reticências e aparece inteiro na dica e no nome acessível; tema com 12 subtemas (Natureza e Meio Ambiente) sem quebra de layout; nome de subtema longo quebra em até 2 linhas.

## Responsivo
- **390:** barra com botão de menu, símbolo da marca (sem o nome) e iniciais; gaveta com "Ver site" e "Sair" no pé; linhas de subtema compactas (medalhão e nome em cima, caminho, selo e "Ver objetos" abaixo).
- **768:** barra com botão de menu, marca completa, "Ver site" e iniciais (sem o e-mail, como no protótipo); gaveta; linhas como no desktop.
- **1280:** menu lateral fixo de 248 px e conteúdo ao lado; barra com marca, "Ver site", iniciais e e-mail.

## Acessibilidade
- Menu lateral (e gaveta) como navegação "Seções do painel", com o item atual marcado; contagens lidas junto do nome ("Objetos digitais, 190").
- Botão da gaveta com nome "Abrir menu do painel" e estado aberto/fechado; foco preso na gaveta enquanto aberta.
- Todo botão só de ícone tem nome e dica; "Ver objetos" tem nome com o subtema ("Ver objetos de Biomas").
- Títulos de vista e de bloco de tema marcados como títulos.
- Iniciais com nome acessível "Conectado como {e-mail}".
- Foco visível em tudo; contraste ≥ 4,5:1, inclusive contagens, caminhos e item atual em fundo acento suave.
- A faixa "Ambiente de testes" é a global da spec 001, fora da produção; o painel não cria outra.

## Dados e regras de negócio
- Temas e subtemas vêm do código (`ThemeDataModel`, 31 subtemas; Movimentos da Terra fica de fora, como no site); o painel **não** cria, edita nem apaga temas e subtemas.
- Contagens do catálogo único da spec 004 (Q-04): recarregado ao abrir o painel (para não mostrar números de antes do login) e de novo depois de criar, editar ou excluir pela área de objetos. As contagens são as mesmas do site.
- A regra de acesso continua: sem sessão, volta ao login. `/admin` e `/admin/painel` continuam existindo.
- Nenhuma mudança em modelos, dados, coleções ou regras do Firestore.

## Critérios de aceite
- [ ] Depois do login, `/admin/painel` leva a `/admin/painel/objetos`, com barra, menu lateral (1280) e "Objetos digitais" com a área de objetos de hoje dentro da moldura.
- [ ] O menu mostra o total de objetos, os 4 temas com contagem e o total de 31 subtemas, iguais aos números do site; esqueleto enquanto carrega e itens sem números se a carga falhar.
- [ ] "Temas e subtemas" lista os 4 temas ("N subtemas · N objetos") e seus subtemas com medalhão, caminho e "N objetos"; "Ver objetos" abre "Objetos digitais" com tema e subtema escolhidos; com erro, aparece "Tentar de novo", que recarrega as contagens.
- [ ] Escolher um tema no menu muda o endereço para `?tema=…` e a área de objetos mostra esse tema; recarregar cada endereço da seção "Endereços" mantém a vista e o destaque do menu; valores desconhecidos são ignorados; sem sessão, todos voltam ao login.
- [ ] "Ver site" abre a Home em aba nova; "Sair" encerra a sessão e volta ao login; falha ao sair mostra o aviso curto.
- [ ] Depois de criar, editar ou excluir pela área de objetos, as contagens do menu se atualizam sem recarregar a página.
- [ ] Até 900 px o menu vira gaveta, que abre pelo botão (nome e estado lidos) e fecha ao escolher, ao tocar fora e com Esc, com o foco no lugar certo.
- [ ] Todo botão só de ícone do painel tem nome e dica no hover e no foco; o aviso curto aparece em fundo escuro e é anunciado; o diálogo de confirmação abre com foco em "Cancelar", fecha com Esc e devolve o foco.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow` (também com e-mail longo); contraste ≥ 4,5:1; navegação completa por teclado, com foco visível.
- [ ] O código novo e o alterado usam os tokens do tema, sem `num_extension`, cor ou tamanho solto; a área de objetos continua listando, criando, editando e excluindo como antes; login e telas públicas não mudam.

## Fora do escopo
- Lista de objetos em linhas, busca, filtros de subtema e tipo, "+ Novo objeto", textos novos da exclusão e "Mostrar mais" (spec 014). Na 013, a área de objetos é a de hoje.
- Editor em página própria e os endereços `/admin/painel/objetos/novo` e `/:codigo/editar` (spec 015).
- Correção da chave de preservação no modelo do conteúdo (014/015).
- Remover os componentes antigos que a área de objetos ainda usa (`PrimaryButton`, `SecondaryButton`, `CircularLoading`, `ContentError`, `ContentEmpty`): saem com a 014 ou na limpeza (016).
- Perfis de usuário, gestão de usuários.

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único da spec 004.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida.
- 2026-10-27: aprovada.
- 2026-11-08: revisada contra o código das Fases 0–3 e da 012 e a aba "Painel" do protótipo, antes do plano (modo autônomo, sem mudar o status). Mudanças: caminho completo da página e situação atual detalhada (subrota de `/admin`, `adminRedirect`, catálogo sem recarga, componentes antigos); referência do Observatório trocada pelo código, já que lá não há `docs/specs/030`; regra das iniciais; vista "Objetos digitais" definida para esta entrega (moldura em volta da área de hoje); "Ver objetos" leva tema **e** subtema, como no protótipo, com o endereço `?tema=…&subtema=…`; `/admin/painel` leva a `/admin/painel/objetos`; valores desconhecidos e subrotas inexistentes; 768 só com as iniciais e, no celular, "Ver site" na gaveta e marca só com o símbolo (protótipo); estados de carregando e de erro com "Tentar de novo"; usos do aviso curto, da dica e do diálogo nesta entrega; faixa de ambiente é a global da 001; critérios reescritos (10) e fora do escopo com o que fica para 014, 015 e 016.
- 2026-11-08 (decisões sem a pessoa): (1) "Objetos digitais" mostra a área de objetos de hoje dentro da moldura até a 014, para criar, editar e excluir continuarem funcionando entre as entregas; (2) a gaveta segue os 900 px do protótipo e da navbar do site (`navbarCollapseWidth`), não os 1024 do Observatório; (3) "Ver site" vai para a gaveta no celular em vez de sumir, para não perder o caminho de volta; (4) a exclusão antiga já usa o diálogo compartilhado, mas mantém os textos de hoje (textos novos são da 014); (5) o catálogo é recarregado ao abrir o painel e depois de cada gravação, em vez de só uma vez por visita; (6) falha nas contagens ganha "Tentar de novo", que o protótipo não mostra; (7) o corte de 640 px do protótipo (barra compacta) vira a faixa de celular do projeto (< 600 px), pela regra de tamanhos por faixa do `docs/specs/README.md`.
- 2026-11-08 (implementação, decisões sem a pessoa): (1) "Sair" tocado na gaveta fecha a gaveta antes, porque ela fica por cima do aviso curto e esconderia "Não deu para sair. Tente de novo."; (2) os nomes dos temas no submenu quebram em até 2 linhas, porque na largura de 248 px não cabem numa linha e o corte escondia o nome; (3) com a gaveta aberta, a barra fica fora do alcance do leitor de tela (a gaveta é modal, com o foco preso nela), então o estado "aberto" do botão só é visível pela dica e pelo ícone de fechar; fechada, o botão é lido como "Abrir menu do painel", recolhido; (4) a vista atual é um contêiner de acessibilidade próprio, porque a página interna da moldura tirava a barra e o menu da árvore lida pelo leitor de tela.
