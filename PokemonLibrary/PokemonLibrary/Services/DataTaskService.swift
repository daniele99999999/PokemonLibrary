//
//  DataTaskService.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation

public struct DataTaskService {
    let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
}

extension DataTaskService: DataTaskProtocol {
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> VoidClosure {
        let task = self.session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        return task.cancel
    }
}
