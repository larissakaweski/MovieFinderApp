# Documentação de Testes do MovieFinder

## Visão Geral
Este documento descreve a suíte abrangente de testes para o aplicativo iOS MovieFinder. Os testes seguem o padrão de arquitetura MVVM e utilizam o framework XCTest com mocking adequado e injeção de dependências.

## Estrutura dos Arquivos de Teste

### 1. MovieFinderTests.swift
**Propósito**: Testes básicos de modelo e projeto
**Cobertura**:
- Criação e validação do modelo Movie
- Testes de igualdade do modelo Movie
- Tratamento do modelo Movie com valores nulos
- Funcionalidades básicas do projeto

**Testes Principais**:
- `testMovieModelCreation()` - Valida a inicialização da struct Movie
- `testMovieModelEquality()` - Testa comparação de igualdade entre instâncias Movie
- `testMovieModelWithNilValues()` - Testa Movie com campos opcionais definidos como nil

### 2. FavoritesServiceTests.swift
**Propósito**: Testa o singleton FavoritesService para gerenciar filmes favoritos
**Cobertura**:
- Adicionar filmes aos favoritos
- Remover filmes dos favoritos
- Verificar se um filme é favorito
- Obter todos os favoritos
- Limpar todos os favoritos
- Tratamento de erros para dados inválidos
- Integração com UserDefaults

**Testes Principais**:
- `testAddToFavorites()` - Testa adicionar um filme aos favoritos
- `testRemoveFromFavorites()` - Testa remover um filme dos favoritos
- `testIsFavorite()` - Testa verificação de status de favorito
- `testGetFavoritesWithInvalidData()` - Testa tratamento de erros para dados corrompidos
- `testSaveFavoritesWithEncodingError()` - Testa cenários de erro de codificação

**Dependências Mock**:
- `MockUserDefaults` - Simula comportamento do UserDefaults para testes

### 3. MovieResultViewModelTests.swift
**Propósito**: Testa o MovieResultViewModel para gerenciamento de resultados de busca
**Cobertura**:
- Funcionalidade de busca de filmes
- Gerenciamento de paginação
- Estados de carregamento
- Tratamento de erros
- Alternância de favoritos
- Limpeza de resultados

**Testes Principais**:
- `testResultMoviesWithEmptyQuery()` - Testa tratamento de consulta de busca vazia
- `testResultMoviesSuccess()` - Testa resultados de busca bem-sucedidos
- `testResultMoviesFailure()` - Testa tratamento de erros de busca
- `testLoadMoreMoviesWhenNoMorePages()` - Testa paginação sem mais páginas
- `testToggleFavorite()` - Testa alternância de favoritos

**Dependências Mock**:
- `MockMovieService` - Simula comportamento do serviço de filmes
- `MockFavoritesService` - Simula comportamento do serviço de favoritos
- `MockMovieResultViewModelDelegate` - Simula callbacks do delegate

### 4. FavoritesViewModelTests.swift
**Propósito**: Testa o FavoritesViewModel para gerenciamento da tela de favoritos
**Cobertura**:
- Carregamento de favoritos
- Remoção de favoritos
- Tratamento de estado vazio
- Propriedades de contagem e isEmpty

**Testes Principais**:
- `testLoadFavorites()` - Testa carregamento de favoritos do serviço
- `testLoadFavoritesEmpty()` - Testa estado de favoritos vazio
- `testRemoveFromFavorites()` - Testa remoção de um favorito
- `testIsEmpty()` - Testa detecção de estado vazio
- `testCount()` - Testa contagem de favoritos

**Dependências Mock**:
- `MockFavoritesService` - Simula comportamento do serviço de favoritos
- `MockFavoritesViewModelDelegate` - Simula callbacks do delegate

### 5. MovieDetailViewModelTests.swift
**Propósito**: Testa o MovieDetailViewModel para gerenciamento da tela de detalhes do filme
**Cobertura**:
- Carregamento de detalhes do filme
- Gerenciamento de status de favorito
- Estados de carregamento
- Tratamento de erros
- Dados detalhados vs dados básicos do filme

**Testes Principais**:
- `testInitialState()` - Testa estado inicial do view model
- `testLoadMovieDetailsSuccess()` - Testa carregamento bem-sucedido de detalhes
- `testLoadMovieDetailsFailure()` - Testa tratamento de erros no carregamento de detalhes
- `testToggleFavoriteAdd()` - Testa adição aos favoritos
- `testToggleFavoriteRemove()` - Testa remoção dos favoritos
- `testCurrentMovieWithDetail()` - Testa dados detalhados do filme
- `testCurrentMovieWithoutDetail()` - Testa fallback para dados básicos do filme

**Dependências Mock**:
- `MockMovieService` - Simula comportamento do serviço de filmes
- `MockFavoritesService` - Simula comportamento do serviço de favoritos
- `MockMovieDetailViewModelDelegate` - Simula callbacks do delegate

### 6. MovieServiceTests.swift
**Propósito**: Testa o MovieService para comunicação com API
**Cobertura**:
- Funcionalidade de busca de filmes
- Funcionalidade de obtenção de detalhes de filmes
- Tratamento de erros
- Integração com NetworkManager

**Testes Principais**:
- `testSearchMovies()` - Testa chamada da API de busca de filmes
- `testSearchMoviesFailure()` - Testa tratamento de erros de busca
- `testGetMovieDetails()` - Testa chamada da API de detalhes de filmes
- `testGetMovieDetailsFailure()` - Testa tratamento de erros de detalhes
- `testSearchMoviesWithDefaultPage()` - Testa tratamento de parâmetros padrão

**Dependências Mock**:
- `MockNetworkManager` - Simula comportamento do gerenciador de rede

## Classes Mock

### MockUserDefaults
- Simula comportamento do UserDefaults para testes
- Rastreia chamadas de métodos e fornece dados mock
- Suporta simulação de erros

### MockMovieService
- Simula comportamento do MovieService
- Rastreia chamadas de API e parâmetros
- Fornece respostas mock e cenários de erro
- Suporta simulação de completion assíncrono

### MockFavoritesService
- Simula comportamento do FavoritesService
- Rastreia chamadas de métodos e parâmetros
- Fornece respostas mock para testes

### MockNetworkManager
- Simula comportamento do NetworkManager
- Rastreia chamadas de requisição e parâmetros
- Fornece respostas mock para diferentes tipos de requisição

### Mock Delegates
- `MockMovieResultViewModelDelegate`
- `MockFavoritesViewModelDelegate`
- `MockMovieDetailViewModelDelegate`
- Rastreiam chamadas de métodos do delegate e parâmetros

## Padrões de Teste

### 1. Padrão Given-When-Then
Todos os testes seguem o padrão Given-When-Then para estrutura clara de teste:
- **Given**: Configuração de dados de teste e condições
- **When**: Execução do método sendo testado
- **Then**: Verificação dos resultados esperados

### 2. Injeção de Dependências
Todos os ViewModels e Services usam injeção de dependências para testabilidade:
- Serviços mock são injetados ao invés de implementações reais
- Isso permite teste isolado de cada componente

### 3. Testes Assíncronos
Operações de rede são testadas usando completion handlers mock:
- Serviços mock simulam comportamento assíncrono
- Testes verificam cenários de sucesso e falha

### 4. Tratamento de Erros
Testes abrangentes de cenários de erro:
- Erros de rede
- Corrupção de dados
- Entrada inválida
- Casos extremos

## Executando os Testes

### No Xcode
1. Abra o arquivo MovieFinder.xcodeproj
2. Selecione o target MovieFinderTests
3. Pressione Cmd+U para executar todos os testes
4. Ou selecione classes/métodos individuais para executar testes específicos

### Via Linha de Comando
```bash
# Executar todos os testes
xcodebuild test -project MovieFinder.xcodeproj -scheme MovieFinder -destination 'platform=iOS Simulator,name=iPhone 15'

# Executar classe de teste específica
xcodebuild test -project MovieFinder.xcodeproj -scheme MovieFinder -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:MovieFinderTests/FavoritesServiceTests
```

## Cobertura de Testes

A suíte de testes fornece cobertura abrangente para:
- ✅ Validação e serialização de modelos
- ✅ Funcionalidade da camada de serviços
- ✅ Lógica de negócio dos ViewModels
- ✅ Cenários de tratamento de erros
- ✅ Operações assíncronas
- ✅ Fluxos de interação do usuário
- ✅ Persistência de dados
- ✅ Comunicação de rede

## Melhores Práticas Seguidas

1. **Isolamento**: Cada teste é independente e não depende de outros testes
2. **Mocking**: Dependências externas são adequadamente mockadas
3. **Nomenclatura**: Métodos de teste têm nomes descritivos que explicam o que testam
4. **Setup/Teardown**: Configuração e limpeza adequadas em setUp() e tearDown()
5. **Assertions**: Assertions claras que verificam comportamento específico
6. **Casos Extremos**: Teste de condições de erro e casos extremos
7. **Documentação**: Comentários claros explicando propósito e estrutura do teste

## Adições Futuras de Testes

Considere adicionar testes para:
- Testes de integração da camada UI
- Testes de performance para grandes conjuntos de dados
- Testes de acessibilidade
- Testes de localização
- Testes de integração com API real (em target de teste separado) 
