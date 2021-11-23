//
//  NetworkService.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation

public struct NetworkService {
    let dataTask: DataTaskProtocol

    public init(dataTask: DataTaskProtocol) {
        self.dataTask = dataTask
    }
}

extension NetworkService {
    public enum NetworkError: Error {
        case generic
        case unsuccesful
    }
}

extension NetworkService: NetworkProtocol {
    public func fetchData(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> VoidClosure {
        let cancellable = self.dataTask.dataTask(with: request) { data, response, error in
            guard let status = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.generic))
                return
            }

            switch status.statusCode {
            case 200..<400:
                switch (data, error) {
                case let (_, .some(error)):
                    completion(.failure(error))
                case let (.some(data), .none):
                    completion(.success(data))
                case (.none, .none):
                    completion(.failure(NetworkError.generic))
                }
            default:
                completion(.failure(NetworkError.unsuccesful))
            }
        }
        return cancellable
    }
}
