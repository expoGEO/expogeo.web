# 015. Editor de objeto em página própria

- **Status:** implementada
- **Item do planejamento:** Fase 4, entrega 4.4 (tela T-10, rotas novas)
- **Protótipo:** aba "Editor" (link em docs/specs/README.md); referência no Observatório: o editor de publicações em `lib/app/features/admin/panel/presentation/pages/post_editor_page.dart` e `components/editor/` (`post_editor_bar.dart`, `post_editor_card.dart`, `post_editor_layout.dart`, `post_editor_missing_alert.dart`, `post_editor_side.dart`, `post_editor_skeleton.dart`) e o aviso de saída em `lib/app/core/utils/browser/leave_guard*.dart`. O Observatório não guarda specs no repositório.
- **Criada em:** 2026-10-27

## Objetivo
Cadastrar e editar a ficha de um objeto numa página com espaço, campos agrupados como aparecem no site, prévia do cartão e um resumo do que falta, no lugar do diálogo apertado de hoje. Os campos continuam os mesmos, e o que é gravado fica igual ao dos objetos que já existem.

## Situação atual
- A lista "Objetos digitais" da 014 (`panel_objects_view.dart`, dentro da moldura da 013 em `panel_shell.dart`) abre o diálogo antigo `content_form_dialog.dart`: "Novo objeto" só com subtema escolhido nos filtros (senão, aviso "Escolha o tema e o subtema nos filtros…" e foco no filtro); "Editar" e o título abrem a edição com o tema e o subtema do objeto. Depois de salvar, a lista mostra "Objeto cadastrado", "Alterações salvas" ou "Não deu para salvar. Confira a conexão e tente de novo." (resultado publicado pela `ContentStore`), e a moldura recarrega o catálogo.
- O diálogo tem "ID do Conteúdo*" digitado (ex.: `RE_CG_01`), Título*, Descrição*, Assuntos*, Nota do Conteúdo, Criador*, Colaborador, Tipo* e Formato* (começam em Site e HTML), URL/Localização* (sem conferir o formato), Idioma*, Requisitos, Ano de Emissão, Regras de Registro, Direitos*, Operação de Preservação* e Data de Atualização (só leitura; "agora" ao criar). Usa `num_extension` e os botões antigos.
- **O que os 190 objetos do dev guardam** (consulta só de leitura em 2026-11-09): documento com o próprio código como id (`themes/NMA/subthemes/NMA_BH/contents/NMA_BH_03`); `id` = código; `themeId` e `subthemeId` com as siglas (`NMA`, `NMA_BH`); `themeTitle` e `subthemeTitle` com os nomes; tipo e formato pelo nome (`site`, `outro`); datas só com o dia (`insertionDate` `2024-12-05`, `preservationAction.updateDate` `2026-12-01`); `requirements` e `registrationRules` preenchidos em todos.
- **O que o diálogo grava hoje é diferente:** id automático do Firestore, `themeId`/`subthemeId` com os valores dos endereços (`natureza-meio-ambiente`), sem `themeTitle`/`subthemeTitle`, tipo e formato pelo rótulo (`Site`, `HTML`) e datas com hora (`2026-11-09T14:22:33.123`). A 014 passou a **ler** os dois jeitos; a gravação pelo nome ficou para esta spec.
- Prefixos dos códigos no dev: cada subtema usa um só, igual ao `SubthemeEnum.id`, menos Poluição da Água (`NMA_PAG`, e não `NMA_PA`). Maior número por subtema: Bacias Hidrográficas `_05`, Poluição da Água `_06`.

## Comportamento

### Endereços
- `/admin/painel/objetos/novo`, que aceita `?tema=…&subtema=…` (os valores dos endereços do site, como na lista) para vir preenchido; valores desconhecidos são ignorados.
- `/admin/painel/objetos/:codigo/editar`, com o código em minúsculas e hífen, como no site (Q-01): `/admin/painel/objetos/nma-bh-03/editar`. O código original (`NMA_BH_03`) também abre e o endereço passa para a forma com hífen.
- Sem sessão, os dois voltam ao login, como o resto do painel.
- O editor ocupa a página inteira, sem o menu lateral do painel, como no protótipo.

### Da lista para o editor
- **"Novo objeto"** sempre abre `/admin/painel/objetos/novo`, levando o tema e o subtema dos filtros quando houver. O aviso "Escolha o tema e o subtema nos filtros…" da 014 sai.
- **"Editar"** e o título de uma linha abrem `/admin/painel/objetos/{código}/editar`.
- **"← Objetos digitais"**, "Cancelar" e o fim de um salvamento voltam à lista como ela estava (filtros e busca). Quando o editor foi aberto direto pelo endereço, voltam à lista sem filtros.

### Barra do editor
- "← Objetos digitais", título "Novo objeto" ou "Editar objeto" com o código em pílula (Figtree 600 com algarismos tabulares, como na lista) e os botões "Cancelar" (secundário) e **"Salvar"** (primário).
- No novo objeto sem tema e subtema escolhidos, a pílula não aparece.
- A barra fica fixa no topo ao rolar, em todas as larguras.
- Sair com alterações não salvas ("← Objetos digitais", "Cancelar", voltar do navegador) pede confirmação: "Sair sem salvar?" — "As alterações feitas aqui serão perdidas." — "Continuar editando" (foco inicial) / "Sair sem salvar". Fechar ou recarregar a aba usa o aviso do próprio navegador. Sem alterações, sai direto.

### Coluna principal (cartões)
1. **Conteúdo:** Título (em fonte maior, como no protótipo); Descrição (dica "Uma ou duas frases. Aparece no cartão do objeto."); Assuntos (dica "Separe por vírgula. Viram filtros na página do subtema."); Nota de conteúdo *opcional*.
2. **Autoria:** Criador; Colaborador *opcional*.
3. **Origem e registro:** Endereço do recurso (dica "https://"); Tipo e Formato (listas que começam em "Escolha"); Idioma (começa com "Português" no novo); Ano de emissão *opcional* (só algarismos); Requisitos *opcional* (dica "Ex.: acesso à internet"; começa com "Acesso à internet" no novo); Regras de registro *opcional* (campo que existe hoje e aparece na ficha; o protótipo não mostra, mas fica, Q-05).
4. **Direitos e preservação:** Direitos; Ação de preservação (começa com "Atualização do link ao longo do tempo" no novo); Próxima revisão do link *opcional*, com duas listas, "Mês" e "Ano" (começam vazias no novo).
- Campos opcionais com "opcional" ao lado do rótulo; os demais são obrigatórios (os mesmos de hoje, mais tema e subtema). As dicas ficam como texto visível abaixo ou dentro do campo.
- Tipo e Formato mostram os rótulos de hoje: Site, Vídeo, Imagem, Documento, Aplicativo, Outro; Texto, HTML, PDF, Vídeo, Imagem, Áudio, Outro.

### Coluna lateral
- **Onde aparece:** Tema e Subtema (listas com os 4 temas e os subtemas do site, 31 no total; trocar o tema limpa o subtema) e o **Código de referência**, com a dica "Gerado a partir do tema e do subtema." O código não é digitado. Sem tema e subtema, mostra "Escolha o tema e o subtema".
- **Prévia do cartão:** o cartão de objeto do site (spec 005), sem ação ao clicar, atualizado enquanto se digita, com textos de exemplo nos campos vazios ("Título do objeto", "A descrição aparece aqui.", "Criador") e o tipo Site enquanto o tipo não é escolhido. Sem subtema, usa o medalhão vazio.

### Regra do código (Q-05)
- **Prefixo:** o que os objetos já cadastrados no subtema usam (Poluição da Água usa `NMA_PAG`). Em subtema sem objetos, o da lista de subtemas (`SubthemeEnum.id`).
- **Número:** o maior número já usado no subtema + 1, com 2 dígitos (`_06`; `_10` depois de `_09`). Números de objetos excluídos não são reaproveitados enquanto houver um maior.
- **Novo objeto:** o código aparece assim que tema e subtema estão escolhidos. Na hora de salvar, os objetos do subtema são lidos de novo no Firestore e o código é recalculado; o documento só é criado se ainda não houver outro com o mesmo código (senão, tenta o número seguinte). Assim, dois cadastros seguidos, mesmo em abas diferentes, não repetem o número.
- **Editar sem trocar de subtema:** o código não muda. Voltar ao subtema original depois de trocar mostra de novo o código original.

### Salvar
- Confere os obrigatórios, o endereço (precisa começar com `http://` ou `https://`), o ano de emissão (4 algarismos, quando preenchido) e a próxima revisão (mês e ano juntos, ou nenhum).
- Faltando algo: aviso no topo da coluna principal "Falta preencher para salvar:" com a lista, na ordem da tela: o tema, o subtema, o título, a descrição, os assuntos, o criador, o endereço do recurso — com "(comece com https://)" quando o problema for o formato —, o tipo, o formato, o idioma, o ano de emissão (use 4 algarismos), os direitos, a ação de preservação, a próxima revisão do link (escolha o mês e o ano). Cada item é link que leva o foco ao campo; os campos com problema ficam com borda de erro. A tela rola até o aviso, e a lista se atualiza a cada nova tentativa.
- Tudo certo: grava, volta à lista e mostra "Objeto cadastrado" ou "Alterações salvas". Se o código do novo objeto mudou na conferência da hora de salvar, o aviso é "Objeto cadastrado com o código {código}". Na troca de subtema, se o código mudou depois da confirmação, o aviso é "Alterações salvas. O objeto recebeu o código {código}". A lista e as contagens do menu já vêm com o objeto.
- Textos gravados sem espaços nas pontas; opcionais vazios não são gravados (como hoje). Assuntos como lista, sem itens vazios e sem repetidos (a primeira ocorrência fica).
- Ao criar: data de inserção = hoje. Ao editar: mantém a data de inserção.
- **Trocar o tema ou o subtema de um objeto existente** move o documento para o novo subtema (cria no novo e apaga do antigo, numa operação só) e gera o código novo. Antes de salvar, confirmação: "Mudar de subtema?" — "O objeto vai para {subtema novo} e recebe o código {código novo}. O endereço antigo deixa de funcionar." — "Cancelar" (foco inicial) / "Mudar e salvar".
- Falha ao gravar: aviso "Não deu para salvar. Confira a conexão e tente de novo.", o editor continua aberto e os campos continuam preenchidos.

## Estados
- **Carregando:** enquanto o catálogo não chega, esqueleto dos cartões e da lateral, com a barra já visível (no novo, o código depende do catálogo).
- **Erro ao carregar:** caixa de erro "Não conseguimos carregar o editor" com "Tentar de novo" (recarrega o catálogo) e "Voltar aos objetos".
- **Objeto não encontrado (editar):** caixa "Não encontramos este objeto" — "Ele pode ter sido excluído ou o endereço está incompleto." — com "Voltar aos objetos".
- **Salvando:** "Salvar" desativado com "Salvando…" e "Cancelar" desativado.
- **Casos de borda:** dois cadastros seguidos no mesmo subtema recebem números diferentes; subtema sem objetos começa em `_01` com o prefixo da lista; letras no ano de emissão não entram no campo; assunto repetido grava uma vez; descrição muito longa é aceita, mas a prévia mostra só 2 linhas; título longo quebra na barra sem empurrar os botões; objeto gravado pelo diálogo antigo (tipo pelo rótulo, sem preservação) abre com os campos certos.

## Responsivo
- **390:** uma coluna; "Onde aparece" vai para o topo, antes de "Conteúdo", e a "Prévia do cartão" vai para o fim, depois de "Direitos e preservação"; campos lado a lado (Criador e Colaborador, Tipo e Formato etc.) ficam um embaixo do outro; botões da barra em largura total abaixo do título.
- **768:** uma coluna, na ordem do celular; campos lado a lado em 2 colunas; botões da barra à direita.
- **1280:** duas colunas (campos com o espaço que sobra, lateral com 340 px), largura máxima de 1180 px centralizada, barra fixa no topo.

## Acessibilidade
- Cada cartão é um grupo com título; rótulos visíveis ligados aos campos; "opcional" faz parte do nome do campo.
- Aviso de pendências anunciado como alerta e com o foco levado a ele; cada link leva o foco ao campo.
- Diálogos de saída e de troca de subtema com foco inicial na opção segura e Esc para cancelar.
- Código de referência lido com o rótulo ("Código de referência: NMA_BH_06").
- Prévia lida como "Prévia do cartão", sem virar um link a mais no Tab.
- Faixa "Ambiente de testes" no dev (já vem da moldura do app).
- Foco visível em tudo; contraste ≥ 4,5:1 em dicas, "opcional", código e textos da lateral.

## Dados e regras de negócio
- **Mesmos campos** de hoje e **o mesmo formato dos objetos já gravados** (os 190 do dev), sem campo novo:
  - documento com o código como id, em `themes/{sigla do tema}/subthemes/{sigla do subtema}/contents/{código}`;
  - `id` = código; `themeId` e `subthemeId` com as siglas (`NMA`, `NMA_BH`); `themeTitle` e `subthemeTitle` com os nomes do tema e do subtema como aparecem no site;
  - `intellectualIndicator`, `contentInfo`, `originInfo`, `registrationInfo`, `rightsInfo` e `preservationAction` com as mesmas chaves de hoje;
  - tipo e formato pelo nome (`site`, `video`, `html`, `outro`…), como os 190 objetos; a leitura dos dois jeitos (014) continua;
  - `insertionDate` e `updateDate` só com o dia (`2026-11-09`; a próxima revisão grava o dia 1 do mês, `2026-12-01`).
- Editar sem trocar de subtema atualiza o mesmo documento e não mexe em chaves que o editor não conhece. Objetos antigos com id automático continuam editáveis no mesmo documento.
- Sem situação de publicação: salvar já publica no site.
- Temas e subtemas só para escolha; não são criados aqui. Movimentos da Terra fica de fora, como no site.
- Coleções e regras do Firestore não mudam. Rotas existentes não mudam; entram só as duas do editor.

## Critérios de aceite
- [ ] **CA1.** "Novo objeto" (com os filtros de tema e subtema, quando houver) e "Editar"/título de uma linha abrem o editor em página própria nos endereços novos; recarregar mantém a tela; `NMA_BH_03/editar` passa para `nma-bh-03/editar`; sem sessão, volta ao login.
- [ ] **CA2.** O editor mostra a barra e os quatro cartões com os campos de hoje, os opcionais marcados, as dicas e os valores iniciais do novo (Português, Acesso à internet, Atualização do link ao longo do tempo; Tipo e Formato em "Escolha").
- [ ] **CA3.** Tema, subtema e código aparecem na lateral; trocar o tema limpa o subtema e o código; o código acompanha o subtema escolhido.
- [ ] **CA4.** Novo objeto em Bacias Hidrográficas mostra `NMA_BH_06` e em Poluição da Água `NMA_PAG_07` (dados do dev); em subtema sem objetos, `{sigla}_01`.
- [ ] **CA5.** Editar um objeto abre os campos como gravados (inclusive preservação, próxima revisão e "Regras de registro") e, sem trocar de subtema, mantém o código.
- [ ] **CA6.** A prévia acompanha a digitação, com textos de exemplo nos campos vazios e descrição em até 2 linhas.
- [ ] **CA7.** Salvar com campos vazios ou inválidos lista as pendências na ordem da tela; cada link leva o foco ao campo; endereço sem `http(s)://` aparece com "(comece com https://)"; ano com menos de 4 algarismos e revisão só com mês aparecem na lista.
- [ ] **CA8.** Criar grava um documento com o mesmo formato dos objetos do dev (id = código, siglas, nomes, tipo e formato pelo nome, datas só com o dia, data de inserção de hoje), volta à lista com "Objeto cadastrado" e o objeto aparece na lista, nas contagens e no site. Conferido com gravação simulada (sem credenciais) comparando o documento montado com um dos 190.
- [ ] **CA9.** Na hora de salvar, o código é recalculado com os objetos do subtema lidos de novo, e um código já usado não é sobrescrito (vai para o número seguinte, com o aviso "Objeto cadastrado com o código …").
- [ ] **CA10.** Editar atualiza o mesmo documento, mantém a data de inserção e as chaves que o editor não conhece, grava tipo e formato pelo nome e volta com "Alterações salvas".
- [ ] **CA11.** Mudar o subtema de um objeto existente pede confirmação com o código novo e, confirmado, cria o documento no subtema novo e apaga o antigo numa operação só.
- [ ] **CA12.** Sair com alterações (barra, "Cancelar", voltar do navegador) pede confirmação com foco em "Continuar editando"; fechar ou recarregar a aba mostra o aviso do navegador; sem alterações, sai direto e volta à lista com os filtros de antes.
- [ ] **CA13.** Erro de gravação mostra o aviso e mantém o editor com o que foi digitado; "Salvar" mostra "Salvando…" e fica desativado durante a gravação.
- [ ] **CA14.** Esqueleto ao carregar, erro ao carregar com "Tentar de novo" e "Objeto não encontrado" aparecem nos casos certos.
- [ ] **CA15.** Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow` (também com título longo); ordem dos cartões e barra como em "Responsivo"; contraste ≥ 4,5:1; formulário, aviso de pendências, listas e diálogos completos por teclado, com foco visível e nomes acessíveis.
- [ ] **CA16.** O código novo usa os tokens do tema, sem `num_extension`, cor ou tamanho solto; o diálogo antigo (`content_form_dialog.dart`) sai; lista, "Temas e subtemas", login e telas públicas continuam como estavam.

## Fora do escopo
- Rascunho, agendamento ou histórico de versões.
- Enviar imagem própria do objeto (os objetos não têm imagem).
- Criar ou editar temas e subtemas.
- Corrigir objetos já gravados pelo diálogo antigo (rótulo, id automático, siglas como endereço): continuam como estão; ao editá-los, o editor grava os campos no formato novo, no mesmo documento.
- Remover os campos e botões antigos que ficarem sem uso (`AppTextField`, `AppDropdownField`, `Validators`, `PrimaryButton`, `SecondaryButton`): limpeza da 016.
- Mudanças em coleções ou regras do Firestore.

## Perguntas em aberto
- Nenhuma. (Respondidas: Q-01, código com hífen no endereço; Q-05, código gerado pela regra acima e "Regras de registro" mantido como opcional.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-01 e Q-05 respondidas; entra a seção "Regra do código".
- 2026-10-27: aprovada.
- 2026-11-09: revisada contra o código das Fases 0–3 e das 012–014 (verificadas), contra a aba "Editor" do protótipo e contra os 190 objetos do dev (consulta só de leitura), antes do plano (modo autônomo, sem mudar o status). Mudanças: referência do Observatório trocada pelos arquivos do editor de publicações (não há `docs/specs/033` lá); situação atual reescrita a partir da lista da 014 e do formato real dos dados; seção nova "Da lista para o editor" ("Novo objeto" sempre abre o editor, sem o aviso da 014; volta à lista com os filtros); editor fora da moldura do painel, como no protótipo; código original no endereço redireciona para a forma com hífen; pílula do código e regras do diálogo de saída (foco, aviso do navegador ao fechar a aba); tema e subtema entram nas pendências e o código mostra "Escolha o tema e o subtema"; prévia sem ação de clique e com tipo Site de exemplo; pendências com ano de emissão e próxima revisão; aviso quando o código muda na hora de salvar; confirmação da troca de subtema como diálogo com título e botões; assuntos sem repetidos; estado "Erro ao carregar" (faltava) e texto do "não encontrado"; responsivo detalhado; seção "Dados e regras de negócio" reescrita com o formato dos objetos existentes ("id automático" estava errado: o dev usa o código como id); critérios reescritos (16, numerados); fora do escopo com os objetos antigos e a limpeza da 016.
- 2026-11-09 (decisões sem a pessoa): (1) gravar exatamente como os 190 objetos do dev (código como id do documento, `themeId`/`subthemeId` com siglas, `themeTitle`/`subthemeTitle`, tipo e formato pelo nome, datas só com o dia), porque o pedido é gravar como os dados existentes sem campo novo nem formato novo; os nomes de `themeTitle`/`subthemeTitle` saem da lista de temas do site (o seed usa grafias como "Poluição Água", e nenhuma tela lê esses campos); (2) o código como id do documento também garante que dois cadastros não fiquem com o mesmo código (criação só se o id estiver livre); (3) editor fora da moldura do painel, como no protótipo e no Observatório; (4) em 390 e 768, "Onde aparece" no topo e a prévia no fim (a spec aprovada punha as duas no topo; o protótipo põe as duas no fim), para escolher tema e subtema antes e ver a prévia depois de preencher; (5) barra fixa em todas as larguras, como no protótipo (a spec dizia só em 1280); (6) próxima revisão do link com duas listas (mês e ano), porque o Flutter não tem campo de mês, e o dia 1 gravado como nos dados; (7) ano de emissão com 4 algarismos; (8) "Cancelar" pede confirmação quando há alterações (o protótipo sai direto); (9) sem tema e subtema na lista, o novo objeto começa com os dois vazios, e eles entram nas pendências; (10) o diálogo antigo é apagado aqui, porque fica sem uso; campos e botões antigos ficam para a 016.
- 2026-11-09 (implementação, modo autônomo): `themeTitle` e `subthemeTitle` gravados com os nomes que o site mostra nas listas de tema e subtema (`ThemeEnum.name`/`SubthemeEnum.name`: "Natureza e Meio Ambiente", "Bacias Hidrográficas"), e não com o `title` do `ThemeDataModel` previsto no plano, que está em maiúsculas nos subtemas ("BACIAS HIDROGRÁFICAS") e invertido num tema ("Meio Ambiente e Natureza"). Assim os quatro temas ficam iguais aos 190 objetos; nos subtemas, só mudam as preposições que o seed tirou ("Poluição da Água" × "Poluição Água").
- 2026-11-09 (verificação): aviso também na troca de subtema quando o código gravado difere do mostrado na confirmação (antes dizia só "Alterações salvas"); Tab do último campo para a lateral rola até Tema e Subtema, que ficavam com o foco fora da tela.
