//
//  ApiServiceMock.swift
//  PokemonLibraryTests
//
//  Created by daniele salvioni on 22/11/21.
//

@testable import PokemonLibrary
import Foundation

class ApiServiceMock: APIProtocol {
    var _getList: ((Int, Int, @escaping (Result<PokemonList, Error>) -> Void) -> Void)?
    func getList(limit: Int, offset: Int, completion: @escaping (Result<PokemonList, Error>) -> Void) {
        self._getList?(limit, offset, completion)
    }
    
    var _getDetail: ((URL, @escaping (Result<PokemonDetail, Error>) -> Void) -> Void)?
    func getDetail(url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        self._getDetail?(url, completion)
    }
    
    var _getImage: ((URL, @escaping (Result<Data, Error>) -> Void) -> VoidClosure)?
    func getImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> VoidClosure {
        return self._getImage!(url, completion)
    }
}
