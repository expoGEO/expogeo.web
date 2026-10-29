# 002. Botões, faixa do Observatório, navbar e rodapé

- **Status:** implementada
- **Item do planejamento:** Fase 0, entregas 0.4, 0.5 e 0.6
- **Protótipo:** navbar e rodapé de qualquer aba pública; botões na aba "Fundamentos" (link em docs/specs/README.md)
- **Criada em:** 2026-10-27

## Objetivo
Trocar os componentes que aparecem em todas as páginas (botões, navbar e rodapé) pelos do redesign, deixando clara a ligação com o Observatório. As páginas ainda não redesenhadas continuam funcionando, só com a roupa nova desses componentes.

## Situação atual
- Botões em `core/components/button/` (`primary_button`, `secondary_button`, `back_to_button`, ícones), com o laranja `#F97316` e a Aleo.
- `core/components/structure/navbar.dart`: logo "expoGEO", item "Home" e um item por tema, com ícone; menu de celular próprio.
- `core/components/structure/footer.dart`: rodapé claro com "Conhecimento, Tecnologia e Interatividade.", "Entre em contato" (`expogeoufu@gmail.com`), "Metadados da nossa Curadoria Digital" e "Tese de Doutorado". Sem ligação com o Observatório.

## Comportamento

### Botões (0.4)
Os mesmos do Observatório, nos tokens da spec 001:
- **Primário:** fundo `#C94400`, texto branco; hover `#A33600`.
- **Secundário:** borda e texto na cor do texto principal; hover com fundo escuro e texto branco.
- **Discreto:** texto no acento forte (`#A33600`), sem fundo; hover com fundo acento suave. (O acento normal sobre o acento suave fica em 4,38:1.)
- Tamanho normal e pequeno, ícone opcional antes ou depois do texto (seta, link externo).
- Estado desativado (opacidade reduzida, sem hover, cursor de bloqueio) e foco visível.
- Link externo abre em aba nova e anuncia isso no nome acessível.
- Os botões novos são componentes novos e entram em todas as páginas públicas. O painel admin continua com os botões antigos até ser redesenhado (specs 013 a 015); eles saem na 016. Os botões só de ícone da paginação de conteúdos ficam como estão (grade redesenhada na 008).

### Faixa do Observatório (0.5)
- Faixa escura fina acima da navbar: "Um projeto do Observatório do Ensino de História e Geografia · UFU" e o link "Visitar ↗" (`https://observatoriogeohistoria.net.br/`, aba nova).
- No celular, encurta para "Observatório do Ensino de História e Geografia" + "Visitar ↗".
- Rola junto com a página (só a navbar fica fixa).

### Navbar (0.5)
- Fixa no topo, fundo branco translúcido com desfoque e linha inferior.
- Marca à esquerda: símbolo (`logo_simple.png`), "expo**GEO**" em texto (GEO no acento) e a linha "Curadoria digital do saber geográfico" (some abaixo de 900 px). Leva à Home.
- Itens: **Temas** (menu), **Sobre** (`/sobre`) e **Contato** (`/contato`). À direita, botão discreto "Observatório ↗".
- **Menu Temas:** os 4 temas, cada um com o medalhão, o nome e "N subtemas"; separador e "Ver todos na página inicial" (leva à seção de temas da Home). Abre por clique, por teclado (Enter/Espaço/seta para baixo) e por hover no desktop; fecha com Esc devolvendo o foco ao botão.
- Item ativo em acento com sublinhado: "Temas" nas páginas de tema, subtema e objeto; "Sobre" e "Contato" nas suas páginas.
- **Até 900 px:** botão de menu (ícone) abre um painel lateral (entra pela direita, como no Observatório) com sanfona "Temas" (os 4 temas), "Sobre", "Contato" e "Observatório ↗". O botão diz "Abrir menu" / "Fechar menu".
- Enquanto `/sobre` não existir (spec 006) e `/contato` não tiver rota (spec 010), os itens levam ao 404 atual, que abre com navbar e rodapé e já marca o item ativo pelo endereço; aceitável porque as specs vão em sequência.
- **Medalhão:** o componente de medalhão (ilustração inteira em círculo 1:1, `contain`, fundo branco, borda de linha, placeholder de acento suave com ícone de mapa) nasce nesta spec, porque o menu Temas precisa dele; a 004 o reaproveita.

### Rodapé (0.6)
Rodapé escuro em quatro colunas (duas no tablet, uma no celular):
1. **Marca:** símbolo + "expoGEO" + "Conhecimento, Tecnologia e Interatividade"; endereço "Faculdade de Educação · UFU / Av. João Naves de Ávila, 2121 · Santa Mônica / Uberlândia/MG".
2. **Temas:** os 4 temas.
3. **Curadoria:** Sobre a expoGEO, Metadados da curadoria ↗, Tese de doutorado ↗, Fale com a gente (`/contato`).
4. **Observatório:** Visitar o site ↗, `expogeoufu@gmail.com` (abre o e-mail) e ícones das redes (Instagram, Facebook, YouTube) do Observatório.
- Os logos de apoio que hoje ficam no rodapé saem dele e voltam na seção "Realização e apoio" (spec 006). Nenhum arquivo de imagem é apagado.
- Linha final: "© {ano atual} expoGEO · Desenvolvido para fins educativos" e "Uma iniciativa do Observatório do Ensino de História e Geografia". O ano vem do relógio, não é fixo.

## Estados
- **Carregando:** não se aplica; temas e contagens de subtemas vêm do código (`ThemeDataModel`), sem consulta.
- **Imagem com falha:** medalhão do menu mostra o placeholder de medalhão (fundo acento suave com ícone) no lugar da ilustração.
- **Casos de borda:** nome de tema longo ("Natureza e Meio Ambiente") cabe no menu sem quebrar a contagem; menu aberto + rolagem fecha o menu.

## Responsivo
- **390:** faixa curta, navbar com símbolo + "expoGEO" e botão de menu; rodapé em uma coluna.
- **768:** como o celular na navbar (abaixo de 900 px); rodapé em duas colunas.
- **1280:** navbar completa; rodapé em quatro colunas.

## Acessibilidade
- Navegação completa por teclado na faixa, na navbar, no menu Temas, no painel do celular e no rodapé, com foco visível.
- Botões só de ícone (menu, redes) com nome acessível e dica.
- Menu Temas anuncia expandido/recolhido; a sanfona também.
- Texto do rodapé e destaque com contraste ≥ 4,5:1 sobre `#1C1917`.
- Animações de abrir/fechar respeitam "reduzir movimento".

## Dados e regras de negócio
- Temas e subtemas saem de `ThemeDataModel`; rotas saem das constantes do `AppRouter`.
- Links externos (metadados, tese, Observatório, redes) são os mesmos de hoje.
- A faixa "Ambiente de testes" (`environment_banner`) continua acima de tudo no dev.

## Critérios de aceite
- [ ] Todas as páginas atuais (Home, 4 temas, subtemas, 404) abrem sem erro com faixa, navbar, rodapé e botões novos.
- [ ] Os três botões têm hover, foco visível e estado desativado como descrito.
- [ ] O menu Temas lista os 4 temas com medalhão e "N subtemas" corretos (hoje 7, 12, 6 e 6, conforme `ThemeDataModel`) e leva a cada tema.
- [ ] O menu abre e fecha por teclado e Esc devolve o foco ao botão "Temas".
- [ ] O item ativo aparece em tema, subtema, Sobre e Contato.
- [ ] Até 900 px o botão de menu abre o painel com a sanfona; acima, o painel não aparece.
- [ ] O rodapé mostra as quatro colunas com os links da seção "Rodapé", o ano atual e abre os externos em aba nova.
- [ ] Em 390, 768 e 1280 px não há rolagem horizontal nem `overflow`.
- [ ] Contraste ≥ 4,5:1 em todo texto da faixa, da navbar e do rodapé.
- [ ] Nenhum valor de cor, fonte ou espaçamento solto no código novo.

## Fora do escopo
- Redesenho do conteúdo das páginas (Fases 1 a 3).
- Página `/sobre` (spec 006) e `/contato` (spec 010).
- Busca geral e modo escuro.

## Perguntas em aberto
- Nenhuma. (Respondida: Q-03, o rodapé leva às redes do Observatório, com nome acessível "Instagram do Observatório", "Facebook do Observatório" e "YouTube do Observatório", até a expoGEO ter perfis próprios.)

## Histórico de mudanças
- 2026-10-27: criada.
- 2026-10-27: Q-03 respondida.
- 2026-10-27: aprovada.
- 2026-10-27: ajustes do plano, decididos sem a pessoa (modo autônomo): botão discreto em acento forte, por contraste; botões novos como componentes novos, com o painel mantendo os antigos; painel do celular lateral; medalhão criado aqui em vez da 004; logos de apoio saem do rodapé até a 006; Contato também cai no 404 até a 010; critério do painel com "até 900 px" e do rodapé sem citar uma tabela que não existe.
- 2026-10-29: implementada (sem divergências; a ilustração de Cultura e Política aparece como placeholder no menu porque o arquivo tem acento no nome, caso previsto em "Imagem com falha").
