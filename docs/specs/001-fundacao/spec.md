# 001. Fundação visual (tokens, fontes e breakpoints)

- **Status:** implementada
- **Item do planejamento:** Fase 0, entregas 0.1, 0.2 e 0.3
- **Protótipo:** aba "Fundamentos" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

> A Fase 0 foi dividida em três specs: **001** Fundação (esta), **002** Botões, navbar e rodapé (0.4 a 0.6), **003** `index.html` e ilustrações otimizadas (0.7 e 0.8). O item 0.0 (ambiente de testes) segue o [plano de CI/CD](../../cicd/planejamento.md), fora do fluxo SDD.

## Objetivo
Dar à expoGEO a mesma base visual do Observatório (cores, fontes, espaçamentos e faixas de largura), mais o degradê que é assinatura da expoGEO, para que as telas novas sejam construídas em cima dela. Quem usa o site **não vê mudança nenhuma** com esta entrega.

## Situação atual
- Tokens em `lib/core/theme/` (`AppTheme.colors`, `.dimensions`, `.typography`, `app_gradients`). O laranja de destaque é `#F97316`, que tem 2,8:1 no branco.
- Todo texto usa a Aleo pelo pacote `google_fonts` (baixada em tempo de execução), embora os arquivos também estejam em `assets/fonts/`.
- Tamanhos de texto e espaçamentos escalam com a largura da tela (`num_extension`, em 31 arquivos).
- `ScreenUtils` (`core/utils/screen/screen_utils.dart`) não tem largura máxima de conteúdo.

## Comportamento

### Cores e degradê (0.1)
Entram valores novos **ao lado** dos atuais, iguais aos do Observatório (`../observatorio_geo_hist/lib/app/theme/`). Nenhum valor atual muda ou sai.

| Uso | Valor |
|---|---|
| Fundo da página | `#FFFFFF` |
| Superfície (blocos alternados) | `#F7F5F2` |
| Texto principal | `#1F1B18` |
| Texto secundário | `#5E5852` |
| Linhas e bordas | `#E6E1DA` |
| Acento (tudo que é clicável) | `#C94400` |
| Acento forte (hover; texto laranja sobre superfície e acento suave) | `#A33600` |
| Acento suave (fundos de ícone, filtro ativo) | `#FFF0E6` |
| Rodapé: fundo / linha / texto / destaque | `#1C1917` / `#37322E` / `#D8D2CA` / `#FF9A62` |
| Erro | `#B3261E` (fundo suave `#FBE9E7`) |
| Sucesso (texto / fundo) | `#1C6B34` / `#E4F3E8` |
| **Degradê expoGEO** (só decoração) | `#F97316 → #FB923C → #FACC15` |

### Espaçamentos, raios, sombras e foco (0.1)
Os mesmos do Observatório: escala de 4 px (4 a 96), raios de 6 a 20 e pílula, sombra **suave** e **elevada**, foco visível de 3 px na cor de acento afastado 2 px.

### Fontes (0.2)
- **Bricolage Grotesque** (600, 700, 800) nos títulos e **Figtree** (400, 500, 600, 700) no texto, **embutidas** em `assets/fonts/` com as licenças OFL. Copiar os arquivos do Observatório.
- Escala de texto com tamanho fixo por faixa, igual à do Observatório (h1 32/40/52, h2 26/30/36, h3 18/20/20, leitura 17/18/18, padrão 16, pequeno 14, rótulo 12,5/12,5/13).
- Um estilo para o código de referência (ex.: `NMA_BH_03`), usado na ficha, no painel e no editor: **Figtree 600 com algarismos tabulares**, sem arquivo novo. O Flutter web não acessa fontes do sistema, então uma monoespaçada "do sistema" cairia numa fonte proporcional baixada da internet; embutir uma monoespaçada fica para a spec que exigir de fato (009 ou 014).
- Os estilos antigos (Aleo) continuam como estão até a limpeza (spec 016).

### Breakpoints e largura de conteúdo (0.3)
- Celular < 600, tablet 600–1023, desktop ≥ 1024.
- Largura máxima de conteúdo de **1120 px**, centralizada; margem lateral de **20 px** no celular e **32 px** do tablet para cima.
- As funções de faixa existentes continuam respondendo o mesmo.

## Estados
Não se aplica: nenhuma tela é criada.
- **Casos de borda:** fonte que falha cai para a do sistema sem quebrar o layout; acima de 1120 px o conteúdo fica centralizado; 599/600 e 1023/1024 trocam de faixa sem tamanho intermediário.

## Responsivo
Cada valor novo tem uma versão por faixa (390, 768 e 1280 px) e não muda com a altura nem com a orientação.

## Acessibilidade
- Contraste ≥ 4,5:1 nos pares: texto principal, secundário e acento sobre branco; texto secundário sobre a superfície; texto e destaque do rodapé sobre `#1C1917`; erro sobre branco; sucesso sobre o fundo de sucesso.
- Regra herdada do Observatório: sobre a superfície `#F7F5F2` e o acento suave `#FFF0E6`, texto e ícone laranja usam o **acento forte** `#A33600`.
- O degradê nunca fica sob texto nem em botões, por isso não entra na conferência de contraste.
- Nenhum texto abaixo de 12,5 px.

## Dados e regras de negócio
- Nenhum dado, modelo ou rota muda.
- Nenhum valor antigo do tema é removido nem alterado (o painel depende deles até a Fase 4).
- Nomes novos distintos dos antigos, para ninguém confundir os dois.

## Critérios de aceite
- [ ] O app compila; `fvm flutter analyze` sem avisos novos.
- [ ] Todas as telas atuais e o painel ficam **idênticos** ao que eram.
- [ ] Todas as cores da tabela e o degradê existem no tema com os valores indicados.
- [ ] Espaçamentos, raios, sombras e foco padrão existem no tema; nenhum valor solto no código novo.
- [ ] Bricolage Grotesque e Figtree estão em `assets/fonts/`, declaradas no `pubspec.yaml`, com licenças, e renderizam **sem buscar fonte na internet** (vêm de `assets/fonts/`; nenhuma requisição a `fonts.googleapis.com` ou `fonts.gstatic.com` para essas famílias).
- [ ] Os estilos novos não usam `google_fonts` nem `num_extension`.
- [ ] Uma tela de teste temporária (não commitada) mostra cada estilo em 390, 768 e 1280 px com os tamanhos da tabela.
- [ ] As faixas retornam o valor certo em 390, 599, 600, 768, 1023, 1024 e 1280 px.
- [ ] O conteúdo novo respeita 1120 px e as margens de 20 / 32 px.
- [ ] Os pares de Acessibilidade têm contraste ≥ 4,5:1, com os valores anotados no `verificacao.md`.

## Fora do escopo
- Botões, navbar, rodapé, `index.html` e ilustrações (specs 002 e 003).
- Trocar a fonte das telas antigas ou do painel.
- Remover Aleo, `google_fonts`, `num_extension` ou tokens antigos (spec 016).
- Modo escuro.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
- 2026-10-27 (planejamento, decisão em modo autônomo): estilo do código de referência passa de "monoespaçado do sistema" para Figtree 600 com algarismos tabulares, porque o Flutter web (CanvasKit) não usa fontes do sistema. Critério das fontes reescrito como "sem buscar fonte na internet", porque o app inteiro depende de rede para abrir (CanvasKit via CDN) e o teste literal não se aplica.
- 2026-10-27: implementada.
