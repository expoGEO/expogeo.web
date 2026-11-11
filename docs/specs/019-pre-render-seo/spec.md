# 019. Pré-render por rota para indexação

- **Status:** aprovada
- **Origem:** pedido da pessoa (passo 2 da indexação no Google; o passo 1 foram os PRs #16 e #17)
- **Protótipo:** não se aplica
- **Criada em:** 2026-11-10

## Objetivo
Quem busca no Google passa a encontrar cada página do expoGEO (temas, subtemas e objetos) com título, descrição e texto próprios, e a abrir o link direto sem perder nada do que o app mostra hoje. O Flutter desenha tudo num canvas, e sem HTML com conteúdo o Google vê páginas quase vazias.

## Situação atual
- O `web/index.html` é um só para todas as rotas. As metas por rota (título, descrição, canonical, Open Graph) são escritas por JavaScript depois que o app carrega ([page_meta_web.dart](../../../lib/core/utils/browser/page_meta_web.dart)). Aplicativos de mensagem e redes sociais não executam JavaScript, então todo link compartilhado mostra a home.
- `web/robots.txt` libera o site e bloqueia `/admin`. Não há `sitemap.xml`.
- O `.htaccess` ([web/.htaccess](../../../web/.htaccess)) manda qualquer endereço que não seja arquivo para o `index.html`. Endereço inexistente responde 200 e o app mostra o 404 com `noindex`.
- Os objetos vivem no Firestore (`themes/{tema}/subthemes/{subtema}/contents/{código}`). Os nomes e as descrições de temas e subtemas vivem no código (`ThemeDataModel`, `ThemeEnum`, `SubthemeEnum`).
- Os deploys rodam por GitHub Actions e FTP ([deploy-prod.yml](../../../.github/workflows/deploy-prod.yml), [deploy-dev.yml](../../../.github/workflows/deploy-dev.yml)).

## Comportamento
Depois do `flutter build web`, uma etapa do deploy gera, a partir do build, uma página HTML por rota pública e um `sitemap.xml`. O app Flutter continua sendo o mesmo e assume a página assim que carrega.

**Rotas pré-renderizadas (produção)**
- Home (`/`), `/sobre` e `/contato`.
- Os 4 temas e os 31 subtemas que o site lista (o subtema Movimentos da Terra, que existe no código mas não aparece no site, fica de fora).
- Cada objeto do Firestore, na rota `/tema/subtema/código-em-minúsculas-com-hífen` (ex.: `/representacoes-espaciais/historia-cartografia/re-hc-01`).
- Não entram `/admin` e suas rotas.

**Conteúdo de cada página gerada**
- `title`, `description`, `canonical` (sem barra final), `og:*` e `twitter:*` próprios da rota, com o mesmo texto que o app já aplica por JavaScript. O Open Graph passa a valer para quem compartilha o link.
- Um bloco de texto real da página, dentro do HTML, com o que o app mostra: para o objeto, título, descrição, assuntos, autoria e subtema; para o subtema e o tema, o nome, o texto de apresentação e a lista de objetos com link; para a home, sobre e contato, os textos principais. O texto é o mesmo que a pessoa vê no app, sem conteúdo extra só para o Google.
- Dados estruturados (JSON-LD): `WebSite` e `Organization` na home; `BreadcrumbList` nas páginas internas; `LearningResource` nos objetos, com título, descrição, assuntos, idioma, autoria e data de inserção.

**Servidor**
- A página de `/sobre` é publicada como arquivo `sobre.html` e o `.htaccess` a serve em `/sobre`, sem redirecionar para `/sobre/`, para o canonical sem barra continuar valendo. A mesma regra vale para temas, subtemas e objetos.
- Endereço com barra final (`/sobre/`, `/representacoes-espaciais/`) redireciona (301) para o mesmo endereço sem a barra, para cada página ter um só endereço.
- Endereço que não tem arquivo gerado (objeto cadastrado depois do último deploy, ou endereço inexistente) continua indo para o `index.html` com resposta 200. O app mostra a página do objeto, se ele existir, ou o 404 com `noindex`.

**sitemap.xml e robots.txt (só produção)**
- O `sitemap.xml` lista todas as rotas pré-renderizadas com o endereço completo de produção e, nos objetos, a data de inserção como `lastmod`.
- O `robots.txt` de produção ganha a linha `Sitemap: https://expogeo.com.br/sitemap.xml`.

**Dev**
- O dev não gera `sitemap.xml` e mantém `Disallow: /`, a senha e o `noindex`. Se gerar as páginas, elas também ficam sob a senha e com `noindex`.

**Quando roda**
- A cada deploy de produção (merge na `main`) e quando alguém dispara o workflow à mão depois de cadastrar conteúdo no painel. Sem agendamento.

## Estados
- **Carregando:** ao abrir uma página gerada, o texto do bloco para o Google não aparece sobre a tela de carregamento atual e some quando o app mostra o primeiro quadro.
- **Vazio:** se o Firestore não tiver objetos num subtema, a página do subtema é gerada mesmo assim, sem a lista.
- **Erro:** se o Firestore não responder ou devolver algo inválido, o deploy de produção falha e **não publica**; não pode ir ao ar um sitemap ou páginas incompletos. O erro diz o que faltou.
- **Sem imagem / imagem com falha:** a imagem de compartilhamento (`og:image`) é sempre a mesma de hoje (`og-image.png`).
- **Casos de borda:** objeto com ID de documento aleatório e código só no campo `id` (existem 3 em produção) usa o campo `id` na rota; dois objetos do mesmo subtema com o mesmo código normalizado: vale o menor, como o app já faz; descrição muito curta ou muito longa: a meta é cortada em palavra inteira, perto de 155 caracteres, e as curtas ficam como estão; caracteres especiais em título e descrição são escapados no HTML e no JSON-LD.

## Responsivo
Sem mudança visual no app. O bloco de texto para o Google nunca altera o layout em 390, 768 e 1280 px, nem antes nem depois do carregamento.

## Acessibilidade
- Leitores de tela não leem o bloco duplicado: ele sai da página quando o app aparece, e a árvore de semântica do Flutter segue como única fonte.
- Sem JavaScript, o `<noscript>` continua mostrando o aviso atual, e o bloco de texto fica legível.
- Nada muda no foco por teclado, nos contrastes nem no movimento reduzido.

## Dados e regras de negócio
- Os objetos vêm do Firestore pela API REST pública, percorrendo tema, subtema e conteúdos, sem service account nem chave no CI. As regras atuais já permitem essa leitura; as antigas de produção negam a consulta direta ao grupo de coleções.
- Nomes e descrições de temas e subtemas vêm do código; não passam a ser editáveis pelo Firestore (decisão da pessoa, fora do escopo agora).
- `RE_HC_05` e `RE_PC_03` foram removidos de propósito e não existem mais.
- As descrições curtas dos objetos ficam como estão (decisão da pessoa).
- A rota de cada objeto segue a regra que o app já usa (`referenceCodeSlug`: minúsculas e `_` vira `-`). O sitemap e as páginas não podem listar endereço que o app não abra.
- O canonical e o `og:url` apontam sempre para `https://expogeo.com.br`.

## Critérios de aceite
- [ ] Depois do build de produção existem arquivos para home, `/sobre`, `/contato`, 4 temas, 31 subtemas e para cada objeto do Firestore, e nenhum para `/admin`.
- [ ] `curl https://expogeo.com.br/sobre` mostra, no HTML bruto (sem executar JavaScript), o título, a descrição, o canonical sem barra final e o texto da página.
- [ ] `curl` numa página de objeto mostra título, descrição, assuntos, canonical e JSON-LD `LearningResource` válidos no HTML bruto.
- [ ] Abrir `/sobre`, um tema, um subtema e um objeto direto no navegador não redireciona para endereço com barra final e carrega o app normalmente.
- [ ] Um endereço sem arquivo gerado abre o `index.html` com resposta 200; o app mostra a página do objeto ou o 404 com `noindex`.
- [ ] `sitemap.xml` lista todas as rotas pré-renderizadas com endereço de produção, `lastmod` nos objetos e nenhuma URL que o app mostre como 404.
- [ ] `robots.txt` de produção tem a linha `Sitemap:`; o do dev não.
- [ ] O dev não tem `sitemap.xml`, segue com senha, `noindex` e `Disallow: /`.
- [ ] O JSON-LD passa no Teste de Resultados Avançados do Google, sem erros, em uma página de objeto.
- [ ] Os 3 objetos de ID aleatório de produção saem com a rota certa, pelo campo `id`.
- [ ] Se o Firestore não responder, o deploy de produção falha e nada é enviado ao servidor.
- [ ] A pessoa que usa o site não vê o bloco de texto para o Google em 390, 768 e 1280 px, e os testes do app continuam passando.
- [ ] `docs/deployment.md` descreve o `.htaccess` versionado, o pré-render e o sitemap, e a nota antiga de que o `.htaccess` vive só no servidor foi corrigida.

## Fora do escopo
- Editar nomes e descrições de temas e subtemas pelo Firestore.
- Reescrever ou enriquecer as descrições curtas dos objetos.
- Devolver 404 de verdade para endereço inexistente (ideia futura, depende de o pré-render rodar a cada mudança no painel).
- Agendar o pré-render (por enquanto só em deploy e manual).
- Cadastrar o site no Google Search Console e enviar o sitemap.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-11-10: criada e aprovada. Decisões da pessoa registradas: endereço inexistente segue com 200 e `noindex`; pré-render só em deploy e manual; temas e subtemas só no código; `RE_HC_05` e `RE_PC_03` removidos de propósito; descrições curtas ficam como estão.
- 2026-11-10: acrescentado o redirecionamento de endereço com barra final para o sem barra. Motivo: com as pastas dos temas e subtemas no servidor, o Apache redirecionaria `/tema` para `/tema/` e a página pré-renderizada não abriria; o teste local mostrou isso e a solução (`DirectorySlash Off` mais o redirecionamento) mantém o endereço único.
