//
//  ListViewModelTests.swift
//  PokemonLibraryTests
//
//  Created by Daniele Salvioni on 22/11/21.
//

import XCTest
@testable import PokemonLibrary

class ListViewModelTests: XCTestCase {
    struct FakeError: Error {}
    let fakeError = FakeError()
    
    static func loadJSON(name: String) -> Data {
        let bundle = Bundle(for: Self.self)
        let path = bundle.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: path)
    }
    
    func testTitle() {
        let repositoryServiceMock = RepositoryServiceMock()
        let listViewModel = ListViewModel(repository: repositoryServiceMock,
                                          limit: 20,
                                          page: 1)
        
        let expectation = self.expectation(description: "testTitle")
        
        listViewModel.output.title = { title in
            expectation.fulfill()
            XCTAssertEqual(title, "Pokemon List")
        }
        listViewModel.input.ready?()
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testIsLoading()
    {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let repositoryServiceMock = RepositoryServiceMock()
        let listViewModel = ListViewModel(repository: repositoryServiceMock,
                                          limit: 20,
                                          page: 1)
        
        let expectation = self.expectation(description: "testIsLoading")
        expectation.expectedFulfillmentCount = 2
        var loadingCount = 0
        
        repositoryServiceMock._getList = { _, _, completion in
            completion(.success(pokemonListMock))
        }
        
        listViewModel.output.isLoading = { _ in
            loadingCount += 1
            expectation.fulfill()
        }
        
        listViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
        XCTAssertEqual(loadingCount, 2)
    }

    func testError() {
        let repositoryServiceMock = RepositoryServiceMock()
        let listViewModel = ListViewModel(repository: repositoryServiceMock,
                                          limit: 20,
                                          page: 1)
        
        let expectation = self.expectation(description: "testError")

        repositoryServiceMock._getList = { _, _, completion in
            completion(.failure(self.fakeError))
        }

        listViewModel.output.error = { message in
            expectation.fulfill()
            XCTAssertTrue(message.contains("FakeError"))
        }
        listViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }

    func testUpdates() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let repositoryServiceMock = RepositoryServiceMock()
        let listViewModel = ListViewModel(repository: repositoryServiceMock,
                                          limit: 20,
                                          page: 1)
        
        let expectation = self.expectation(description: "testUpdates")

        repositoryServiceMock._getList = { _, _, completion in
            completion(.success(pokemonListMock))
        }

        listViewModel.output.updates = { updates in
            let indexPaths = Array(0..<20).map { row in
                IndexPath(row: row, section: 0)
            }
            XCTAssertEqual(updates, indexPaths)
            XCTAssertEqual(updates.count, 20)
            expectation.fulfill()
        }
        listViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }

    func testPokemonData() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let repositoryServiceMock = RepositoryServiceMock()
        let listViewModel = ListViewModel(repository: repositoryServiceMock,
                                          limit: 20,
                                          page: 1)
        
        let expectation1 = self.expectation(description: "testPokemonData p1")
        
        repositoryServiceMock._getList = { _, _, completion in
            completion(.success(pokemonListMock))
        }
        
        listViewModel.output.updates = { update in
            expectation1.fulfill()
        }
        listViewModel.input.ready?()
        waitForExpectations(timeout: 1)
        
        let expectation2 = expectation(description: "testPokemonData p2")
        listViewModel.output.pokemonData = { item in
            expectation2.fulfill()
            XCTAssertEqual(item.name, "bulbasaur")
            XCTAssertEqual(item.url.absoluteString, "https://pokeapi.co/api/v2/pokemon/1/")
        }
        listViewModel.input.selectedItem?(0)

        self.waitForExpectations(timeout: 1)
    }
}
