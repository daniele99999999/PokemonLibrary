//
//  ApiServiceTests.swift
//  PokemonLibraryTests
//
//  Created by Daniele Salvioni on 22/11/21.
//

import XCTest
@testable import PokemonLibrary

class ApiServiceTests: XCTestCase {    
    
    static func loadJSON(name: String) -> Data {
        let bundle = Bundle(for: Self.self)
        let path = bundle.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: path)
    }

    func testDecodingApiList() {
        let url = URL(string: "https://www.google.com")!
        let limit = 20
        let offset = 0
        let pokemonListDataMock = Self.loadJSON(name: "pokemonListDataMock")
        
        let expectation = self.expectation(description: "testDecodingApiList")
        let networkServiceMock = NetworkServiceMock()
        networkServiceMock._fetchData = { _, completion in
            completion(.success(pokemonListDataMock))
            return {}
        }
        
        let apiService:ApiService = ApiService(baseURL: url, networkService: networkServiceMock)
        apiService.getList(limit: limit, offset: offset) { result in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(data.results.count, 20)
                XCTAssertEqual(data.results.first?.name, "bulbasaur")
                // TODO: control more properties
            case .failure(let error):
                XCTFail("error: \(error)")
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testDecodingApiDetail() {
        let url = URL(string: "https://www.google.com")!
        let pokemonDetailDataMock = Self.loadJSON(name: "pokemonDetailDataMock")
        
        let expectation = self.expectation(description: "testDecodingApiDetail")
        let networkServiceMock = NetworkServiceMock()
        networkServiceMock._fetchData = { _, completion in
            completion(.success(pokemonDetailDataMock))
            return {}
        }
        
        let apiService:ApiService = ApiService(baseURL: url, networkService: networkServiceMock)
        apiService.getDetail(url: url) { result in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(data.name, "bulbasaur")
                // TODO: control more properties
            case .failure(let error):
                XCTFail("error: \(error)")
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
    
    func testDecodingApiImage() {
        let url = URL(string: "https://www.google.com")!
        
        let expectation = self.expectation(description: "testDecodingApiImage")
        let networkServiceMock = NetworkServiceMock()
        networkServiceMock._fetchData = { url, completion in
            completion(.success(url.url!.absoluteString.data(using: .utf8)!))
            return {}
        }
        
        let apiService:ApiService = ApiService(baseURL: url, networkService: networkServiceMock)
        _ = apiService.getImage(url: url) { result in
            expectation.fulfill()
            switch result {
            case .success(let data):
                XCTAssertEqual(String(data: data, encoding: .utf8), String(data: url.absoluteString.data(using: .utf8)!, encoding: .utf8))
            case .failure(let error):
                XCTFail("error: \(error)")
            }
        }
        
        self.waitForExpectations(timeout: 1)
    }
}
