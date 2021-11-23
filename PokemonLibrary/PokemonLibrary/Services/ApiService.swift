//
//  ApiService.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation

public struct ApiService {
    enum Endpoints {
        case list
        
        var path: String {
            switch self {
            case .list:
                return "pokemon"
            }
        }
        
        func url(baseURL: URL) -> URL {
            switch self {
            case .list:
                return baseURL.appendingPathComponent(self.path)
            }
        }
    }
    
    let baseURL: URL
    let networkService: NetworkProtocol
    
    init(baseURL: URL, networkService: NetworkProtocol) {
        self.baseURL = baseURL
        self.networkService = networkService
    }
}

extension ApiService: APIHandleResponseProtocol {}
extension ApiService: APIProtocol {
    public func getList(limit: Int, offset: Int, completion: @escaping (Result<PokemonList, Error>) -> Void) {
        let url = Endpoints.list.url(baseURL: self.baseURL)
        let queryItems = [URLQueryItem(name: "offset", value: String(offset)),
                          URLQueryItem(name: "limit", value: String(limit))]
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        guard let fullUrl = urlComponents?.url else { return }
        let request = URLRequest(url: fullUrl)
        _ = self.networkService.fetchData(request: request,
                                          completion: self.handleResponse(completion: completion))
    }
    
    public func getDetail(url: URL, completion: @escaping (Result<PokemonDetail, Error>) -> Void) {
        let request = URLRequest(url: url)
        _ = self.networkService.fetchData(request: request,
                                          completion: self.handleResponse(completion: completion))
    }
    
    public func getImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> VoidClosure {
        let request = URLRequest(url: url)
        return self.networkService.fetchData(request: request,
                                             completion: completion)
    }
}
