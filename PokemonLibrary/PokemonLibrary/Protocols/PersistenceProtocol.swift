//
//  PersistenceProtocol.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation

public protocol PersistenceProtocol {
    func save<T: Codable, ID: LosslessStringConvertible>(_ entity: T, id: ID) throws
    func retrieve<T: Codable, ID: LosslessStringConvertible>(_ entityType: T.Type, id: ID) throws -> T?
}
