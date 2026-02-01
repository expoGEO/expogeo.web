# expoGEO: Exposição Geográfica

## 📋 Visão Geral

ExpoGEO é uma aplicação web educacional interativa focada no ensino de Geografia. O projeto apresenta diferentes temas geográficos através de uma interface visual e dinâmica, utilizando cards em carrossel que os usuários podem explorar.

## 🎯 Objetivo

Proporcionar uma experiência de aprendizado dinâmica e visual sobre os principais temas da Geografia, permitindo que estudantes explorem conceitos de forma interativa e organizada.

## 🏗️ Estrutura do Projeto

```
src/
├── components/
│   ├── ui/              # Componentes shadcn-ui reutilizáveis
│   │   ├── carousel.tsx # Componente de carrossel (Embla)
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   └── ...
│   ├── Footer.tsx       # Rodapé da aplicação
│   ├── Navbar.tsx       # Barra de navegação
│   ├── ThemeCard.tsx    # Card individual de tema
│   ├── ThemeCarousel.tsx # Carrossel de temas da home
│   ├── SubthemeCard.tsx # Card de subtemas (páginas internas)
│   └── subtheme-cards.css # Estilos dos cards de subtemas
├── pages/
│   ├── Index.tsx        # Página inicial
│   ├── ThemePage.tsx    # Página de detalhes de tema
│   └── NotFound.tsx     # Página 404
├── hooks/
│   ├── use-mobile.tsx   # Hook para detecção mobile
│   └── use-toast.ts     # Hook para notificações
├── lib/
│   └── utils.ts         # Funções utilitárias
├── App.tsx              # Componente raiz com rotas
├── index.css            # Estilos globais e design tokens
└── main.tsx             # Ponto de entrada da aplicação
```

## 🎨 Tecnologias Utilizadas

### Core
- **React 18.3.1** - Biblioteca JavaScript para UI
- **TypeScript** - Tipagem estática
- **Vite** - Build tool e dev server
- **React Router DOM 6.26.2** - Roteamento

### UI/Estilo
- **Tailwind CSS** - Framework CSS utility-first
- **shadcn-ui** - Componentes acessíveis e customizáveis
- **Lucide React** - Ícones
- **class-variance-authority** - Gerenciamento de variantes de componentes
- **tailwind-merge & clsx** - Manipulação de classes CSS

### Carrossel
- **embla-carousel-react 8.3.0** - Motor de carrossel
- **embla-carousel-autoplay 8.3.0** - Plugin de autoplay

### Formulários e Estado
- **React Hook Form** - Gerenciamento de formulários
- **Zod** - Validação de schemas
- **@tanstack/react-query** - Gerenciamento de estado assíncrono

### Outros
- **Sonner & Toast** - Sistema de notificações
- **Recharts** - Gráficos (se necessário no futuro)

## 🎯 Funcionalidades Principais

### 1. Página Inicial (/)

**Componentes:**
- Banner com logo ExpoGEO
- Título e descrição do projeto
- Carrossel de temas com autoplay no hover

**Características:**
- Gradiente laranja/amarelo de fundo
- Banner com fundo branco semi-transparente e blur
- Cards responsivos (mobile: 1 por vez, tablet: 2, desktop: 3)
- Autoplay ativado apenas ao passar mouse sobre o carrossel
- Navegação com setas (ocultas no mobile)

### 2. Carrossel de Temas

**Arquivo:** `src/components/ThemeCarousel.tsx`

**Comportamento:**
- **Desktop/Tablet:** Mostra múltiplos cards (2-3) simultaneamente
- **Mobile:** Mostra 1 card por vez
- **Autoplay:** 
  - Não inicia automaticamente ao carregar
  - Ativa ao hover do mouse (`onMouseEnter`)
  - Para ao tirar o mouse (`onMouseLeave`)
  - Para ao interagir manualmente
  - Delay de 2500ms entre slides
- **Loop infinito** habilitado

**Configuração:**
```typescript
Autoplay({ 
  delay: 2500, 
  stopOnInteraction: true, 
  playOnInit: false 
})
```

### 3. Cards de Temas

**Arquivo:** `src/components/ThemeCard.tsx`

**Dados dos Temas:**
```typescript
THEME_DETAILS = [
  {
    title: "Representações Espaciais",
    description: "Mapas, GPS, coordenadas...",
    image: "/lovable-uploads/...",
    link: "/representacoes"
  },
  {
    title: "Meio Ambiente e Sustentabilidade",
    description: "Biodiversidade, aquecimento...",
    image: "/lovable-uploads/...",
    link: "/meio-ambiente"
  },
  {
    title: "Espaços Urbanos e Transformações",
    description: "Urbanização, mobilidade...",
    image: "/lovable-uploads/...",
    link: "/espacos-urbanos"
  },
  {
    title: "Cultura, Identidade e Política",
    description: "Migrações, diversidade...",
    image: "/lovable-uploads/...",
    link: "/cultura-politica"
  }
]
```

**Características:**
- Imagem de fundo específica para cada tema
- Título e descrição
- Link para página de detalhes
- Design responsivo
- Efeitos hover

### 4. Páginas de Temas

**Arquivo:** `src/pages/ThemePage.tsx`

**Funcionalidade:**
- Renderiza detalhes de um tema específico
- Mostra subtemas relacionados usando `SubthemeCard`
- Navegação entre temas
- Ícones específicos para subtemas (ex: representacoesIcons)

**Rotas Configuradas:**
- `/representacoes`
- `/meio-ambiente`
- `/espacos-urbanos`
- `/cultura-politica`

### 5. Sistema de Navegação

**Arquivo:** `src/components/Navbar.tsx`
- Navegação principal da aplicação
- Links para diferentes seções

**Arquivo:** `src/components/Footer.tsx`
- Rodapé com informações adicionais

## 🎨 Design System

### Cores (index.css)

O projeto utiliza tokens semânticos HSL definidos em `src/index.css`:

```css
:root {
  --primary: [cor principal]
  --secondary: [cor secundária]
  --accent: [cor de destaque]
  --background: [cor de fundo]
  --foreground: [cor de texto]
  /* ... outros tokens */
}
```

**Importante:** Sempre usar tokens semânticos, não cores diretas como `text-white` ou `bg-black`.

### Gradientes

```css
--gradient: bg-gradient-to-tr from-orange-400 via-orange-500 to-yellow-400
```

### Animações

O projeto possui animações configuradas em `tailwind.config.ts`:
- `fade-in` / `fade-out`
- `scale-in` / `scale-out`
- `slide-in-right` / `slide-out-right`
- `accordion-down` / `accordion-up`

**Classes de utilidade:**
- `.hover-scale` - Escala no hover
- `.story-link` - Animação de sublinhado
- `.pulse` - Pulsação

## 📱 Responsividade

### Breakpoints Tailwind
- `sm:` 640px (tablet)
- `md:` 768px
- `lg:` 1024px (desktop)

### Comportamentos Responsivos

**ThemeCarousel:**
- Mobile: `basis-full` (1 card)
- Tablet: `sm:basis-1/2` (2 cards)
- Desktop: `lg:basis-1/3` (3 cards)
- Botões de navegação: `hidden sm:flex`

**Banner (Index.tsx):**
- Logo: `h-28 sm:h-32 md:h-36`
- Título: `text-3xl sm:text-4xl md:text-5xl`
- Padding: `px-2 sm:px-8`

## 🔧 Configuração e Execução

### Instalação
```bash
npm install
```

### Desenvolvimento
```bash
npm run dev
```

### Build
```bash
npm run build
```

### Preview
```bash
npm run preview
```

## 📝 Convenções do Código

### Componentes
- Usar TypeScript com tipagem explícita
- Componentes funcionais com React Hooks
- Exportação default para componentes de página
- Exportação named para componentes reutilizáveis

### Estilização
- Tailwind classes para estilização
- Tokens semânticos do design system
- Classes utilitárias do tailwind.config.ts
- CSS modules apenas quando necessário (ex: subtheme-cards.css)

### Rotas
- Usar React Router DOM v6
- Rotas específicas antes da rota catch-all `*`
- Componente `NotFound` para rotas não encontradas

## 🚀 Próximos Passos Sugeridos

1. **Backend (Lovable Cloud):**
   - Sistema de autenticação
   - Banco de dados para conteúdo
   - Armazenamento de progresso do usuário

2. **Funcionalidades:**
   - Sistema de busca
   - Favoritos
   - Quiz interativo por tema
   - Área de anotações

3. **Conteúdo:**
   - Expandir subtemas
   - Adicionar vídeos e mídia
   - Recursos downloadáveis
   - Mapas interativos

4. **UX/UI:**
   - Dark mode
   - Animações mais elaboradas
   - Feedback visual de progresso
   - Acessibilidade aprimorada

## 📚 Recursos Úteis

- [Lovable Docs](https://docs.lovable.dev/)
- [React Router Docs](https://reactrouter.com/)
- [Tailwind CSS Docs](https://tailwindcss.com/)
- [shadcn-ui Docs](https://ui.shadcn.com/)
- [Embla Carousel Docs](https://www.embla-carousel.com/)

## 📄 Licença

Este projeto foi criado com Lovable.

---

**Última atualização:** 2025-10-07
