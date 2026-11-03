# 015. Editor de objeto em página própria

- **Status:** aprovada
- **Item do planejamento:** Fase 4, entrega 4.4 (tela T-10, rotas novas)
- **Protótipo:** aba "Editor" (link em docs/specs/README.md); referência no Observatório: `docs/specs/033-editor-publicacao/`
- **Criada em:** 2026-10-27

## Objetivo
Cadastrar e editar a ficha de um objeto numa página com espaço, campos agrupados como aparecem no site, prévia do cartão e um resumo do que falta, no lugar do diálogo apertado de hoje. Os campos e os dados gravados continuam os mesmos.

## Situação atual
- `content_form_dialog.dart`: diálogo "Novo Conteúdo" / "Editar Conteúdo" com "ID do Conteúdo*" (digitado, ex.: `RE_CG_01`), Título*, Descrição*, Assuntos (separados por vírgula)*, Nota do Conteúdo, Criador*, Colaborador, Tipo*, Formato*, URL/Localização*, Idioma*, Requisitos, Ano de Emissão, Regras de Registro, Direitos*, Operação de Preservação*, Data de Atualização.
- Tema e subtema vêm do seletor do painel; não dá para escolher no diálogo.
- Data de inserção: `DateTime.now()` ao criar; mantida ao editar. Data de atualização começa com "agora" ao criar.

## Comportamento

### Endereços
- `/admin/painel/objetos/novo` (aceita `?tema=…&subtema=…` para vir preenchido).
- `/admin/painel/objetos/:codigo/editar`, com o código em minúsculas e hífen, como no site (Q-01): `/admin/painel/objetos/nma-bh-03/editar`. Sem sessão, volta ao login.

### Barra do editor
- "← Objetos digitais" (volta à lista com os filtros), título "Novo objeto" ou "Editar objeto" com o código em pílula, e os botões "Cancelar" (secundário) e **"Salvar"** (primário).
- Sair com alterações não salvas (Cancelar, voltar, fechar a aba) pede confirmação: "Sair sem salvar? As alterações feitas aqui serão perdidas." — "Continuar editando" / "Sair sem salvar".

### Coluna principal (cartões)
1. **Conteúdo:** Título; Descrição (dica "Uma ou duas frases. Aparece no cartão do objeto."); Assuntos (dica "Separe por vírgula. Viram filtros na página do subtema."); Nota de conteúdo *opcional*.
2. **Autoria:** Criador; Colaborador *opcional*.
3. **Origem e registro:** Endereço do recurso (dica "https://"); Tipo e Formato (listas, "Escolha"); Idioma (começa com "Português" no novo); Ano de emissão *opcional* (só números); Requisitos *opcional* (dica "Ex.: acesso à internet"; começa com "Acesso à internet" no novo); Regras de registro *opcional* (campo que existe hoje e aparece na ficha; o protótipo não mostra, mas fica, Q-05).
4. **Direitos e preservação:** Direitos; Ação de preservação (começa com "Atualização do link ao longo do tempo" no novo); Próxima revisão do link *opcional* (mês e ano).
- Campos opcionais marcados com "opcional" ao lado do rótulo; os demais são obrigatórios (os mesmos de hoje).

### Coluna lateral
- **Onde aparece:** Tema e Subtema (listas; trocar o tema reinicia o subtema) e o **Código de referência** com a dica "Gerado a partir do tema e do subtema." O código não é digitado.

### Regra do código (Q-05)
- **Prefixo:** o que os objetos já cadastrados no subtema usam (ex.: Poluição da Água usa `NMA_PAG`, não o `NMA_PA` da lista de subtemas). Em subtema sem objetos, usa o prefixo da lista de subtemas (`SubthemeEnum.id`).
- **Número:** o maior número já usado no subtema + 1, com 2 dígitos (`_06`; `_10` depois de `_09`). Números de objetos excluídos não são reaproveitados enquanto houver um maior.
- **Novo objeto:** o código aparece assim que tema e subtema estão escolhidos e é conferido de novo na hora de salvar, para dois cadastros seguidos não repetirem o número.
- **Editar sem trocar de subtema:** o código não muda.
- **Prévia do cartão:** o cartão de objeto (spec 005) atualizado enquanto se digita, com textos de exemplo nos campos vazios ("Título do objeto", "A descrição aparece aqui.", "Criador").

### Salvar
- Confere os obrigatórios e o endereço (precisa começar com `http://` ou `https://`).
- Faltando algo: aviso no topo "Falta preencher para salvar:" com a lista (o título, a descrição, os assuntos, o criador, o endereço do recurso — com "(comece com https://)" quando o problema for o formato —, o tipo, o formato, o idioma, os direitos, a ação de preservação). Cada item é link que leva o foco ao campo; os campos com problema ficam com borda de erro.
- Tudo certo: grava, volta à lista e mostra "Objeto cadastrado" ou "Alterações salvas".
- Ao criar: data de inserção = agora. Ao editar: mantém a data de inserção. Assuntos gravados como lista, sem espaços nas pontas e sem itens vazios.
- **Trocar o tema ou o subtema de um objeto existente** move o documento para o novo subtema (cria no novo e apaga do antigo) e gera o código novo; aviso antes de salvar: "O objeto vai mudar de subtema e receber o código {novo}. O endereço antigo deixa de funcionar."
- Falha ao gravar: aviso "Não deu para salvar. Confira a conexão e tente de novo." e os campos continuam preenchidos.

## Estados
- **Carregando (editar):** esqueleto dos cartões.
- **Objeto não encontrado (editar):** caixa "Não encontramos este objeto" com "Voltar aos objetos".
- **Salvando:** "Salvar" desativado com "Salvando…".
- **Casos de borda:** dois cadastros seguidos no mesmo subtema recebem números diferentes; ano com letras é recusado no campo; assunto repetido aparece uma vez; texto muito longo na descrição é aceito, mas a prévia mostra só 2 linhas.

## Responsivo
- **390:** uma coluna; "Onde aparece" e a prévia vão para o topo, antes de "Conteúdo"; botões da barra em largura total abaixo do título.
- **768:** uma coluna, como o celular.
- **1280:** duas colunas (campos ~2/3, lateral ~1/3), barra fixa no topo ao rolar.

## Acessibilidade
- Cada cartão é um grupo com título; rótulos visíveis ligados aos campos; "opcional" faz parte do rótulo.
- Aviso de pendências anunciado como alerta; cada link leva o foco ao campo.
- Diálogos de saída e de troca de subtema com foco inicial na opção segura e Esc para cancelar.
- Faixa "Ambiente de testes" no dev.

## Dados e regras de negócio
- **Mesmos campos e mesma estrutura gravada** de hoje (`intellectualIndicator`, `contentInfo`, `originInfo`, `registrationInfo`, `rightsInfo`, `preservationAction`, `id`, `themeId`, `subthemeId`). Nenhum campo novo.
- O documento continua com id automático; o código fica no campo `id`.
- Sem situação de publicação: salvar já publica no site.
- Temas e subtemas só para escolha; não são criados aqui.

## Critérios de aceite
- [ ] "+ Novo objeto" e "Editar" abrem o editor em página própria nos endereços novos; recarregar mantém a tela.
- [ ] O editor mostra os quatro cartões com os campos de hoje, os opcionais marcados e os valores iniciais do novo.
- [ ] Tema, subtema e código aparecem na lateral; trocar o tema reinicia o subtema e atualiza o código.
- [ ] Novo objeto em Bacias Hidrográficas recebe `NMA_BH_06` (com 5 objetos no dev); em Poluição da Água, `NMA_PAG_07`.
- [ ] Editar um objeto sem trocar de subtema mantém o código; "Regras de registro" aparece e grava como hoje.
- [ ] A prévia acompanha a digitação.
- [ ] Salvar vazio lista as pendências; cada link leva ao campo; endereço sem `https://` aparece com a observação.
- [ ] Criar grava no subtema certo do Firestore do dev, com data de inserção de agora, e o objeto aparece no site.
- [ ] Editar mantém a data de inserção e grava as alterações; o site mostra os novos valores.
- [ ] Mudar o subtema de um objeto existente avisa, move o documento e gera o código novo.
- [ ] Sair com alterações pede confirmação; sem alterações, sai direto.
- [ ] Erro de gravação mostra o aviso e preserva o que foi digitado.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1; formulário completo por teclado.

## Fora do escopo
- Rascunho, agendamento ou histórico de versões.
- Enviar imagem própria do objeto (os objetos não têm imagem).
- Criar ou editar temas e subtemas.

## Perguntas em aberto
- Nenhuma. (Respondidas: Q-01, código com hífen no endereço; Q-05, código gerado pela regra acima e "Regras de registro" mantido como opcional.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-01 e Q-05 respondidas; entra a seção "Regra do código".
- 2026-10-27: aprovada.
