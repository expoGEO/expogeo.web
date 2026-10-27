# 012. Login do painel

- **Status:** aprovada
- **Item do planejamento:** Fase 4, entrega 4.1 (tela T-08)
- **Protótipo:** aba "Login" (link em docs/specs/README.md); referência no Observatório: `docs/specs/029-login-redesenho/`
- **Criada em:** 2026-10-27

## Objetivo
Quem cuida da curadoria entra no painel por uma tela com a marca da expoGEO, mensagens claras e um caminho de volta ao site, no mesmo desenho do login do Observatório.

## Situação atual
- `features/admin/login/presentation/pages/signin_page.dart` em `/admin`: campos "E-MAIL" (dica "exemplo@dominio.com") e "SENHA" com mostrar/esconder, no visual antigo.
- Erros do Firebase traduzidos em `auth_failure.dart` ("Credenciais inválidas", "Usuário não encontrado", "Senha incorreta", "Muitas tentativas…" etc.).
- `/admin` mostra o login ou o painel conforme a sessão; `/admin/painel` sem sessão volta para `/admin`.

## Comportamento

### Coluna da marca
- Fundo escuro com círculos concêntricos decorativos no canto.
- Marca (símbolo + "expo**GEO**" + "Curadoria digital do saber geográfico"), que leva ao site.
- Rótulo "Painel da curadoria", título "Cuide da curadoria da expoGEO." e "Cadastre, revise e organize os objetos digitais de cada tema e subtema."
- No pé: "Sem acesso? Peça a quem administra o painel para criar seu usuário."

### Formulário
- Cartão branco sobre superfície: título "Entrar" e "Use o e-mail e a senha que a administração cadastrou para você."
- Campos **E-mail** (dica "nome@exemplo.com") e **Senha**, com botão de ícone "Mostrar senha" / "Esconder senha".
- Botão primário em largura total **"Entrar"**; durante a tentativa, fica desativado com indicador e "Entrando…".
- Link "← Voltar ao site" (Home).

### Validação e erros
- Antes de chamar o Firebase: e-mail fora do formato → "Escreva o e-mail, como nome@exemplo.com."; senha vazia → "Escreva a senha." Foco no primeiro campo com erro.
- Credenciais erradas (usuário inexistente, senha errada, credencial inválida) → aviso único acima dos campos: "E-mail ou senha não conferem. Confira e tente de novo." Não diz qual dos dois está errado.
- Muitas tentativas → "Muitas tentativas seguidas. Espere alguns minutos e tente de novo."
- Usuário desativado → "Este usuário está desativado. Fale com quem administra o painel."
- Sem conexão ou outro erro → "Não conseguimos entrar agora. Confira sua conexão e tente de novo."

### Depois de entrar
- Vai para `/admin/painel` (spec 013), como hoje.

## Estados
- **Carregando:** botão "Entrando…" desativado; campos continuam visíveis.
- **Erro:** aviso único em fundo de erro suave com ícone.
- **Casos de borda:** Enter no campo de senha envia; clicar duas vezes em "Entrar" não faz duas tentativas; já logado ao abrir `/admin` vai direto ao painel.

## Responsivo
- **390:** a coluna da marca vira faixa no topo (marca + título curto; texto e "Sem acesso?" escondidos); cartão do formulário logo abaixo.
- **768:** como o celular.
- **1280:** duas colunas (marca ~45%, formulário ~55%), cartão de até 400 px centralizado.

## Acessibilidade
- Rótulos visíveis ligados aos campos; erros ligados ao campo; aviso de credenciais anunciado como alerta.
- Botão de mostrar senha com nome e estado pressionado.
- Foco visível em tudo; ordem: marca, e-mail, senha, mostrar senha, Entrar, Voltar ao site.
- Faixa "Ambiente de testes" no topo quando `APP_ENV=dev`.

## Dados e regras de negócio
- Mesmo Firebase Auth por e-mail e senha; nenhuma regra de acesso muda.
- Rotas `/admin` e `/admin/painel` continuam iguais.

## Critérios de aceite
- [ ] `/admin` sem sessão mostra o login em duas colunas (desktop) com os textos do protótipo.
- [ ] E-mail inválido e senha vazia mostram as mensagens de campo sem chamar o Firebase.
- [ ] Credenciais erradas mostram o aviso único "E-mail ou senha não conferem…".
- [ ] Durante a tentativa, o botão mostra "Entrando…" e não aceita outro clique.
- [ ] Login certo leva ao painel; recarregar `/admin` com sessão abre o painel.
- [ ] "Voltar ao site" e a marca levam à Home.
- [ ] Mostrar/esconder senha funciona por mouse e teclado.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1.
- [ ] No dev aparece "Ambiente de testes"; em produção, não.

## Fora do escopo
- Criar usuário, recuperar senha ou trocar senha pelo site.
- Mudar provedores de login.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
