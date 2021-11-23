//
//  DetailViewModelTests.swift
//  PokemonLibraryTests
//
//  Created by Daniele Salvioni on 22/11/21.
//

import XCTest
@testable import PokemonLibrary

class DetailViewModelTests: XCTestCase {
    
    struct FakeError: Error {}
    let fakeError = FakeError()
    
    static func loadJSON(name: String) -> Data {
        let bundle = Bundle(for: Self.self)
        let path = bundle.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: path)
    }
    
    func testTitle() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        
        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))
        
        let expectation = self.expectation(description: "testTitle")
        
        detailViewModel.output.title = { title in
            expectation.fulfill()
            XCTAssertEqual(title, "Pokemon Detail")
        }
        detailViewModel.input.ready?()
        
        self.waitForExpectations(timeout: 1)
    }
    
    
    func testIsLoading() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))

        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))
        
        let expectation = self.expectation(description: "testIsLoading")
        expectation.expectedFulfillmentCount = 2

        var loadingCount = 0
        repositoryServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }
        repositoryServiceMock._getImage = { url, completion in
            completion(.success(url.absoluteString.data(using: .utf8)!))
            return {}
        }

        detailViewModel.output.isLoading = { isLoading in
            loadingCount += 1
            expectation.fulfill()
        }
        detailViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
        XCTAssertEqual(loadingCount, 2)
    }

    func testError() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))

        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))
        
        let expectation = self.expectation(description: "testError")

        repositoryServiceMock._getDetail = { _, completion in
            completion(.failure(self.fakeError))
        }

        detailViewModel.output.error = { message in
            expectation.fulfill()
            XCTAssertTrue(message.contains("FakeError"))
        }
        detailViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }

    func testName() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))

        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))
        
        let expectation = self.expectation(description: "testName")

        repositoryServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }
        repositoryServiceMock._getImage = { url, completion in
            completion(.success(url.absoluteString.data(using: .utf8)!))
            return {}
        }

        detailViewModel.output.name = { name in
            expectation.fulfill()
            XCTAssertEqual(name, "bulbasaur")
        }
        detailViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }

    func testReferenceImage() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))

        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))

        let expectation = self.expectation(description: "testReferenceImage")

        repositoryServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }
        repositoryServiceMock._getImage = { url, completion in
            completion(.success(url.absoluteString.data(using: .utf8)!))
            return {}
        }

        detailViewModel.output.referenceImage = { data in
            expectation.fulfill()
            XCTAssertEqual(String(decoding: data, as: UTF8.self), "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
        }
        detailViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }

    func testImages() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))

        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))

        let expectation = self.expectation(description: "testImages")
        expectation.expectedFulfillmentCount = 4

        var imagesCount = 0
        repositoryServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }
        repositoryServiceMock._getImage = { url, completion in
            completion(.success(url.absoluteString.data(using: .utf8)!))
            return {}
        }

        detailViewModel.output.image = { data in
            imagesCount += 1
            expectation.fulfill()
        }
        detailViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
        XCTAssertEqual(imagesCount, 4)
    }

    func testTypologyTitle() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        
        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))

        let expectation = self.expectation(description: "testTypologyTitle")

        detailViewModel.output.typologyTitle = { title in
            expectation.fulfill()
            XCTAssertEqual(title, "Typology")
        }
        detailViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }

    func testTypology() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))

        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))

        let expectation = self.expectation(description: "testTypology")

        repositoryServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }
        repositoryServiceMock._getImage = { url, completion in
            completion(.success(url.absoluteString.data(using: .utf8)!))
            return {}
        }

        detailViewModel.output.typologies = { value in
            expectation.fulfill()
            XCTAssertEqual(value, "grass\npoison")
        }
        detailViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }

    func testStatsTitle() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))

        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))

        let expectation = self.expectation(description: "testStatsTitle")

        detailViewModel.output.statsTitle = { title in
            expectation.fulfill()
            XCTAssertEqual(title, "Stats")
        }
        detailViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }

    func testStats() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))

        let repositoryServiceMock = RepositoryServiceMock()
        let detailViewModel = DetailViewModel(repository: repositoryServiceMock, pokemonData: (name: pokemonListMock.results.first!.name, url: pokemonListMock.results.first!.url))

        let expectation = self.expectation(description: "testStats")

        repositoryServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }
        repositoryServiceMock._getImage = { url, completion in
            completion(.success(url.absoluteString.data(using: .utf8)!))
            return {}
        }

        detailViewModel.output.stats = { stats in
            expectation.fulfill()
            XCTAssertEqual(stats, "hp: 45\nattack: 49\ndefense: 49\nspecial-attack: 65\nspecial-defense: 65\nspeed: 45")
        }
        detailViewModel.input.ready?()

        self.waitForExpectations(timeout: 1)
    }
}
