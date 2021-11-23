//
//  PersistenceServiceTests.swift
//  PokemonLibraryTests
//
//  Created by Daniele Salvioni on 22/11/21.
//

import XCTest
@testable import PokemonLibrary

class PersistenceServiceTests: XCTestCase {
    
    func testPersistencePokemonList() {
        let persistence = PersistenceService()
        let data = PokemonList(count: 1,
                               next: nil,
                               previous: nil,
                               results: [])
        let id = UUID().uuidString
        try? persistence.save(data, id: id)
        let result = try? persistence.retrieve(PokemonList.self, id: id)
        XCTAssertEqual(result, data)
    }
    
    func testPersistencePokemonDetail() {
        let persistence = PersistenceService()
        let data = PokemonDetail(id: 1,
                                 name: "name",
                                 sprites: PokemonDetail.Sprite(frontDefault: URL(string: "https://www.google.com")!,
                                                               frontShiny: nil,
                                                               backDefault: nil,
                                                               backShiny: nil,
                                                               officialArtwork: nil),
                                 stats: [],
                                 types: [])
        let id = UUID().uuidString
        try? persistence.save(data, id: id)
        let result = try? persistence.retrieve(PokemonDetail.self, id: id)
        XCTAssertEqual(result, data)
    }
    
    func testPersistencePokemonImage() {
        let persistence = PersistenceService()
        let data = "test".data(using: .utf8)
        let id = UUID().uuidString
        try? persistence.save(data, id: id)
        let result = try? persistence.retrieve(Data.self, id: id)
        XCTAssertEqual(result, data)
    }
}
