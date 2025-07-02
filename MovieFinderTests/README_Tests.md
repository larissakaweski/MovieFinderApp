# MovieFinder Tests Documentation

## Overview
This document describes the comprehensive test suite for the MovieFinder iOS application. The tests follow the MVVM architecture pattern and use XCTest framework with proper mocking and dependency injection.

## Test Files Structure

### 1. MovieFinderTests.swift
**Purpose**: Basic model and project tests
**Coverage**:
- Movie model creation and validation
- Movie model equality testing
- Movie model with nil values handling
- Basic project functionality

**Key Tests**:
- `testMovieModelCreation()` - Validates Movie struct initialization
- `testMovieModelEquality()` - Tests equality comparison between Movie instances
- `testMovieModelWithNilValues()` - Tests Movie with optional fields set to nil

### 2. FavoritesServiceTests.swift
**Purpose**: Tests the FavoritesService singleton for managing favorite movies
**Coverage**:
- Adding movies to favorites
- Removing movies from favorites
- Checking if movie is favorite
- Getting all favorites
- Clearing all favorites
- Error handling for invalid data
- UserDefaults integration

**Key Tests**:
- `testAddToFavorites()` - Tests adding a movie to favorites
- `testRemoveFromFavorites()` - Tests removing a movie from favorites
- `testIsFavorite()` - Tests favorite status checking
- `testGetFavoritesWithInvalidData()` - Tests error handling for corrupted data
- `testSaveFavoritesWithEncodingError()` - Tests encoding error scenarios

**Mock Dependencies**:
- `MockUserDefaults` - Simulates UserDefaults behavior for testing

### 3. MovieResultViewModelTests.swift
**Purpose**: Tests the MovieResultViewModel for search results management
**Coverage**:
- Movie search functionality
- Pagination handling
- Loading states
- Error handling
- Favorite toggling
- Results clearing

**Key Tests**:
- `testResultMoviesWithEmptyQuery()` - Tests empty search query handling
- `testResultMoviesSuccess()` - Tests successful search results
- `testResultMoviesFailure()` - Tests search error handling
- `testLoadMoreMoviesWhenNoMorePages()` - Tests pagination no more page
- `testToggleFavorite()` - Tests favorite toggling

**Mock Dependencies**:
- `MockMovieService` - Simulates movie service behavior
- `MockFavoritesService` - Simulates favorites service behavior
- `MockMovieResultViewModelDelegate` - Simulates delegate callbacks

### 4. FavoritesViewModelTests.swift
**Purpose**: Tests the FavoritesViewModel for favorites screen management
**Coverage**:
- Loading favorites
- Removing favorites
- Empty state handling
- Count and isEmpty properties

**Key Tests**:
- `testLoadFavorites()` - Tests loading favorites from service
- `testLoadFavoritesEmpty()` - Tests empty favorites state
- `testRemoveFromFavorites()` - Tests removing a favorite
- `testIsEmpty()` - Tests empty state detection
- `testCount()` - Tests favorites count

**Mock Dependencies**:
- `MockFavoritesService` - Simulates favorites service behavior
- `MockFavoritesViewModelDelegate` - Simulates delegate callbacks

### 5. MovieDetailViewModelTests.swift
**Purpose**: Tests the MovieDetailViewModel for movie detail screen management
**Coverage**:
- Loading movie details
- Favorite status management
- Loading states
- Error handling
- Movie detail vs basic movie data

**Key Tests**:
- `testInitialState()` - Tests initial view model state
- `testLoadMovieDetailsSuccess()` - Tests successful detail loading
- `testLoadMovieDetailsFailure()` - Tests detail loading error handling
- `testToggleFavoriteAdd()` - Tests adding to favorites
- `testToggleFavoriteRemove()` - Tests removing from favorites
- `testCurrentMovieWithDetail()` - Tests detailed movie data
- `testCurrentMovieWithoutDetail()` - Tests basic movie data fallback

**Mock Dependencies**:
- `MockMovieService` - Simulates movie service behavior
- `MockFavoritesService` - Simulates favorites service behavior
- `MockMovieDetailViewModelDelegate` - Simulates delegate callbacks

### 6. MovieServiceTests.swift
**Purpose**: Tests the MovieService for API communication
**Coverage**:
- Search movies functionality
- Get movie details functionality
- Error handling
- Network manager integration

**Key Tests**:
- `testSearchMovies()` - Tests movie search API call
- `testSearchMoviesFailure()` - Tests search error handling
- `testGetMovieDetails()` - Tests movie details API call
- `testGetMovieDetailsFailure()` - Tests details error handling
- `testSearchMoviesWithDefaultPage()` - Tests default parameter handling

**Mock Dependencies**:
- `MockNetworkManager` - Simulates network manager behavior

## Mock Classes

### MockUserDefaults
- Simulates UserDefaults behavior for testing
- Tracks method calls and provides mock data
- Supports error simulation

### MockMovieService
- Simulates MovieService behavior
- Tracks API calls and parameters
- Provides mock responses and error scenarios
- Supports async completion simulation

### MockFavoritesService
- Simulates FavoritesService behavior
- Tracks method calls and parameters
- Provides mock responses for testing

### MockNetworkManager
- Simulates NetworkManager behavior
- Tracks request calls and parameters
- Provides mock responses for different request types

### Mock Delegates
- `MockMovieResultViewModelDelegate`
- `MockFavoritesViewModelDelegate`
- `MockMovieDetailViewModelDelegate`
- Track delegate method calls and parameters

## Testing Patterns

### 1. Given-When-Then Pattern
All tests follow the Given-When-Then pattern for clear test structure:
- **Given**: Setup test data and conditions
- **When**: Execute the method being tested
- **Then**: Verify expected outcomes

### 2. Dependency Injection
All ViewModels and Services use dependency injection for testability:
- Mock services are injected instead of real implementations
- This allows isolated testing of each component

### 3. Async Testing
Network operations are tested using mock completion handlers:
- Mock services simulate async behavior
- Tests verify both success and failure scenarios

### 4. Error Handling
Comprehensive error scenario testing:
- Network errors
- Data corruption
- Invalid input
- Edge cases

## Running Tests

### In Xcode
1. Open the MovieFinder.xcodeproj file
2. Select the MovieFinderTests target
3. Press Cmd+U to run all tests
4. Or select individual test classes/methods to run specific tests

### From Command Line
```bash
# Run all tests
xcodebuild test -project MovieFinder.xcodeproj -scheme MovieFinder -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test class
xcodebuild test -project MovieFinder.xcodeproj -scheme MovieFinder -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:MovieFinderTests/FavoritesServiceTests
```

## Test Coverage

The test suite provides comprehensive coverage for:
- ✅ Model validation and serialization
- ✅ Service layer functionality
- ✅ ViewModel business logic
- ✅ Error handling scenarios
- ✅ Async operations
- ✅ User interaction flows
- ✅ Data persistence
- ✅ Network communication

## Best Practices Followed

1. **Isolation**: Each test is independent and doesn't rely on other tests
2. **Mocking**: External dependencies are properly mocked
3. **Naming**: Test methods have descriptive names that explain what they test
4. **Setup/Teardown**: Proper setup and cleanup in setUp() and tearDown()
5. **Assertions**: Clear assertions that verify specific behavior
6. **Edge Cases**: Testing of error conditions and edge cases
7. **Documentation**: Clear comments explaining test purpose and structure

## Future Test Additions

Consider adding tests for:
- UI layer integration tests
- Performance tests for large datasets
- Accessibility tests
- Localization tests
- Integration tests with real API (in separate test target) 
