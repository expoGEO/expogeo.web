# Histórico do redesign

Uma linha por fase executada. O detalhe de cada spec fica em `docs/specs/NNN-*/` (spec, plano, tarefas e verificação), e o andamento de cada fase, no git (arquivo `execucao-<fase>.md`, apagado no encerramento).

| Fase | Período | Specs | PR |
|---|---|---|---|
| Fase 0: ambiente, fundação e casco | 2026-10-27 a 2026-11-03 | 001-fundacao, 002-botoes-navbar-rodape, 003-index-ilustracoes (todas verificadas) | PR da branch `refactor/redesign-fase-0` para `develop` |
| Fase 1: Home e Sobre | 2026-11-03 | 004-hero-temas, 005-como-explorar-recentes, 006-sobre-apoio (todas verificadas com ressalvas) | PR da branch `refactor/redesign-fase-1` para `develop` |
| Fase 2: navegação de conteúdo | 2026-11-04 a 2026-11-05 | 007-pagina-tema, 008-pagina-subtema, 009-pagina-objeto (todas verificadas com ressalvas) | PR da branch `refactor/redesign-fase-2` para `develop` |
| Fase 3: contato e estados | 2026-11-06 a 2026-11-08 | 010-contato (verificada com ressalvas), 011-estados-especiais (verificada) | PR da branch `refactor/redesign-fase-3` para `develop` |
| Fase 4: painel | 2026-11-08 a 2026-11-09 | 012-login, 013-painel-estrutura, 014-painel-objetos (verificadas), 015-editor-objeto (verificada com ressalvas) | PR da branch `refactor/redesign-fase-4` para `refactor/redesign-fase-3` (passa para a `develop` quando o #13 entrar) |

## Pendências em aberto
- **Regra do Firestore (004, 005):** os deploys publicam as regras desde o PR #10 e a leitura funciona no dev (190 objetos; 35, 74, 42, 39). Falta conferir na produção depois do merge na `main`.
- **Acessibilidade anterior à Fase 1:** a navbar de altura fixa transborda com texto a 200% e os títulos das colunas do rodapé saem como `h2`.
- **Primeiro Tab de cada página (009):** cai numa parada invisível, a visão de plataforma do `SelectionArea` do `SiteScaffold`, no web.
- **Reescrita de rotas no dev:** em 2026-11-06, qualquer endereço além de `/` em `dev.expogeo.com.br` dava o 404 da HostGator e a raiz abria sem senha: falta a reescrita (e a senha) no `.htaccess` do servidor, etapa E2 de [docs/cicd/planejamento.md](../cicd/planejamento.md). Depois de corrigir, conferir inclusive os endereços de 3 segmentos da 009.
- **Preservação (009, 014/015):** `ContentResponseModel.fromJson` testa `preservationOperation`, chave ausente nos 190 objetos do dev, e o formulário do painel abre com o campo em branco. O catálogo lê `preservationAction` à parte; a correção do modelo fica para 014/015. Conferir na produção se a chave é a mesma.
- **Ano de emissão (008, 009):** nenhum objeto do dev tem o dado, então só foi visto com datasource alterado.
- **003:** conferir a prévia real em aplicativo de mensagem (WhatsApp etc.) depois do deploy em `dev.expogeo.com.br`.
- **Painel admin:** não foi conferido na tela na Fase 0, por falta de credenciais de teste. Nenhum arquivo dele mudou.
- **014:** fala em fonte monoespaçada para o código de referência; a 001 decidiu usar Figtree 600 com algarismos tabulares (a 009 já foi corrigida).
- **Painel admin:** também não conferido nas Fases 1 e 2; nenhum arquivo dele mudou.
- **016:** PNGs das ilustrações e botões antigos (`PrimaryButton`/`SecondaryButton`, ainda no painel) saem na limpeza.
- **Links de texto (010):** sem `href`, para não navegar a própria aba com a semântica ligada; o leitor de tela não os lê como link. O `partner_logo.dart` (apoio, na Home e no Sobre) usa o mesmo `linkUrl` externo e provavelmente tem o defeito da aba; não foi conferido.
- **Contato (010):** o e-mail não pode ser selecionado e "Copiar mensagem" não traz o destinatário; quem não tem programa de e-mail precisa digitá-lo.
- **Componentes de estado antigos (011):** `CircularLoading`, `ContentError` e `ContentEmpty` seguem só para o painel e os botões antigos (Fases 4 e 5).
- **Painel admin:** também não conferido na Fase 3; nenhum arquivo dele mudou.
- **Editor (015):** o menu das listas (Tipo, Formato, Mês, Ano, Tema, Subtema) abre mais estreito que o campo; duas tentativas com `minimumSize` do `MenuStyle` não resolveram.
- **Painel com Firestore real (012 a 015):** login, gravação, exclusão e a transação de criar/mover código só foram vistos com autenticação e repositório simulados; faltam credenciais de teste no dev. Conferir o formato do documento gravado (código como id, siglas de tema/subtema, tipo e formato pelo nome) também na produção.
- **Leitura dos dados (014):** a leitura de tipo, formato e preservação mudou e vale também para o site público; conferir na produção depois do merge.
- **Painel:** leitor de tela real, texto a 200% e aviso nativo ao fechar a aba do editor não foram conferidos.

## Lições
- `fvm flutter analyze` e os testes só rodam numa cópia em caminho ASCII (o "ó" da pasta quebra a ferramenta).
- Um `pub get` em outra máquina ou SDK pode alterar transitivos no `pubspec.lock`; restaure se a entrega não prevê pacote novo.
- A máquina não tem `cwebp`, ImageMagick nem Pillow: WebP e ícones saem pelo Chrome sem janela (scripts em `tool/`).
- Limites de uso interromperam duas implementações; retomar a mesma sessão a partir do `tasks.md` funcionou sem perda.
- Specs aprovadas há tempo precisam de uma revisão rápida antes do plano: a Fase 0 já tinha mudado nomes, rotas e arquivos citados nelas.
- Com a regra de leitura ainda não publicada, um datasource falso só no scratchpad (alimentado pelos dados do dev lidos por subtema) permitiu conferir o estado de sucesso sem commitar nada.
- Cartão inteiro como link: o clique numa camada fora da árvore de acessibilidade evita um segundo ponto de foco que engolia o título.
- No web, `toggled` da semântica sai como `aria-checked`; o motor 3.35.5 não emite `aria-pressed`.
- `SelectionArea` cria uma visão de plataforma que vira parada invisível de Tab: envolver em `ExcludeFocusTraversal` onde for aninhado.
- Uma consulta só de leitura ao Firestore do dev confere contagens e fichas contra a tela: a 009 comparou os 190 objetos.
- Rodapé e `SiteScaffold`: o teste com fonte Ahem acusou um estouro real, que só aparece no navegador com texto a 125%. Vale levar a sério aviso de teste de widget mesmo quando a tela parece certa.
- `InlineLink` com `linkUrl` externo: com a semântica ligada, o motor navega a própria aba além de abrir a nova.
- Flutter 3.35.5 no web: ignora `hint` em campo de texto, não aceita `liveRegion` num nó com papel nem em título; usar `announce`.
- Simular falta de rede bloqueando o Firestore no Chrome sem janela (CDP) dispensou datasource falso para o estado de erro.
- Retomar uma sessão de etapa parada pelo limite semanal com SendMessage funcionou.
- Quando o formato gravado muda de leitura (014) e de escrita (015), comparar com os documentos reais por consulta só de leitura evita surpresa: a spec dizia id automático e o dev usa o código como id.
- Dica de botão aberta por foco precisa checar se o botão ainda tem o foco ao abrir; segurar o Tab deixava dicas empilhadas.
- Seletor recriado a cada escolha tira o foco do teclado do campo: recriar só quando a mudança vem de fora.
- Limite de 5 horas interrompeu duas etapas (verificação da 013, implementação da 015); retomar com SendMessage continuou do ponto certo.
