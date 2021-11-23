//
//  ApiProtocol.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation

public protocol APIHandleResponseProtocol {}

public extension APIHandleResponseProtocol {
    func handleResponse<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) -> (Result<Data, Error>) -> Void {
        return { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
            case .failure(let responseError):
                completion(.failure(responseError))
            }
        }
    }
}

public protocol APIProtocol {
    func getList(limit: Int, offset: Int, completion: @escaping (Result<PokemonList, Error>) -> Void)
    func getDetail(url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void)
    func getImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> VoidClosure
}
