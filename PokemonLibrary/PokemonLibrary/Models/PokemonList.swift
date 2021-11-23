//
//  PokemonList.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation

public struct PokemonList: Codable, Equatable {
    public let count: Int
    public let next: URL?
    public let previous: URL?
    public let results: [Item]
}

public extension PokemonList {
    struct Item: Codable, Equatable {
        public let name: String
        public let url: URL
    }
}
