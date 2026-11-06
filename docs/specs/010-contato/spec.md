# 010. Contato

- **Status:** implementada
- **Item do planejamento:** Fase 3, entrega 3.1 (tela T-06)
- **Protótipo:** aba "Contato" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27
- **Referência:** spec 018 do Observatório ("Fale com a gente"), já em produção lá

## Objetivo
Dar à expoGEO um jeito simples de receber sugestões de conteúdo, avisos de link quebrado e relatos de uso, no mesmo padrão já testado no Observatório (spec 018 de lá).

## Situação atual
- A constante `AppRouter.contact` (`/contato`) existe, mas não há rota nem página: o endereço cai no 404 (`NotFoundPage`).
- Mesmo assim, a página já é anunciada: o item "Contato" da navbar (`navbar.dart`, `navbar_mobile_menu.dart`) e "Fale com a gente" na coluna Curadoria do rodapé (`footer.dart`) levam a `/contato`, e o 404 é o que aparece. A navbar já sabe marcar a seção (`navbar_location.dart`).
- O único contato que funciona é o `mailto:expogeoufu@gmail.com` do rodapé, com o endereço e o Observatório em `AppLinks` (`app_links.dart`).
- O site ainda não tem campo de texto no visual novo: o `AppTextField` é o do painel, com o desenho antigo. As páginas públicas têm `PageHeader`, `Breadcrumbs`, `AppButton` e `SiteScaffold`, que servem aqui sem mudança.

## Comportamento
Navbar, cabeçalho, conteúdo e rodapé, como em `/sobre`.

### Cabeçalho
- Superfície com migalhas "Início › Contato" (só "Início" é link), título "Fale com a gente" e "Sugira um conteúdo, avise sobre um link quebrado ou conte como você usa a expoGEO."

### Formulário
- Campos com rótulo visível acima, em caixa normal: **Nome**, **E-mail**, **Assunto**, **Mensagem** (várias linhas, ~6 de altura, cresce com o texto até ~12 e depois rola por dentro).
- Botão primário **"Abrir no meu e-mail"**, com envelope à esquerda, e abaixo o texto "Vamos abrir o seu programa de e-mail com a mensagem já preenchida. Falta só você apertar **Enviar** por lá."
- Enter nos campos de uma linha passa ao próximo; na mensagem, quebra linha. O envio é só pelo botão.
- O navegador pode sugerir nome e e-mail. No celular, o campo E-mail abre o teclado de e-mail.

### Validação
Ao apertar o botão, sem contar espaços nas pontas:

| Campo | Regra | Mensagem |
|---|---|---|
| Nome | não vazio | "Escreva seu nome." |
| E-mail | formato `algo@algo.algo`, sem espaços | "Escreva um e-mail válido, como nome@exemplo.com." |
| Assunto | não vazio | "Diga em poucas palavras o assunto." |
| Mensagem | não vazia | "Escreva a mensagem." |

- Campo inválido com borda e mensagem na cor de erro; o foco vai ao primeiro inválido, que rola para a área visível, fora de baixo da navbar; nada é aberto.
- Antes da primeira tentativa, nenhum erro aparece. Depois, todos os campos são conferidos de novo enquanto se digita.

### Envio e confirmação
- Com tudo válido, abre o programa de e-mail (sem deixar aba em branco) com **Para** `expogeoufu@gmail.com`, **Assunto** digitado e **Corpo** com a mensagem, uma linha em branco, o nome e, na linha seguinte, o e-mail digitado.
- No lugar do formulário, em caixa com borda, centralizada: ícone de envelope em círculo verde-claro, "Seu e-mail está pronto", "Abrimos o seu programa de e-mail com a mensagem preenchida. Aperte **Enviar** por lá para concluir." e "Não abriu? Copie a mensagem e escreva para **expogeoufu@gmail.com**." (link `mailto:`).
- **"Copiar mensagem"** copia "Assunto: …", uma linha em branco e o mesmo corpo do e-mail (mensagem, linha em branco, nome e e-mail); o botão vira "Mensagem copiada" por alguns segundos (ou "Erro ao copiar" se o navegador recusar) e volta.
- **"Voltar ao formulário"** volta com os campos preenchidos, sem erros, foco em "Nome".
- A confirmação aparece sempre: o site não tem como saber se o programa de e-mail abriu.

### Outros meios
Ao lado do formulário, caixa em superfície com o título "Outros meios":
- **E-mail:** `expogeoufu@gmail.com` (link `mailto:`).
- **Endereço:** as mesmas três linhas do rodapé ("Faculdade de Educação · UFU / Av. João Naves de Ávila, 2121 · Santa Mônica / Uberlândia/MG").
- **Observatório:** `observatoriogeohistoria.net.br` (aba nova).

## Estados
- **Carregando / vazio:** não se aplica; a página não busca dados.
- **Erro:** só os erros de validação acima e "Erro ao copiar".
- **Casos de borda:** mensagem muito longa (o `mailto:` tem limite prático de tamanho em alguns programas; a confirmação continua oferecendo "Copiar mensagem"); acentos, emojis, `&`, `?`, `#`, `%` e quebras de linha chegam certos ao programa de e-mail e ao texto copiado; campo só com espaços conta como vazio; e-mail com espaço nas pontas é aparado e vale; computador sem programa de e-mail configurado mostra a confirmação mesmo assim; nome e assunto muito longos rolam dentro do campo, sem `overflow`; mudar a largura da janela não perde o que foi digitado.

## Responsivo
- **390:** formulário em largura total, "Outros meios" abaixo; "Abrir no meu e-mail" na largura toda; botões da confirmação quebram linha, centralizados.
- **768:** formulário em largura total, "Outros meios" abaixo; botão no tamanho do texto.
- **1280:** formulário à esquerda (~60%) e "Outros meios" à direita, alinhados no topo.

## Acessibilidade
- Rótulos ligados aos campos; mensagens de erro ligadas ao campo e lidas com ele; campo inválido marcado como inválido.
- A confirmação é anunciada ao aparecer e recebe o foco no título, que rola para a área visível.
- "Mensagem copiada" e "Erro ao copiar" são anunciados.
- Item "Contato" ativo na navbar e no menu do celular.
- "Fale com a gente" é `h1`; "Outros meios" e "Seu e-mail está pronto" são `h2`. O link do Observatório avisa que abre em nova aba.
- Ordem de Tab: Nome → E-mail → Assunto → Mensagem → "Abrir no meu e-mail" → links de "Outros meios". Na confirmação: link do e-mail → "Copiar mensagem" → "Voltar ao formulário" → "Outros meios". Foco visível em todos.
- Contraste ≥ 4,5:1 nos textos e links, inclusive sobre a superfície, e ≥ 3:1 na borda dos campos, que é o único contorno deles.
- A troca entre formulário e confirmação é imediata, sem animação.

## Dados e regras de negócio
- Nada é gravado nem enviado pelo site. O destino é `expogeoufu@gmail.com`, o mesmo do rodapé.
- E-mail, endereço e link do Observatório vêm das mesmas constantes do rodapé, para não haver duas versões.
- Rota `/contato` a partir da constante existente. As demais rotas, o painel, o `AppTextField` e o `Validators` não mudam.

## Critérios de aceite
- [ ] `/contato` abre direto pelo endereço e ao recarregar, com navbar, cabeçalho (migalhas "Início › Contato", `h1` e texto de apoio), formulário, "Outros meios" e rodapé; o item "Contato" fica ativo; a navbar, o menu do celular e o rodapé levam à página.
- [ ] O formulário tem os quatro campos com rótulo visível, o botão com envelope e o texto de apoio com **Enviar** em negrito; Enter passa de campo nas três linhas simples e quebra linha na mensagem; Nome e E-mail têm sugestão do navegador ligada.
- [ ] Enviar vazio mostra as quatro mensagens com borda de erro, põe o foco no Nome, com ele visível, e nada é aberto; antes disso nenhum erro aparece.
- [ ] E-mail sem "@" ou com espaço no meio mostra a mensagem de e-mail; campo só com espaços conta como vazio; e-mail com espaço nas pontas vale; corrigir faz a mensagem sumir enquanto se digita.
- [ ] Com tudo válido, abre o programa de e-mail na mesma aba, com destinatário, assunto e corpo certos, inteiros, inclusive acentos, emoji, `&`, `?`, `#`, `%` e quebras de linha.
- [ ] A confirmação substitui o formulário com ícone, título, os dois textos, o link `mailto:` e os dois botões; recebe o foco no título, aparece inteira na tela e é anunciada.
- [ ] "Copiar mensagem" copia o texto no formato da spec e muda o rótulo por alguns segundos, com anúncio; com a cópia recusada, mostra "Erro ao copiar".
- [ ] "Voltar ao formulário" volta com os campos preenchidos, sem erros e com o foco no Nome; um novo envio funciona.
- [ ] "Outros meios" mostra e-mail (`mailto:`), o endereço igual ao do rodapé e o link do Observatório em aba nova, com foco visível e nome acessível.
- [ ] Formulário e confirmação são usáveis só por teclado, na ordem de Tab da seção "Acessibilidade", com foco visível; campos lidos com rótulo e erro; contraste ≥ 4,5:1 nos textos e ≥ 3:1 na borda dos campos.
- [ ] Em 390, 768 e 1280 px, conforme "Responsivo", com formulário vazio, com erros, com textos longos e na confirmação: sem rolagem horizontal nem `overflow`, em release e em debug; mudar a largura mantém o que foi digitado.
- [ ] Código novo só com tokens do tema, sem `num_extension` nem `GestureDetector` solto; nenhum pacote novo; painel, `AppTextField`, `Validators` e demais rotas sem mudança; `analyze`, testes e build sem erro.

## Fora do escopo
- Enviar o e-mail pelo próprio site (exigiria serviço externo).
- Anexos e captcha.
- Saber se o e-mail foi enviado; guardar o rascunho ao sair da página.
- Telefones e redes sociais na página: o protótipo não traz telefone, e as redes seguem no rodapé (Q-03).
- Apagar ou mudar `AppTextField` e `Validators`, usados pelo painel e pelo login (limpeza na 016).

## Perguntas em aberto
- Nenhuma. Respondidas na revisão de 2026-11-06:
  - **Endereço de "Outros meios".** Decidido no modo autônomo: as três linhas do rodapé (`AppLinks.address`), porque o protótipo escreve o endereço de dois jeitos, um no rodapé e outro na aba Contato, e o site deve ter uma só versão, como fez a 018.
  - **Borda dos campos.** Decidido no modo autônomo: cor nova, a `fieldBorder` do Observatório (#8A8178, 3,8:1), porque a `line` do protótipo dá 1,3:1 e seria o único contorno do campo.
  - **Migalhas e mensagens.** Decidido no modo autônomo: "Início › Contato" e os textos desta spec, iguais ao protótipo, porque é ele que define a expoGEO; a 018 usa outras palavras ("Fale com a gente", "Informe…").
  - **Mensagem sem tamanho mínimo.** Decidido no modo autônomo: só não pode ser vazia, como no protótipo e nesta spec aprovada; o mínimo de 10 caracteres é regra da 018 lá.
  - **Texto copiado.** Decidido no modo autônomo: "Assunto: …" seguido do corpo do e-mail, porque o protótipo começa pelo assunto e assim a cópia e o e-mail assinam igual. Não entra "Para:" (a 018 põe): o endereço está na própria confirmação.
  - **"Voltar ao formulário" mantém os campos.** Decidido no modo autônomo: como no protótipo e na 018; quem volta em geral quer corrigir algo ou tentar de novo.
  - **Enter não envia.** Decidido no modo autônomo: como na 018, para ninguém abrir o e-mail sem querer no meio do preenchimento; o formulário HTML do protótipo enviaria, mas lá é só demonstração.
  - **Botão na largura toda no celular.** Decidido no modo autônomo: como na 018; o protótipo não define.
  - **Rolar até o foco.** Decidido no modo autônomo: entra na spec, porque a verificação da 018 achou o campo inválido escondido sob a navbar fixa quando a página estava rolada.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
- 2026-11-06 (revisão antes do plano, modo autônomo): "Situação atual" ao dia (navbar, menu e rodapé já apontam para `/contato`, e o 404 é o que aparece; `AppLinks`). Endereço corrigido para o do rodapé. Texto copiado detalhado. Acrescentados: rolagem até o foco, ícone do botão, limite de altura da mensagem, botão na largura toda a 390, níveis de título, ordem de Tab, contraste da borda, casos de borda vistos na 018 e "mudar a largura não perde o texto". Critérios de aceite passam de 7 para 12, separando itens que estavam juntos. "Fora do escopo" completado. Status segue `aprovada`.
- 2026-11-06: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-11-06 (implementação, modo autônomo): sem mudança de comportamento. O motor web do Flutter 3.35.5 não publica `hint` em campo de texto, então o erro "ligado ao campo" entra no nome acessível ("Nome. Escreva seu nome.") enquanto existir. Plano e tarefas ajustados.
- 2026-11-06: implementada.
