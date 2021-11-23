//
//  NetworkProtocol.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation

public protocol NetworkProtocol {
    func fetchData(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> VoidClosure
}
