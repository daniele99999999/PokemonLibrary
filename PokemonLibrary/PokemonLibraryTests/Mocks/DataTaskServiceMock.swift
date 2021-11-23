//
//  DataTaskServiceMock.swift
//  PokemonLibraryTests
//
//  Created by daniele salvioni on 22/11/21.
//

@testable import PokemonLibrary
import Foundation

class DataTaskServiceMock: DataTaskProtocol {
    var _dataTask: ((URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> VoidClosure)?
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> VoidClosure {
        return self._dataTask!(request, completionHandler)
    }
}
