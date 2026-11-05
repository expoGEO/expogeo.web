# Histórico do redesign

Uma linha por fase executada. O detalhe de cada spec fica em `docs/specs/NNN-*/` (spec, plano, tarefas e verificação), e o andamento de cada fase, no git (arquivo `execucao-<fase>.md`, apagado no encerramento).

| Fase | Período | Specs | PR |
|---|---|---|---|
| Fase 0: ambiente, fundação e casco | 2026-10-27 a 2026-11-03 | 001-fundacao, 002-botoes-navbar-rodape, 003-index-ilustracoes (todas verificadas) | PR da branch `refactor/redesign-fase-0` para `develop` |
| Fase 1: Home e Sobre | 2026-11-03 | 004-hero-temas, 005-como-explorar-recentes, 006-sobre-apoio (todas verificadas com ressalvas) | PR da branch `refactor/redesign-fase-1` para `develop` |
| Fase 2: navegação de conteúdo | 2026-11-04 a 2026-11-05 | 007-pagina-tema, 008-pagina-subtema, 009-pagina-objeto (todas verificadas com ressalvas) | PR da branch `refactor/redesign-fase-2` para `develop` |

## Pendências em aberto
- **Regra do Firestore (004, 005):** os deploys publicam as regras desde o PR #10 e a leitura funciona no dev (190 objetos; 35, 74, 42, 39). Falta conferir na produção depois do merge na `main`.
- **Acessibilidade anterior à Fase 1:** a navbar de altura fixa transborda com texto a 200% e os títulos das colunas do rodapé saem como `h2`.
- **Primeiro Tab de cada página (009):** cai numa parada invisível, a visão de plataforma do `SelectionArea` do `SiteScaffold`, no web.
- **Endereços de 3 segmentos (009):** conferir a reescrita do servidor em `dev.expogeo.com.br` depois do deploy (`.htaccess` fora do repositório).
- **Preservação (009, 014/015):** `ContentResponseModel.fromJson` testa `preservationOperation`, chave ausente nos 190 objetos do dev, e o formulário do painel abre com o campo em branco. O catálogo lê `preservationAction` à parte; a correção do modelo fica para 014/015. Conferir na produção se a chave é a mesma.
- **Ano de emissão (008, 009):** nenhum objeto do dev tem o dado, então só foi visto com datasource alterado.
- **003:** conferir a prévia real em aplicativo de mensagem (WhatsApp etc.) depois do deploy em `dev.expogeo.com.br`.
- **Painel admin:** não foi conferido na tela na Fase 0, por falta de credenciais de teste. Nenhum arquivo dele mudou.
- **014:** fala em fonte monoespaçada para o código de referência; a 001 decidiu usar Figtree 600 com algarismos tabulares (a 009 já foi corrigida).
- **Painel admin:** também não conferido nas Fases 1 e 2; nenhum arquivo dele mudou.
- **016:** PNGs das ilustrações e botões antigos (`PrimaryButton`/`SecondaryButton`, ainda no painel) saem na limpeza.

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
