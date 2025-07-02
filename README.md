# MovieFinder

Um aplicativo iOS nativo para busca e descoberta de filmes, desenvolvido com UIKit e arquitetura MVVM. O app consome a API The Movie Database (TMDb) para fornecer informações detalhadas sobre filmes, incluindo busca, listagem em grid, detalhes completos e sistema de favoritos com armazenamento local.

## 🎬 Funcionalidades

- **Busca de Filmes**: Interface intuitiva para buscar filmes por título
- **Listagem em Grid**: Visualização organizada dos resultados de busca
- **Detalhes Completos**: Informações detalhadas incluindo sinopse, avaliações e dados financeiros
- **Sistema de Favoritos**: Salvar e gerenciar filmes favoritos com persistência local
- **Cache de Imagens**: Carregamento otimizado de posters com cache automático
- **Interface Responsiva**: Design adaptável para diferentes tamanhos de tela

## 🏗️ Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)** com as seguintes camadas:

### Camadas da Aplicação

- **Views**: Interface do usuário (ViewControllers e Views customizadas)
- **ViewModels**: Lógica de apresentação e gerenciamento de estado
- **Services**: Camada de negócio e acesso a dados
- **Network**: Gerenciamento de requisições HTTP e cache
- **Models**: Estruturas de dados da aplicação
- **Extensions**: Extensões úteis para classes do sistema

### Padrões Utilizados

- **MVVM**: Separação clara entre lógica de apresentação e interface
- **Singleton**: Para serviços compartilhados (NetworkManager, ImageLoader)
- **Protocol-Oriented Programming**: Interfaces bem definidas
- **Dependency Injection**: Injeção de dependências via inicializadores
- **GCD (Grand Central Dispatch)**: Concorrência e operações assíncronas

## 📱 Telas e Navegação

### MainTabBarController
- **Search Tab**: Busca de filmes
- **Favorites Tab**: Lista de filmes favoritos

### Search Flow
1. **MovieSearchViewController**: Interface de busca
2. **MovieResultsViewController**: Resultados em grid
3. **MovieDetailViewController**: Detalhes completos do filme

### Favorites Flow
1. **FavoritesViewController**: Lista de favoritos salvos
2. **MovieDetailViewController**: Detalhes do filme favorito

## 🛠️ Tecnologias e Dependências

- **UIKit**: Interface nativa iOS
- **Foundation**: Funcionalidades básicas do sistema
- **URLSession**: Requisições HTTP
- **GCD**: Concorrência e operações assíncronas

## 📦 Instalação

### Pré-requisitos
- Xcode 14.0+
- iOS 15.0+
- Swift 5.7+

### Configuração da API
1. Obtenha uma API key gratuita em [The Movie Database](https://www.themoviedb.org/settings/api)
2. Abra o arquivo `MovieFinder/Config/APIConfig.swift`
3. Substitua `YOUR_API_KEY_HERE` pela sua chave da API

```swift
struct APIConfig {
    static let apiKey = "YOUR_API_KEY_HERE"
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
}
```

### Executando o Projeto
1. Clone o repositório
2. Abra `MovieFinder.xcodeproj` no Xcode
3. Configure sua API key
4. Selecione um simulador ou dispositivo
5. Execute o projeto (⌘+R)

## 🏛️ Estrutura do Projeto

```
MovieFinder/
├── AppConfig/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── MainTabBarController.swift
├── Config/
│   └── APIConfig.swift
├── Models/
│   └── Movie.swift
├── Network/
│   ├── NetworkManager.swift
│   ├── NetworkError.swift
│   ├── ServiceRequest.swift
│   └── ImageLoader.swift
├── Services/
│   ├── MovieService.swift
│   └── FavoritesService.swift
├── Views/
│   ├── Search/
│   │   ├── MovieSearchView.swift
│   │   └── MovieSearchViewController.swift
│   ├── Results/
│   │   ├── MovieResultsView.swift
│   │   ├── MovieResultsViewController.swift
│   │   └── Cell/
│   │       └── MovieGridCell.swift
│   ├── Detail/
│   │   ├── MovieDetailView.swift
│   │   └── MovieDetailViewController.swift
│   └── Favorites/
│       ├── FavoritesView.swift
│       └── FavoritesViewController.swift
├── ViewModels/
│   ├── MovieSearchViewModel.swift
│   ├── MovieResultsViewModel.swift
│   ├── MovieDetailViewModel.swift
│   └── FavoritesViewModel.swift
└── Extensions/
    ├── String+DateFormat.swift
    └── UIViewController+Extensions.swift
```

## 🔧 Componentes Principais

### Network Layer
- **NetworkManager**: Gerenciador central de requisições HTTP
- **ImageLoader**: Carregamento e cache de imagens
- **NetworkError**: Tratamento padronizado de erros
- **ServiceRequest**: Configuração de requisições

### Services
- **MovieService**: Operações relacionadas a filmes (busca, detalhes)
- **FavoritesService**: Gerenciamento de favoritos com persistência

### ViewModels
- **MovieSearchViewModel**: Lógica da tela de busca
- **MovieResultsViewModel**: Gerenciamento dos resultados
- **MovieDetailViewModel**: Lógica dos detalhes do filme
- **FavoritesViewModel**: Gerenciamento da lista de favoritos

### Views
- **MovieGridCell**: Célula customizada para grid de filmes
- **MovieSearchView**: Interface de busca
- **MovieResultsView**: Layout dos resultados
- **MovieDetailView**: Interface de detalhes
- **FavoritesView**: Lista de favoritos

## 🧪 Testes

O projeto inclui uma suíte completa de testes unitários seguindo o padrão MVVM e utilizando XCTest framework com mocking adequado e injeção de dependências.

### 📋 Cobertura de Testes

A suíte de testes cobre:
- **Modelos**: Validação e serialização do modelo Movie
- **Serviços**: MovieService e FavoritesService com integração de API e persistência
- **ViewModels**: Lógica de negócio de todas as telas (busca, resultados, detalhes, favoritos)
- **Integração**: Tratamento de erros, operações assíncronas e fluxos de usuário

### 🚀 Executando os Testes

#### No Xcode
1. Abra o arquivo `MovieFinder.xcodeproj`
2. Selecione o target `MovieFinderTests`
3. Pressione ⌘+U para executar todos os testes

#### Via Linha de Comando
```bash
# Executar todos os testes
xcodebuild test -project MovieFinder.xcodeproj -scheme MovieFinder -destination 'platform=iOS Simulator,name=iPhone 15'
```

### 📚 Documentação Detalhada

Para informações completas sobre a estratégia de testes, arquivos de teste, classes mock, padrões utilizados e exemplos específicos, consulte o arquivo `MovieFinderTests/README_Tests.md`.

## 📊 Modelo de Dados

### Movie
```swift
struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let budget: Int?        // Opcional - disponível em detalhes
    let revenue: Int?       // Opcional - disponível em detalhes
}
```

## 🔄 Fluxo de Dados

1. **Busca**: UserInput → ViewModel → Service → API → UI Update
2. **Detalhes**: Movie Selection → ViewModel → Service → API → UI Update
3. **Favoritos**: User Action → ViewModel → Service → Local Storage → UI Update

## 🎨 Interface do Usuário

- **Design Nativo**: Seguindo as diretrizes de design do iOS
- **Responsivo**: Adaptável a diferentes tamanhos de tela
- **Performance**: Carregamento otimizado e cache inteligente

## 🚀 Melhorias Futuras

- [ ] Suporte a diferentes idiomas (Localization)
- [ ] Widgets para iOS
- [ ] Testes de UI automatizados
- [ ] Animações e transições suaves
- [ ] Busca por filtros (gênero, ano, avaliação)
- [ ] Recomendações baseadas em favoritos

## 📄 Licença

Este projeto é desenvolvido para fins educacionais e de demonstração.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir novas funcionalidades
- Enviar pull requests
- Melhorar a documentação

---

**Desenvolvido com ❤️ usando Swift e UIKit** 