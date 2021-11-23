//
//  NetworkServiceMock.swift
//  PokemonLibraryTests
//
//  Created by daniele salvioni on 22/11/21.
//

@testable import PokemonLibrary
import Foundation

class NetworkServiceMock: NetworkProtocol {
    var _fetchData: ((URLRequest, @escaping (Result<Data, Error>) -> Void) -> VoidClosure)?
    func fetchData(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> VoidClosure {
        return self._fetchData!(request, completion)
    }
}
