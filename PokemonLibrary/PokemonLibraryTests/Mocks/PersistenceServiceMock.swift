//
//  PersistenceServiceMock.swift
//  PokemonLibraryTests
//
//  Created by daniele salvioni on 22/11/21.
//

@testable import PokemonLibrary
import Foundation

class PersistenceServiceMock<TM: Codable, IDM: LosslessStringConvertible & Hashable>: PersistenceProtocol {
    var list = [IDM: TM]()

    func set(_ value: TM, for key: IDM) {
        self.list[key] = value
    }

    func save<T: Codable, ID: LosslessStringConvertible>(_ entity: T, id: ID) throws {
        guard
            let entity = entity as? TM,
            let id = id as? IDM
            else { return }
        
        self.list[id] = entity
    }

    func retrieve<T: Codable, ID: LosslessStringConvertible>(_ entityType: T.Type, id: ID) throws -> T? {
        guard
            let id = id as? IDM
            else { return nil }

        return self.list[id] as? T
    }
}
