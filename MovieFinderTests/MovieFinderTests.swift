//
//  MovieFinderTests.swift
//  MovieFinderTests
//
//  Created by Larissa Kaweski Siqueira on 02/07/25.
//

import XCTest
@testable import MovieFinder

final class MovieFinderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovieModelCreation() throws {
        // Given
        let movie = Movie(
            id: 1,
            title: "Test Movie",
            originalTitle: "Test Movie Original",
            overview: "Test overview",
            posterPath: "/test.jpg",
            backdropPath: "/test_backdrop.jpg",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            budget: 1000000,
            revenue: 5000000
        )
        
        // Then
        XCTAssertEqual(movie.id, 1)
        XCTAssertEqual(movie.title, "Test Movie")
        XCTAssertEqual(movie.originalTitle, "Test Movie Original")
        XCTAssertEqual(movie.overview, "Test overview")
        XCTAssertEqual(movie.posterPath, "/test.jpg")
        XCTAssertEqual(movie.backdropPath, "/test_backdrop.jpg")
        XCTAssertEqual(movie.releaseDate, "2023-01-01")
        XCTAssertEqual(movie.voteAverage, 8.5)
        XCTAssertEqual(movie.voteCount, 1000)
        XCTAssertEqual(movie.budget, 1000000)
        XCTAssertEqual(movie.revenue, 5000000)
    }
    
    func testMovieModelEquality() throws {
        // Given
        let movie1 = Movie(
            id: 1,
            title: "Test Movie",
            originalTitle: "Test Movie Original",
            overview: "Test overview",
            posterPath: "/test.jpg",
            backdropPath: "/test_backdrop.jpg",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            budget: 1000000,
            revenue: 5000000
        )
        
        let movie2 = Movie(
            id: 1,
            title: "Test Movie",
            originalTitle: "Test Movie Original",
            overview: "Test overview",
            posterPath: "/test.jpg",
            backdropPath: "/test_backdrop.jpg",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            budget: 1000000,
            revenue: 5000000
        )
        
        let movie3 = Movie(
            id: 2,
            title: "Different Movie",
            originalTitle: "Different Movie Original",
            overview: "Different overview",
            posterPath: "/different.jpg",
            backdropPath: "/different_backdrop.jpg",
            releaseDate: "2023-02-01",
            voteAverage: 7.0,
            voteCount: 500,
            budget: 2000000,
            revenue: 3000000
        )
        
        // Then
        XCTAssertEqual(movie1, movie2)
        XCTAssertNotEqual(movie1, movie3)
    }
    
    func testMovieModelWithNilValues() throws {
        // Given
        let movie = Movie(
            id: 1,
            title: "Test Movie",
            originalTitle: "Test Movie Original",
            overview: "Test overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            budget: nil,
            revenue: nil
        )
        
        // Then
        XCTAssertEqual(movie.id, 1)
        XCTAssertEqual(movie.title, "Test Movie")
        XCTAssertNil(movie.posterPath)
        XCTAssertNil(movie.backdropPath)
        XCTAssertNil(movie.budget)
        XCTAssertNil(movie.revenue)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
