//
//  RepositoryProtocol.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation

public protocol RepositoryProtocol {
    func getList(limit: Int, offset: Int, completion: @escaping (Result<PokemonList, Error>) -> Void)
    func getDetail(url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void)
    func getImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> VoidClosure
}
