# 012. Login do painel

- **Status:** aprovada
- **Item do planejamento:** Fase 4, entrega 4.1 (tela T-08)
- **Protótipo:** aba "Login" (link em docs/specs/README.md); referência no Observatório: o login de `lib/app/features/admin/login/` (o Observatório não guarda specs no repositório)
- **Criada em:** 2026-10-27

## Objetivo
Quem cuida da curadoria entra no painel por uma tela com a marca da expoGEO, mensagens claras e um caminho de volta ao site, no mesmo desenho do login do Observatório.

## Situação atual
- `lib/features/admin/login/presentation/pages/signin_page.dart`, aberta em `/admin` sem sessão: cartão branco centralizado sobre cinza, com largura proporcional à tela, título "LOGIN", campos "E-MAIL" (dica "exemplo@dominio.com") e "SENHA" com ícone de olho sem nome acessível, e botão "ENTRAR", que vira um círculo de carregamento durante a tentativa. Usa os tokens antigos e o `num_extension`.
- A senha passa por uma regra de senha forte (8 caracteres, maiúscula, minúscula, número e símbolo) antes de chamar o Firebase: uma senha cadastrada fora dessa regra nem chega a ser tentada.
- Erros do Firebase viram aviso flutuante no rodapé da tela, com os textos de `lib/features/admin/login/infra/errors/auth_failure.dart` ("Senha incorreta", "Usuário não encontrado", "Muitas tentativas…", "Erro no servidor" etc.), que dizem qual dos dois dados está errado.
- `/admin` mostra o login ou o painel conforme a sessão; `/admin/painel` sem sessão volta para `/admin`. As duas decisões leem a sessão no instante em que a página abre; no navegador, o Firebase recupera a sessão salva um pouco depois, então recarregar a página com sessão pode mostrar o login.
- A faixa "Ambiente de testes" já aparece no topo de todas as telas fora da produção (spec 001), inclusive no login.

## Comportamento

### Coluna da marca
- Fundo escuro (o do rodapé) com círculos concêntricos decorativos em laranja claro, saindo do canto de baixo à direita.
- Marca como no rodapé (símbolo em círculo branco, "expo" em branco e "GEO" em laranja claro, e "Curadoria digital do saber geográfico"), que leva à Home.
- Rótulo "Painel da curadoria", título "Cuide da curadoria da expoGEO." e "Cadastre, revise e organize os objetos digitais de cada tema e subtema."
- No pé: "Sem acesso? Peça a quem administra o painel para criar seu usuário."

### Formulário
- Cartão branco com borda e sombra leve sobre a superfície: título "Entrar" e "Use o e-mail e a senha que a administração cadastrou para você."
- Campos **E-mail** (dica "nome@exemplo.com") e **Senha**, no mesmo desenho dos campos do Contato (rótulo acima, borda, anel laranja no foco, erro abaixo). A senha tem um botão de ícone "Mostrar senha" / "Esconder senha", com dica ao passar o mouse ou focar.
- Botão primário em largura total **"Entrar"**; durante a tentativa, fica desativado com indicador girando e "Entrando…".
- Link "← Voltar ao site" (Home), abaixo do botão.

### Validação e erros
- Antes de chamar o Firebase: e-mail fora do formato → "Escreva o e-mail, como nome@exemplo.com."; senha vazia → "Escreva a senha." Nenhuma outra regra de senha. Espaços nas pontas do e-mail não contam. Foco no primeiro campo com erro. As mensagens só aparecem depois da primeira tentativa e somem quando o campo é corrigido.
- Credenciais erradas (usuário inexistente, senha errada, credencial ou e-mail inválido) → aviso único acima dos campos: "E-mail ou senha não conferem. Confira e tente de novo." Não diz qual dos dois está errado. O que foi digitado continua nos campos.
- Muitas tentativas → "Muitas tentativas seguidas. Espere alguns minutos e tente de novo."
- Usuário desativado → "Este usuário está desativado. Fale com quem administra o painel."
- Sem conexão ou outro erro → "Não conseguimos entrar agora. Confira sua conexão e tente de novo."
- Uma nova tentativa esconde o aviso anterior. Ao sair do login e voltar, nenhum aviso antigo aparece.

### Depois de entrar
- Vai para `/admin/painel` (spec 013), como hoje.

## Estados
- **Carregando:** botão "Entrando…" desativado, com indicador; campos continuam visíveis.
- **Vazio:** não se aplica (a tela não carrega dados).
- **Erro:** aviso único em fundo de erro suave com ícone, acima dos campos.
- **Casos de borda:** Enter no campo de senha envia; Enter no e-mail passa para a senha; clicar duas vezes em "Entrar" ou apertar Enter durante a tentativa não faz duas tentativas; já logado ao abrir ou recarregar `/admin` vai direto ao painel, mesmo que a sessão salva demore a ser recuperada; e-mail muito longo não estoura o campo.

## Responsivo
- **390:** a coluna da marca vira faixa no topo (marca + rótulo + título; texto de apoio e "Sem acesso?" escondidos); cartão do formulário logo abaixo, com margens menores.
- **768:** como o celular.
- **1280:** duas colunas (marca ~45%, formulário ~55%) ocupando a altura da tela, cartão de até 400 px centralizado.
- Em telas baixas, a página rola; nada fica cortado.

## Acessibilidade
- Rótulos visíveis ligados aos campos; o erro de cada campo é lido junto com ele; o aviso de credenciais é anunciado pelo leitor de tela assim que aparece.
- Botão de mostrar senha com nome ("Mostrar senha" / "Esconder senha") e estado de ligado/desligado (no navegador, o Flutter 3.35.5 publica esse estado como marcado/desmarcado, não como "pressionado").
- Título "Entrar" e título da coluna da marca marcados como títulos.
- Foco visível em tudo; ordem: marca, e-mail, senha, mostrar senha, Entrar, Voltar ao site.
- Contraste ≥ 4,5:1 para texto e ícones informativos, inclusive os textos claros sobre o fundo escuro.
- A faixa "Ambiente de testes" continua a da spec 001, fora da produção; o login não cria outra.

## Dados e regras de negócio
- Mesmo Firebase Auth por e-mail e senha; nenhuma regra de acesso muda.
- Rotas `/admin` e `/admin/painel` continuam iguais.
- O painel (lista e formulário de objetos) continua com os campos e validações antigos até as specs 014 e 015.

## Critérios de aceite
- [ ] `/admin` sem sessão mostra o login em duas colunas (desktop) com os textos do protótipo.
- [ ] E-mail inválido e senha vazia mostram as mensagens de campo sem chamar o Firebase, com foco no primeiro campo com erro; uma senha qualquer não vazia é aceita para tentar.
- [ ] Credenciais erradas mostram o aviso único "E-mail ou senha não conferem…"; muitas tentativas, usuário desativado e falha de conexão mostram as mensagens próprias.
- [ ] Durante a tentativa, o botão mostra "Entrando…" e não aceita outro clique nem outro Enter.
- [ ] Login certo leva ao painel; recarregar `/admin` com sessão abre o painel.
- [ ] "Voltar ao site" e a marca levam à Home.
- [ ] Mostrar/esconder senha funciona por mouse e teclado, com nome e estado lidos.
- [ ] Em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`; contraste ≥ 4,5:1; foco visível na ordem da spec.
- [ ] No dev aparece "Ambiente de testes"; em produção, não.
- [ ] O código novo usa os tokens do tema, sem `num_extension`, cor ou tamanho solto; o painel e as telas públicas não mudam.

## Fora do escopo
- Criar usuário, recuperar senha ou trocar senha pelo site.
- Mudar provedores de login.
- Moldura do painel, "Sair" e redirecionamentos dentro do painel (spec 013).
- Cor da faixa "Ambiente de testes" (o protótipo a mostra laranja; segue a da 001).

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
- 2026-11-08: revisada contra o código das Fases 0–3 e a aba "Login" do protótipo, antes do plano (modo autônomo, sem mudar o status). Mudanças: caminho completo da página e situação atual detalhada (regra de senha forte, aviso flutuante, sessão lida antes de o Firebase recuperá-la); referência do Observatório trocada pelo código, já que lá não há `docs/specs/029`; campos no desenho do Contato (010); marca como a do rodapé; regras de validação explícitas (sem regra de senha, espaços aparados, mensagens só depois da primeira tentativa); "e-mail inválido" do Firebase entra no aviso único; aviso antigo não reaparece; estado do botão de senha como ligado/desligado, porque o motor web 3.35.5 não emite `aria-pressed` (lição da 009); faixa de ambiente é a global da 001; critérios de foco, contraste, Enter e código acrescentados; fora do escopo inclui a moldura do painel e a cor da faixa.
- 2026-11-08 (decisões sem a pessoa): 768 continua como o celular, como na versão aprovada, embora o Observatório use duas colunas a partir de 600; os campos do login não são apagados depois de credenciais erradas, como no protótipo (o Observatório apaga a senha).
