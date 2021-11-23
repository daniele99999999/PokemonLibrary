//
//  ListCellViewModelTests.swift
//  PokemonLibraryTests
//
//  Created by Daniele Salvioni on 22/11/21.
//

import XCTest
@testable import PokemonLibrary

class ListCellViewModelTests: XCTestCase {
    
    struct FakeError: Error {}
    let fakeError = FakeError()
    
    static func loadJSON(name: String) -> Data {
        let bundle = Bundle(for: Self.self)
        let path = bundle.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: path)
    }
    
    func testError() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))
        let repositoryServiceMock = RepositoryServiceMock()
        let listCellViewModel = ListCellViewModel(name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url, repository: repositoryServiceMock)
        
        let expectation1 = self.expectation(description: "testError p1")
        
        repositoryServiceMock._getDetail = { _, completion in
            completion(.failure(self.fakeError))
        }
        
        listCellViewModel.output.error = { message in
            expectation1.fulfill()
            XCTAssertTrue(message.contains("FakeError"))
        }
        listCellViewModel.input.ready?()
        
        self.waitForExpectations(timeout: 1)
        
        let expectation2 = self.expectation(description: "testError p2")
        
        repositoryServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }
        
        repositoryServiceMock._getImage = { _, completion in
            completion(.failure(self.fakeError))
            return {}
        }
        
        listCellViewModel.output.error = { message in
            expectation2.fulfill()
            XCTAssertTrue(message.contains("FakeError"))
        }
        listCellViewModel.input.ready?()
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testReset() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let repositoryServiceMock = RepositoryServiceMock()
        let listCellViewModel = ListCellViewModel(name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url, repository: repositoryServiceMock)
        
        let expectation = self.expectation(description: "testReset")

        listCellViewModel.output.reset = {
            expectation.fulfill()
        }

        listCellViewModel.input.reset?()

        self.waitForExpectations(timeout: 1)
    }

    func testImage() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))
        let repositoryServiceMock = RepositoryServiceMock()
        let listCellViewModel = ListCellViewModel(name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url, repository: repositoryServiceMock)
        
        let expectation = self.expectation(description: "testImage")

        repositoryServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }

        repositoryServiceMock._getImage = { url, completion in
            completion(.success(url.absoluteString.data(using: .utf8)!))
            return {}
        }

        listCellViewModel.output.image = { data in
            expectation.fulfill()
            XCTAssertEqual(String(data: data, encoding: .utf8)!, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        }
        listCellViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }

    func testName() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))
        let repositoryServiceMock = RepositoryServiceMock()
        let listCellViewModel = ListCellViewModel(name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url, repository: repositoryServiceMock)
        
        let expectation = self.expectation(description: "testName")

        repositoryServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }

        repositoryServiceMock._getImage = { url, completion in
            completion(.success(url.absoluteString.data(using: .utf8)!))
            return {}
        }

        listCellViewModel.output.name = { name in
            expectation.fulfill()
            XCTAssertEqual(name, "bulbasaur")
        }
        listCellViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }
}
