# 003. `index.html`, ícones e ilustrações otimizadas

- **Status:** aprovada
- **Item do planejamento:** Fase 0, entregas 0.7 e 0.8
- **Protótipo:** não tem aba própria; segue o Observatório (`../observatorio_geo_hist/docs/specs/003-index-carregamento/`)
- **Criada em:** 2026-10-27

## Objetivo
Fazer a expoGEO se apresentar direito antes do Flutter carregar (título, descrição, ícones e uma tela de carregamento com a marca) e deixar as ilustrações de temas e subtemas leves o bastante para a Home e as grades novas, que mostram várias de uma vez.

## Situação atual
- `web/index.html`: `<title>expogeo</title>`, descrição "A new Flutter project.", `apple-mobile-web-app-title` "expogeo". A tag do Analytics fica entre `<!-- analytics:inicio -->` e `<!-- analytics:fim -->` (o deploy do dev remove esse trecho).
- `web/manifest.json` com nome e cores padrão do Flutter. Ícones em `web/icons/` e `web/favicon.png` (69 KB).
- Antes do Flutter carregar, a tela fica branca.
- As ilustrações de temas e subtemas e os logos de apoio em `assets/images/` são PNGs, muitos com 400 KB ou mais.

## Comportamento

### Cabeçalho e ícones (0.7)
- Título da aba: **"expoGEO · Curadoria digital do saber geográfico"**.
- Descrição: "Conteúdos digitais de Geografia escolhidos para a sala de aula: sites, vídeos, mapas e aplicativos organizados por tema, com a curadoria do Observatório do Ensino de História e Geografia da UFU."
- Metadados de compartilhamento (`og:title`, `og:description`, `og:image` com o logo, `og:locale` pt_BR) e `lang="pt-BR"`.
- `manifest.json` com nome "expoGEO", nome curto "expoGEO", cor de tema `#C94400` e fundo `#FFFFFF`.
- Favicon e ícones gerados a partir do `logo_simple.png`, com versão "maskable", e favicon leve (≤ 10 KB).
- O trecho do Analytics continua entre os mesmos marcadores.

### Tela de carregamento inicial (0.7)
- Enquanto o Flutter carrega: fundo branco, símbolo da expoGEO centralizado e um indicador discreto no acento.
- Some assim que o primeiro quadro do app aparece, sem piscar.
- Com "reduzir movimento", o indicador não anima.

### Ilustrações (0.8)
- Gerar versões **WebP** das ilustrações de temas e subtemas em até 512 × 512 px, mirando ≤ 60 KB cada, sem cortar a ilustração (continuam redondas e inteiras).
- O app passa a usar as versões WebP. Os PNGs originais saem do pacote do app só na limpeza (spec 016), para não quebrar o painel e as telas antigas antes da hora.
- Logos de apoio (UFU, FACED, PPGED, FAPEMIG, CAPES, CNPq) também ganham versão leve, sem perder nitidez em tela de alta densidade.

## Estados
- **Imagem com falha:** não se aplica aqui; o tratamento fica no componente de medalhão (spec 004).
- **Casos de borda:** navegador sem suporte a WebP é desprezível para o público (todos os navegadores atuais suportam); não há fallback.

## Responsivo
A tela de carregamento fica centralizada em 390, 768 e 1280 px.

## Acessibilidade
- `lang="pt-BR"` no documento.
- A tela de carregamento tem texto alternativo ("Carregando a expoGEO") para leitores de tela.

## Dados e regras de negócio
- Nenhum dado ou rota muda.
- Os marcadores do Analytics não mudam de nome (o `deploy-dev.yml` depende deles).

## Critérios de aceite
- [ ] A aba do navegador mostra o título e o favicon novos.
- [ ] Colar o endereço num aplicativo de mensagem mostra título, descrição e imagem.
- [ ] O `manifest.json` tem nome, nome curto e cores novos; os ícones "maskable" existem.
- [ ] Ao abrir o site com a rede lenta (throttling), aparece o símbolo em vez da tela branca, e ele some sem piscar.
- [ ] O trecho do Analytics continua entre `<!-- analytics:inicio -->` e `<!-- analytics:fim -->`, e o build do dev o remove.
- [ ] Todas as ilustrações de temas e subtemas têm versão WebP ≤ 512 px; a soma delas é pelo menos 80% menor que a dos PNGs.
- [ ] As telas atuais mostram as ilustrações WebP sem corte nem perda visível.

## Fora do escopo
- Remover os PNGs antigos (spec 016).
- Trocar o desenho das ilustrações ou do logo.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: aprovada.
