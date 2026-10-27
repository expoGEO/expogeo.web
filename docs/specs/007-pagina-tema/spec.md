# 007. Página do tema

- **Status:** aprovada
- **Item do planejamento:** Fase 2, entrega 2.1 (tela T-02)
- **Protótipo:** aba "Tema" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Na página de um tema, a pessoa entende do que ele trata, vê quantos objetos há em cada subtema e escolhe por onde entrar, podendo trocar de tema sem voltar à Home.

## Situação atual
- `features/theme/pages/theme_page.dart` com `ThemeBanner` (ilustração, título e descrição) e `SubthemeGrid` de `SubthemeCard` (nome em caixa alta e botão "Explorar").
- Rotas `/:tema` fixas no `AppRouter` (`/representacoes-espaciais`, `/natureza-meio-ambiente`, `/espacos-urbanos-rurais`, `/cultura-politica`).
- Nenhuma contagem.

## Comportamento

### Cabeçalho
- Fundo de superfície com linha inferior.
- Migalhas "Início › Temas › {Tema}" ("Temas" é texto, não link; o tema atual marcado).
- Título do tema (`h1`), descrição real do tema e as contagens "**N** subtemas" e "**N** objetos digitais".
- Medalhão grande do tema à direita (180 px no desktop).

### Subtemas
- Título com a contagem: "7 subtemas" (singular quando for 1).
- Grade de cartões de subtema. Cada cartão: medalhão do subtema, nome em **caixa normal** e "N objetos" (singular quando for 1). Cartão inteiro clicável, leva ao subtema; hover com borda no acento e elevação.
- Ordem dos subtemas: a do `ThemeDataModel`.

### Outros temas
- No fim, rótulo "Outros temas" e chips com mini-medalhão e o nome dos outros 3 temas, cada um levando ao seu tema.

## Estados
- **Carregando:** cabeçalho e cartões aparecem na hora (vêm do código); as contagens de objetos mostram esqueleto curto. Se a página precisar esperar os dados por inteiro, usa o esqueleto de medalhões do protótipo (aba "Estados", "Carregando os subtemas").
- **Erro nas contagens:** os cartões mostram só o nome (sem "N objetos") e o cabeçalho omite "N objetos digitais". Sem bloqueio de navegação.
- **Vazio:** subtema sem objetos no Firestore (não acontece nos dados de hoje) mostra "Nenhum objeto ainda" no cartão e continua clicável.
- **Sem imagem / falha:** placeholder do medalhão.
- **Tema inexistente** (`/qualquer-coisa`): 404 (spec 011).
- **Casos de borda:** nome de subtema longo ("Estruturas e Formas do Relevo") quebra em até 2 linhas centralizadas; tema com 12 subtemas não estica cartões desiguais (altura igual por linha).

## Responsivo
- **390:** cabeçalho com o medalhão (96 px) acima do texto; grade em **2 colunas**; chips de outros temas quebram linha.
- **768:** cabeçalho em uma coluna com medalhão acima; grade em 3 colunas.
- **1280:** cabeçalho em duas colunas; grade em 4 colunas (cartões de ~220 px no mínimo).

## Acessibilidade
- `h1` com o nome do tema; "N subtemas" e "Outros temas" como `h2`; nome do subtema no cartão como `h3`.
- Migalhas com nome "Você está em".
- Medalhões decorativos dentro de cartões com nome (sem texto alternativo repetido).
- Cartões e chips com foco visível e um ponto de foco cada.
- Item "Temas" ativo na navbar.

## Dados e regras de negócio
- Título, descrição, subtemas e ilustrações: `ThemeDataModel`.
- Contagens por subtema e por tema: do catálogo único da spec 004 (Q-04). A soma por subtema bate com o "N objetos digitais" do cabeçalho e com o cartão do tema na Home.
- Rotas atuais continuam iguais.

## Critérios de aceite
- [ ] As 4 rotas de tema abrem direto pelo endereço com cabeçalho, migalhas, descrição real, contagens e medalhão.
- [ ] O título da grade mostra o número certo de subtemas, com singular/plural.
- [ ] Cada cartão mostra medalhão, nome em caixa normal e "N objetos" igual ao do Firestore do dev, e leva ao subtema.
- [ ] A soma dos cartões é igual ao "N objetos digitais" do cabeçalho e ao cartão do tema na Home.
- [ ] "Outros temas" mostra os outros 3 temas e leva a cada um.
- [ ] Contagens com esqueleto ao carregar e somem sem quebrar a página quando a consulta falha.
- [ ] Ilustração ausente mostra o placeholder.
- [ ] Em 390 px a grade tem 2 colunas; em 768, 3; em 1280, 4. Sem rolagem horizontal nem `overflow`.
- [ ] Navegação por teclado por migalhas, cartões e chips, com foco visível; contraste ≥ 4,5:1.

## Fora do escopo
- Página do subtema (spec 008).
- Editar descrição ou ilustração de tema pelo painel.

## Perguntas em aberto
- Nenhuma. (Respondida: Q-04, catálogo único da spec 004.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-04 respondida.
- 2026-10-27: aprovada.
