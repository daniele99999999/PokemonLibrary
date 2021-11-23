//
//  RepositoryServiceTests.swift
//  PokemonLibraryTests
//
//  Created by Daniele Salvioni on 22/11/21.
//

import XCTest
@testable import PokemonLibrary

class RepositoryServiceTests: XCTestCase {
    
    static func loadJSON(name: String) -> Data {
        let bundle = Bundle(for: Self.self)
        let path = bundle.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: path)
    }
    
    func testRepositoryPokemonListCache() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let limit = 20
        let offset = 0
        let id = "\(limit.description).\(offset.description)"
        
        let expectation = self.expectation(description: "testRepositoryPokemonListCache")
        let apiServiceMock = ApiServiceMock()
        apiServiceMock._getList = { _, _, completion in
            XCTFail("ApiService should not be called")
        }
        let persistenceServiceMock = PersistenceServiceMock<PokemonList, String>()
        persistenceServiceMock.set(pokemonListMock, for: id)
        let repositoryService = RepositoryService(apiService: apiServiceMock, persistenceService: persistenceServiceMock)
        repositoryService.getList(limit: limit, offset: offset) { result in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(data.results.count, pokemonListMock.results.count)
                XCTAssertEqual(data.results.first?.name, pokemonListMock.results.first?.name)
                // TODO: control more properties
            case .failure(let error):
                XCTFail("error: \(error)")
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testRepositoryPokemonListAPI() {
        let pokemonListMock = try! JSONDecoder().decode(PokemonList.self, from: Self.loadJSON(name: "pokemonListDataMock"))
        let limit = 20
        let offset = 0

        let expectation = self.expectation(description: "testRepositoryPokemonListAPI")
        let apiServiceMock = ApiServiceMock()
        apiServiceMock._getList = { _, _, completion in
            completion(.success(pokemonListMock))
        }
        let persistenceServiceMock = PersistenceServiceMock<PokemonList, String>()
        let repositoryService = RepositoryService(apiService: apiServiceMock, persistenceService: persistenceServiceMock)
        repositoryService.getList(limit: limit, offset: offset) { result in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(data.results.count, pokemonListMock.results.count)
                XCTAssertEqual(data.results.first?.name, pokemonListMock.results.first?.name)
                // TODO: control more properties
            case .failure(let error):
                XCTFail("error: \(error)")
            }
        }

        self.waitForExpectations(timeout: 1)
    }
    
    func testRepositoryPokemonDetailCache() {
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))
        let url = URL(string: "https://www.google.com")!
        let id = url.lastPathComponent.description
        
        let expectation = self.expectation(description: "testRepositoryPokemonDetailCache")
        let apiServiceMock = ApiServiceMock()
        apiServiceMock._getDetail = { _, completion in
            XCTFail("ApiService should not be called")
        }
        let persistenceServiceMock = PersistenceServiceMock<PokemonDetail, String>()
        persistenceServiceMock.set(pokemonDetailMock, for: id)
        let repositoryService = RepositoryService(apiService: apiServiceMock, persistenceService: persistenceServiceMock)
        repositoryService.getDetail(url: url) { result in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(data.name, pokemonDetailMock.name)
                // TODO: control more properties
            case .failure(let error):
                XCTFail("error: \(error)")
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testRepositoryPokemonDetailAPI() {
        let pokemonDetailMock = try! JSONDecoder().decode(PokemonDetail.self, from: Self.loadJSON(name: "pokemonDetailDataMock"))
        let url = URL(string: "https://www.google.com")!
        
        let expectation = self.expectation(description: "testRepositoryPokemonDetailAPI")
        let apiServiceMock = ApiServiceMock()
        apiServiceMock._getDetail = { _, completion in
            completion(.success(pokemonDetailMock))
        }
        let persistenceServiceMock = PersistenceServiceMock<PokemonDetail, String>()
        let repositoryService = RepositoryService(apiService: apiServiceMock, persistenceService: persistenceServiceMock)
        repositoryService.getDetail(url: url) { result in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(data.name, pokemonDetailMock.name)
                // TODO: control more properties
            case .failure(let error):
                XCTFail("error: \(error)")
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testRepositoryImageCache() {
        let imageDataMock = "test".data(using: .utf8)!
        let url = URL(string: "https://www.google.com")!
        let id = url.absoluteString.description
        
        let expectation = self.expectation(description: "testRepositoryImageCache")
        let apiServiceMock = ApiServiceMock()
        apiServiceMock._getImage = { _, completion in
            XCTFail("ApiService should not be called")
            return {}
        }
        let persistenceServiceMock = PersistenceServiceMock<Data, String>()
        persistenceServiceMock.set(imageDataMock, for: id)
        let repositoryService = RepositoryService(apiService: apiServiceMock, persistenceService: persistenceServiceMock)
        _ = repositoryService.getImage(url: url) { result in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(data, imageDataMock)
            case .failure(let error):
                XCTFail("error: \(error)")
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testRepositoryImageApi() {
        let imageDataMock = "test".data(using: .utf8)!
        let url = URL(string: "https://www.google.com")!
        
        let expectation = self.expectation(description: "testRepositoryImageApi")
        let apiServiceMock = ApiServiceMock()
        apiServiceMock._getImage = { _, completion in
            completion(.success(imageDataMock))
            return {}
        }
        let persistenceServiceMock = PersistenceServiceMock<Data, String>()
        let repositoryService = RepositoryService(apiService: apiServiceMock, persistenceService: persistenceServiceMock)
        _ = repositoryService.getImage(url: url) { result in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(data, imageDataMock)
            case .failure(let error):
                XCTFail("error: \(error)")
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
}
