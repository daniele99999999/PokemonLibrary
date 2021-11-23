//
//  RepositoryService.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation

struct RepositoryService {
    let apiService: APIProtocol
    let persistenceService: PersistenceProtocol
    
    init(apiService: APIProtocol, persistenceService: PersistenceProtocol) {
        self.apiService = apiService
        self.persistenceService = persistenceService
    }
}

extension RepositoryService: RepositoryProtocol {
    func getList(limit: Int, offset: Int, completion: @escaping (Result<PokemonList, Error>) -> Void) {
        let id = "\(limit.description).\(offset.description)"
        var result: PokemonList? = nil
        do {
            result = try self.persistenceService.retrieve(PokemonList.self, id: id)
        }
        catch let persistenceError {
            completion(.failure(persistenceError))
            return
        }
        
        switch result {
        case .none:
            self.apiService.getList(limit: limit, offset: offset) { result in
                switch result {
                case let .success(pokemonList):
                    do {
                        try self.persistenceService.save(pokemonList, id: id)
                        completion(.success(pokemonList))
                    }
                    catch let persistenceError { completion(.failure(persistenceError)) }
                case let .failure(networkError):
                    completion(.failure(networkError))
                }
            }
        case .some(let pokemonList):
            completion(.success(pokemonList))
        }
    }
    
    func getDetail(url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        let id = url.lastPathComponent.description
        var result: PokemonDetail? = nil
        do {
            result = try self.persistenceService.retrieve(PokemonDetail.self, id: id)
        }
        catch let persistenceError {
            completion(.failure(persistenceError))
            return
        }
        
        switch result {
        case .none:
            self.apiService.getDetail(url: url) { result in
                switch result {
                case let .success(pokemonDetail):
                    do {
                        try self.persistenceService.save(pokemonDetail, id: id)
                        completion(.success(pokemonDetail))
                    }
                    catch let persistenceError { completion(.failure(persistenceError)) }
                case let .failure(networkError):
                    completion(.failure(networkError))
                }
            }
        case .some(let pokemonDetail):
            completion(.success(pokemonDetail))
        }
    }
    
    func getImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> VoidClosure {
        let id = url.absoluteString.description
        var result: Data? = nil
        do {
            result = try self.persistenceService.retrieve(Data.self, id: id)
        }
        catch let persistenceError {
            completion(.failure(persistenceError))
            return {}
        }
        
        switch result {
        case .none:
            let cancellableTask = self.apiService.getImage(url: url) { result in
                switch result {
                case let .success(imageData):
                    do {
                        try self.persistenceService.save(imageData, id: id)
                        completion(.success(imageData))
                    }
                    catch let persistenceError { completion(.failure(persistenceError)) }
                case let .failure(networkError):
                    completion(.failure(networkError))
                }
            }
            return cancellableTask
        case .some(let imageData):
            completion(.success(imageData))
            return {}
        }
    }
}
