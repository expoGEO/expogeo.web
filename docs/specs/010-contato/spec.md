# 010. Contato

- **Status:** aprovada
- **Item do planejamento:** Fase 3, entrega 3.1 (tela T-06)
- **Protótipo:** aba "Contato" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Dar à expoGEO um jeito simples de receber sugestões de conteúdo, avisos de link quebrado e relatos de uso, no mesmo padrão já testado no Observatório (spec 018 de lá).

## Situação atual
- A constante `AppRouter.contact` (`/contato`) existe, mas não há rota nem página: o endereço cai no 404.
- O contato hoje é só o `mailto:expogeoufu@gmail.com` do rodapé.

## Comportamento

### Cabeçalho
- Superfície com migalhas "Início › Contato", título "Fale com a gente" e "Sugira um conteúdo, avise sobre um link quebrado ou conte como você usa a expoGEO."

### Formulário
- Campos com rótulo visível: **Nome**, **E-mail**, **Assunto**, **Mensagem** (várias linhas, ~6 de altura).
- Botão primário **"Abrir no meu e-mail"** e o texto "Vamos abrir o seu programa de e-mail com a mensagem já preenchida. Falta só você apertar **Enviar** por lá."
- Enter nos campos de uma linha passa ao próximo; na mensagem, quebra linha.
- O navegador pode sugerir nome e e-mail.

### Validação
Ao apertar o botão, sem contar espaços nas pontas:

| Campo | Regra | Mensagem |
|---|---|---|
| Nome | não vazio | "Escreva seu nome." |
| E-mail | formato `algo@algo.algo`, sem espaços | "Escreva um e-mail válido, como nome@exemplo.com." |
| Assunto | não vazio | "Diga em poucas palavras o assunto." |
| Mensagem | não vazia | "Escreva a mensagem." |

- Campo inválido com borda e mensagem na cor de erro; o foco vai ao primeiro inválido; nada é aberto.
- Antes da primeira tentativa, nenhum erro aparece. Depois, cada campo é conferido de novo enquanto se digita.

### Envio e confirmação
- Com tudo válido, abre o programa de e-mail (sem deixar aba em branco) com **Para** `expogeoufu@gmail.com`, **Assunto** digitado e **Corpo** com a mensagem, uma linha em branco, o nome e o e-mail digitado.
- No lugar do formulário: ícone em círculo verde-claro, "Seu e-mail está pronto", "Abrimos o seu programa de e-mail com a mensagem preenchida. Aperte **Enviar** por lá para concluir." e "Não abriu? Copie a mensagem e escreva para **expogeoufu@gmail.com**." (link `mailto:`).
- **"Copiar mensagem"** copia "Assunto: …", a mensagem, o nome e o e-mail; o botão vira "Mensagem copiada" por alguns segundos (ou "Erro ao copiar" se o navegador recusar).
- **"Voltar ao formulário"** volta com os campos preenchidos, sem erros, foco em "Nome".

### Outros meios
Ao lado do formulário, caixa em superfície "Outros meios":
- **E-mail:** `expogeoufu@gmail.com` (link `mailto:`).
- **Endereço:** "Faculdade de Educação · UFU / Av. João Naves de Ávila, 2121 / Santa Mônica · Uberlândia/MG".
- **Observatório:** `observatoriogeohistoria.net.br` (aba nova).

## Estados
- **Carregando / vazio:** não se aplica.
- **Erro:** só os erros de validação acima.
- **Casos de borda:** mensagem muito longa (o `mailto:` tem limite prático de tamanho em alguns programas; a confirmação continua oferecendo "Copiar mensagem"); caracteres especiais e quebras de linha chegam certos ao programa de e-mail; computador sem programa de e-mail configurado mostra a confirmação mesmo assim.

## Responsivo
- **390 e 768:** formulário em largura total e "Outros meios" abaixo.
- **1280:** formulário à esquerda (~60%) e "Outros meios" à direita.

## Acessibilidade
- Rótulos ligados aos campos; mensagens de erro ligadas ao campo e anunciadas.
- A confirmação é anunciada ao aparecer e recebe o foco no título.
- "Mensagem copiada" é anunciado.
- Item "Contato" ativo na navbar.

## Dados e regras de negócio
- Nada é gravado nem enviado pelo site. O destino é `expogeoufu@gmail.com`, o mesmo do rodapé.
- Rota `/contato` a partir da constante existente.

## Critérios de aceite
- [ ] `/contato` abre direto pelo endereço com cabeçalho, formulário e "Outros meios".
- [ ] Enviar vazio mostra as quatro mensagens e põe o foco no Nome.
- [ ] E-mail sem "@" ou com espaço mostra a mensagem de e-mail; corrigir faz a mensagem sumir enquanto se digita.
- [ ] Com tudo válido, abre o programa de e-mail com destinatário, assunto e corpo certos (conferir acentos e quebras de linha).
- [ ] Aparece a confirmação; "Copiar mensagem" copia o texto e muda o rótulo; "Voltar ao formulário" volta com os campos preenchidos.
- [ ] "Outros meios" mostra e-mail, endereço e link do Observatório.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1; formulário usável só por teclado.

## Fora do escopo
- Enviar o e-mail pelo próprio site (exigiria serviço externo).
- Anexos e captcha.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
