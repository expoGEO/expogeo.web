# 🌍 expoGEO: Exposição Geográfica

## 📋 Visão Geral

ExpoGEO é uma aplicação educacional interativa focada no ensino de Geografia. O projeto apresenta diferentes temas geográficos através de uma interface visual e dinâmica, com suporte completo para mobile, tablet e desktop.

## 🎯 Objetivo

Proporcionar uma experiência de aprendizado dinâmica e visual sobre os principais temas da Geografia, permitindo que estudantes explorem conceitos de forma interativa e organizada, com gerenciamento dinâmico de conteúdos via painel administrativo.

---

## 🏗️ Estrutura do Projeto

```
├── lib/
│   ├── main.dart                    # Ponto de entrada da aplicação
│   ├── firebase_options_dev.dart    # Configuração Firebase (dev)
│   ├── firebase_options_prod.dart   # Configuração Firebase (produção)
│   ├── core/
│   │   ├── components/              # Componentes reutilizáveis
│   │   ├── content/                 # Lógica de conteúdo compartilhada
│   │   ├── models/                  # Modelos de dados
│   │   ├── navigation/              # Sistema de navegação
│   │   ├── pages/                   # Páginas principais
│   │   ├── theme/                   # Temas e estilos
│   │   └── utils/                   # Funções utilitárias
│   └── features/
│       ├── admin/                   # Painel administrativo
│       │   ├── panel/               # Interface de admin
│       │   ├── infra/               # Camada de dados
│       │   └── presentation/        # Camada de apresentação
│       └── theme/
│           ├── infra/               # Datasource, Repository, Models
│           ├── presentation/        # Store MobX, States
│           └── pages/               # Páginas de tema/subtema
├── assets/
│   ├── fonts/                       # Fontes customizadas
│   └── images/                      # Imagens da aplicação
├── docs/                            # Documentação do projeto
├── pubspec.yaml                     # Dependências do projeto
└── analysis_options.yaml            # Configuração Dart Linter
```

---

## 🎨 Tecnologias Utilizadas

### 🔧 Backend & Estado

- **Flutter 3.x** - Framework multiplataforma
- **Firebase/Firestore** - Backend e banco de dados
- **MobX 2.4.0** - Gerenciamento de estado reativo
- **GetIt 7.9.0** - Injeção de dependência

### 🎯 Arquitetura

- **Clean Architecture** - 3 camadas: Infra, Repository, Presentation
- **Dartz 0.10.1** - Either para tratamento funcional de erros
- **Sealed Classes** - Type-safe state management

### 🎨 UI/Design

- **Flutter Material 3** - Design system moderno
- **Responsive Design** - Suporte mobile, tablet, desktop
- **Custom Styling** - Temas configuráveis

### 📦 Outras Dependências

- `cloud_firestore: ^5.7.0` - Acesso ao Firestore
- `firebase_core: ^3.7.0` - Core do Firebase
- `firebase_auth: ^5.7.0` - Autenticação Firebase
- `flutter_mobx: ^2.1.1` - Integração MobX com Flutter
- `build_runner: *` - Geração de código

---

## 🎯 Funcionalidades Principais

### 1. 🏠 Página Inicial

- **Banner com logo e descrição**
- **Carrossel de temas** com autoplay ao hover
- **Cards responsivos** (1 mobile, 2 tablet, 3 desktop)
- **Navegação intuitiva**

### 2. 📚 Páginas de Temas

- Detalhes de cada tema geográfico
- Subtemas relacionados com ícones específicos
- Navegação entre temas
- Design responsivo

### 3. 🔍 Conteúdos por Subtema

- **Paginação cursor-based** com Firestore
- **Navegação anterior/próxima** com rastreamento de histórico
- **Page history tracking** para navegação bidirecional
- **Estados reativos** (loading, error, success)
- **Tratamento de erros** com mensagens descritivas

### 4. 🛠️ Painel Administrativo (`/admin`)

- **Criar, editar e deletar temas**
- **Gerenciar subtemas dinamicamente**
- **Upload de conteúdos com suporte a imagens**
- **Publicação e controle de visibilidade**

---

## 📊 Temas Implementados

```yaml
Tema 1: Representações Espaciais
  - Mapas
  - GPS e Coordenadas
  - Sistemas de Informação Geográfica

Tema 2: Meio Ambiente e Sustentabilidade
  - Biodiversidade
  - Aquecimento Global
  - Energias Renováveis

Tema 3: Espaços Urbanos e Transformações
  - Urbanização
  - Mobilidade Urbana
  - Desenvolvimento Sustentável

Tema 4: Cultura, Identidade e Política
  - Migrações
  - Diversidade Cultural
  - Geopolítica
```

---

## 🚀 Configuração e Execução

### 📋 Pré-requisitos

- Flutter SDK 3.x instalado
- Dart SDK 3.x
- Git
- Conta Firebase configurada

### 💻 Instalação

```bash
# Clonar repositório
git clone <repo-url>
cd expogeo.web

# Instalar dependências
flutter pub get

# Gerar código (datasources, stores, etc)
flutter pub run build_runner build

# Rodar a aplicação (web)
flutter run -d chrome

# Ou em outro dispositivo
flutter run -d <device-id>
```

### 🔥 Configuração Firebase

```bash
# Instalar CLI do Firebase
npm install -g firebase-tools

# Login no Firebase
firebase login

# Configurar FlutterFire
flutterfire configure

# Fazer seed do banco de dados
./run_seed.sh dev   # ou prod, com confirmação
```

### 🏗️ Build para Produção

```bash
flutter build web --release
```

---

## 📱 Responsividade

### Breakpoints

- **Celular**: < 600 px
- **Tablet**: 600 a 1023 px
- **Desktop**: ≥ 1024 px

Faixas em `ScreenUtils` (`lib/core/utils/screen/`). Os componentes novos usam tamanhos fixos por faixa e a caixa de conteúdo de 1120 px (`PageContent`), sem escalar pela largura da tela.

### Adaptações por Device

- **Carrossel**: Ajusta quantidade de cards visíveis
- **Navegação**: Botões ocultos em mobile
- **Padding/Margins**: Dinâmicos conforme viewport
- **Tipografia**: Escalas proporcionais

---

## 🎨 Design System

O redesign (em andamento, ver [planejamento](docs/redesign/planejamento.md)) usa a base visual do Observatório. Tokens novos convivem com os antigos até a limpeza final.

- **Tokens:** `AppTheme.colors` (`page`, `ink`, `accent`...), `.dimensions` (`spacing`, `radii`, `shadows`, `focus`), `AppGradients.brand` (degradê decorativo, nunca sob texto pequeno ou botões) e `AppTheme.typography.of(context)`, com tamanhos por faixa de largura.
- **Fontes:** Bricolage Grotesque (títulos) e Figtree (texto), embutidas em `assets/fonts/`.
- **Clicável:** `#C94400`, com foco visível e contraste mínimo de 4,5:1.
- **Estrutura das páginas públicas:** `SiteScaffold` (faixa do Observatório que rola, navbar fixa com menu Temas e rodapé escuro) em `lib/core/components/structure/`.
- **Componentes:** `AppButton.primary/.secondary/.ghost` (com `isLoading`, que mostra o indicador e ignora toques durante uma ação) e `InlineLink` (`components/button/`), `FormTextField` (com senha, sufixo dentro da caixa e dica) e `FormErrorAlert` (`components/form/`), para formulários do site e do painel, o segundo como aviso único acima dos campos, `AppMedallion` (`components/image/`), para ilustrações de temas em 1:1 com placeholder, `StateMessageBox`, `StateErrorBox` e `StateErrorInline` (`components/state/`), para vazio, busca sem resultado, erro de página e erro de seção, e `AppSkeleton` e `LoadingRegion` (`components/skeleton/`), para o carregando, lido uma vez como "Carregando…".
- **Imagens:** ilustrações e logos de apoio em WebP (`AppImages`), gerados pelos scripts de `tool/images/`; ícones e imagem de compartilhamento por `tool/web_icons/`.

---

## 🏛️ Arquitetura de Código

### Clean Architecture

```
Infra Layer (Datasource)
    ↓
Repository Layer (Abstraction)
    ↓
Presentation Layer (Store + UI)
    ↓
UI Layer (Widgets)
```

### MobX State Management

```dart
@observable
String query = '';

@computed
List<CatalogItem> get results { ... }

@action
void setQuery(String text) { ... }
```

Os objetos vêm de um catálogo único, carregado uma vez por `collectionGroup('contents')`. Busca, filtros e "Carregar mais" do subtema rodam no navegador, sobre esse catálogo.

### Tratamento de Erros

```dart
result.fold(
  (failure) => state = ContentPaginationStateError(failure.message),
  (data) => state = ContentPaginationStateSuccess(data),
);
```

---

## 📝 Convenções do Código

### 📂 Organização de Arquivos

- Componentes compartilhados em `lib/core/`
- Funcionalidades específicas em `lib/features/`
- Objetos do acervo vêm do catálogo único (`lib/features/catalog/`): uma consulta `collectionGroup('contents')`, carregada uma vez e compartilhada pelas telas
- Testes em `test/`, espelhando `lib/` (apoios comuns em `test/support/`)

### 🔤 Nomenclatura

- **Classes**: PascalCase (`ContentThemeDatasource`)
- **Métodos/Variáveis**: camelCase (`getContentsBySubtheme`)
- **Constantes**: camelCase (`defaultPageSize`)
- **Arquivos**: snake_case (`content_theme_datasource.dart`)

### 📚 Documentação

- Usar documentation comments (`///`)
- Documentar métodos públicos
- Explicar lógica complexa com `//`

---

## 🧪 Testes

```bash
# Rodar testes unitários
flutter test

# Cobertura
flutter test --coverage

# Testes de integração
flutter test integration_test/
```

---

## 🔍 Linting e Análise

```bash
# Análise de código
flutter analyze

# Formatação
dart format lib/

# Linter customizado
flutter analyze --no-fatal-infos
```

---

## 📚 Recursos Úteis

- [Flutter Docs](https://flutter.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [MobX Docs](https://mobx.netlify.app/)
- [Clean Architecture Dart](https://resocoder.com/clean-architecture)
- [FlutterFire CLI Setup](https://firebase.flutter.dev/docs/cli/)
