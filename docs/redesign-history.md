# Histórico do redesign

Redesenho do site público, do login e do painel da expoGEO, executado de 2026-10-23 a 2026-11-10 em 18 specs (001 a 018), em seis fases. O planejamento, as specs, os planos, as tarefas e as verificações saíram do repositório depois do merge e estão na tag local `redesign-specs`:

```sh
git show redesign-specs:docs/redesign/planejamento.md
git ls-tree -r --name-only redesign-specs docs/specs
```

A tag é criada localmente no encerramento da fase de limpeza, sem `git push` de tag; até lá, o mesmo material está no último commit antes da remoção (`git log --diff-filter=D --name-only -- docs/specs`). Não há `future-ideas.md`: as ideias futuras estão no fim deste documento.

- **Protótipo navegável (todas as telas, inclusive login, painel e editor):** https://claude.ai/artifact/6tQuscgpFQk87MU2JZPNNs. Continua sendo a referência visual.
- **Base visual e de código:** o redesign do Observatório (`../observatorio_geo_hist`, protótipo em https://claude.ai/artifact/PimRbbQyUDbqrapiv8HseH). Tokens, fontes, botões, navbar, rodapé, estados e componentes do painel foram copiados e adaptados, não redesenhados.
- **Princípios:** reaproveitar o Observatório; componentes compartilhados primeiro; tamanhos fixos por faixa de largura; aceite em 390, 768 e 1280 px, sem rolagem horizontal nem `overflow`, com contraste mínimo de 4,5:1 e navegação por teclado.

## Decisões de design e de produto

| Tema | Decisão |
|---|---|
| Marca | Sub-marca do Observatório: mesmo sistema visual, mantendo o logo "expoGEO", o degradê laranja-amarelo e a navegação por temas e subtemas |
| Ligação com o Observatório | Faixa escura no topo, link na navbar, bloco na Home e no Sobre, coluna no rodapé |
| Cor e degradê | `#C94400` em tudo que é clicável (o `#F97316` antigo tinha 2,8:1); degradê só decorativo |
| Fontes | Bricolage Grotesque e Figtree embutidas, as do Observatório; a Aleo e o `google_fonts` saíram |
| Navbar | Fixa, de fundo branco translúcido; a variação transparente sobre o topo foi testada e descartada |
| Ilustrações | Inteiras em medalhão 1:1 (`contain`), não no recorte 16:10 do Observatório |
| Rotas | As públicas continuam; rotas novas em português, minúsculas, sem acento e com hífen |
| Código na rota | `nma-bio-03`; o original `NMA_BIO_03` também abre e redireciona |
| Redes do rodapé | Não há redes próprias da expoGEO: o rodapé leva às do Observatório, com nome acessível "… do Observatório" |
| Fonte das contagens e listas | Catálogo único por `collectionGroup('contents')`, com regra de leitura própria no `firestore.rules`; no lugar das consultas `count()` e da paginação por cursor |
| Código no editor | Gerado a partir do prefixo que o subtema já usa; "Regras de registro" segue opcional |
| Logos de apoio | Levam aos sites institucionais, iguais aos do Observatório quando a instituição é a mesma |
| Contato | Abre o programa de e-mail com tudo preenchido, valida e confirma com "Copiar mensagem" |
| Painel | No padrão do Observatório, sem mudar dados, campos nem regras, sem situação de publicação, temas e subtemas só para consulta |
| Documentação | Sem `CLAUDE.md`; regras de design, comandos e git em [architecture.md](architecture.md) e [specs/README.md](specs/README.md) |

## Fases

| Fase | Período | Specs | PR |
|---|---|---|---|
| 0. Ambiente, fundação e casco | 2026-10-27 a 11-03 | 001 fundação (tokens, fontes, faixas), 002 botões, navbar e rodapé, 003 `index.html` e ilustrações em WebP | #8 (ambientes dev e produção: #3, #6) |
| 1. Home e Sobre | 2026-11-03 | 004 hero e temas, 005 como explorar e recentes, 006 Sobre e apoio | #9, regras do Firestore nos deploys em #10 |
| 2. Navegação de conteúdo | 2026-11-04 a 11-05 | 007 página de tema, 008 de subtema, 009 de objeto | #11 |
| 3. Contato e estados | 2026-11-06 a 11-08 | 010 contato, 011 esqueletos, vazio, erro e 404 | #13 (cor da seleção de texto: #12) |
| 4. Painel | 2026-11-08 a 11-09 | 012 login, 013 moldura e temas, 014 lista de objetos, 015 editor | #14 |
| 5. Limpeza | 2026-11-09 a 11-10 | 016 código, tokens, fontes, pacotes e assets sem uso; 017 comentários; 018 documentação | a abrir |

O que cada limpeza fez:

- **016:** saíram os componentes, tokens e utilitários antigos, a Aleo, `google_fonts`, `num_extension`, dez dependências e 49 pacotes do lockfile, o campo `color` dos modelos de tema e subtema, os PNGs substituídos pelos WebP e `lib/features/theme/REFACTORING_SUMMARY.md`. O build web foi de 49384 KB para 33992 KB; nada visível mudou, salvo a fonte da faixa de ambiente (Aleo para Figtree).
- **017:** comentários reduzidos ao porquê, sem citar spec, fase ou protótipo, sem código comentado; comportamento idêntico, conferido por comparação do código sem comentários. `analysis_options.yaml` e `web/index.html` perderam os comentários padrão.
- **018:** `.md` reduzidos a [README.md](../README.md), [architecture.md](architecture.md), [admin-panel.md](admin-panel.md), [deployment.md](deployment.md), este histórico e [specs/README.md](specs/README.md), além do deploy documentado a partir do plano de CI/CD.

## Ressalvas em aberto

Reconferidas no código e no estado do repositório em 2026-11-10; "não conferida" quer dizer que depende de ambiente, conta ou ferramenta que não estava disponível.

- **Produção:** a `main` ainda não tem o redesign. No merge, conferir a regra de leitura por grupo de coleções publicada, a Home com recentes e o formato dos documentos ([deployment.md](deployment.md)). Não conferida.
- **Servidor do dev:** reescrita de rotas e senha no `.htaccess` (inclusive endereços de 3 segmentos). Não conferida.
- **Painel com Firestore real:** login, gravação, exclusão e a transação de criar e mover só foram vistos com repositório simulado; faltam credenciais de teste. O painel logado também não foi conferido depois da limpeza ([admin-panel.md](admin-panel.md)). Não conferida.
- **Primeiro Tab de cada página** cai numa parada invisível (visão de plataforma do `SelectionArea` do `SiteScaffold`). Aberta: tirar a área do Tab tiraria tudo que está dentro dela.
- **Navbar de altura fixa** transborda com texto a 200%, e os títulos das colunas do rodapé são `h2`, somando-se aos da página. Não reconferida.
- **Leitor de tela real** (VoiceOver, NVDA), texto a 200% e o aviso nativo do navegador ao fechar a aba do editor: só árvore de semântica e testes. Não conferida.
- **Links de texto sem `href`** (contato e demais externos): o leitor de tela não os lê como link; o motor 3.35.5 não permite `target` no `href`. `PartnerLogo` usa `linkUrl` externo e pode ter o defeito da aba; não conferido.
- **Contato:** "Copiar mensagem" copia assunto e corpo, sem o destinatário, e o e-mail não podia ser selecionado (esta parte não foi reconferida).
- **Chips de filtro** saem como `role=switch` com `aria-checked`, não `aria-pressed` (limite do motor 3.35.5; o Observatório faz igual).
- **Ano de emissão:** nenhum objeto do dev tem o dado; só foi visto com datasource alterado. Produção não consultada.
- **Prévia de compartilhamento** em aplicativo de mensagem: depende do deploy.
- **Menu das listas do editor** (Tipo, Formato, Mês, Ano, Tema, Subtema) abre mais estreito que o campo.
- **Nome longo de subtema** parte a palavra abaixo de cerca de 346 px (fora das larguras exigidas).
- **`AppImages.movimentosTerra`** e `assets/images/movimentos_terra.webp` não têm uso: o subtema existe no enum mas não tem objetos. Remover entrada, arquivo e ajuste do teste, ou ligar a imagem ao subtema quando houver conteúdo.
- **Service worker:** o navegador embutido falha ao registrar `flutter_service_worker.js` ("An unknown error occurred when fetching the script"); vem de antes da limpeza e não afeta o site.

## Lições da execução

- `fvm flutter analyze`, `test` e `dart format` só funcionam numa cópia em caminho ASCII (o "ó" da pasta quebra a ferramenta).
- `pub get` em outra máquina ou SDK pode alterar transitivos no `pubspec.lock`; restaure se a entrega não prevê pacote novo.
- Sem `cwebp`, ImageMagick nem Pillow, WebP e ícones saem pelo Chrome sem janela (scripts em `tool/`).
- Limites de uso de 5 horas e semanais interromperam etapas; retomar a mesma sessão com SendMessage a partir do `tasks.md` continuou do ponto certo.
- Specs aprovadas há tempo precisam de revisão rápida antes do plano: nomes, rotas e arquivos citados mudam.
- Com a regra de leitura ainda não publicada, um datasource falso só no scratchpad (alimentado pelos dados do dev) permitiu ver o estado de sucesso; uma consulta só de leitura ao Firestore confere contagens e fichas contra a tela, e bloquear o Firestore no Chrome sem janela (CDP) dispensa datasource falso para o estado de erro.
- Quando o formato gravado muda, comparar com os documentos reais por consulta de leitura: a spec dizia id automático e o dev usa o código como id.
- Teste com fonte Ahem que acusa estouro costuma ser real; vale levar a sério mesmo quando a tela parece certa.
- Flutter 3.35.5 no web: `toggled` vira `aria-checked`; `hint` de campo é ignorado; `liveRegion` não vale em nó com papel nem em título (usar `announce`); `InlineLink` com `linkUrl` externo navega a própria aba.
- `SelectionArea` cria parada invisível de Tab: `ExcludeFocusTraversal` onde for aninhado.
- Cartão inteiro como link: o clique numa camada fora da árvore de acessibilidade evita um segundo ponto de foco que engolia o título.
- Dica de botão aberta por foco precisa checar se o botão ainda tem o foco; seletor recriado a cada escolha tira o foco do teclado do campo.
- Offline, o Firestore responde com cache vazio em vez de erro: tratar acervo vazio vindo do cache como falha.
- Painel sem credenciais de teste: conferir as telas com autenticação e repositório simulados e declarar o resto como não conferido.

## Fora do escopo e ideias futuras

- Busca geral do site.
- Modo escuro.
- Criar e editar temas e subtemas pelo painel (hoje só consulta; vêm do código).
- Situação de publicação (rascunho/publicado) e papéis de usuário no painel.
- Redes sociais próprias da expoGEO.
- Testes automatizados no CI (hoje só formatação, `analyze` e build) e previews por PR.
