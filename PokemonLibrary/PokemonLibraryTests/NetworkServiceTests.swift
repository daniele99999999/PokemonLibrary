//
//  NetworkServiceTests.swift
//  PokemonLibraryTests
//
//  Created by Daniele Salvioni on 22/11/21.
//

import XCTest
@testable import PokemonLibrary

class NetworkServiceTests: XCTestCase {

    func testNetworkService400() {
        let dataTaskMock = DataTaskServiceMock()
        dataTaskMock._dataTask = { request, completion in
            completion(nil,
                       HTTPURLResponse(url: request.url!,
                                       statusCode: 400,
                                       httpVersion: nil,
                                       headerFields: nil),
                       nil)
            return {}
        }
        
        let networkService = NetworkService(dataTask: dataTaskMock)
        _ = networkService.fetchData(request: URLRequest(url: URL(string: "https://www.google.it")!)) { result in
            switch result {
            case .failure(let error):
                if let _error = error as? NetworkService.NetworkError {
                    XCTAssertEqual(_error, NetworkService.NetworkError.unsuccesful)
                } else {
                    XCTFail()
                }
            case .success(_):
                XCTFail()
            }
        }
    }
    
    func testDataTask200FailureGeneric() {
        let dataTaskMock = DataTaskServiceMock()
        dataTaskMock._dataTask = { request, completion in
            completion(nil,
                       HTTPURLResponse(url: request.url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil),
                       nil)
            return {}
        }
        
        let networkService = NetworkService(dataTask: dataTaskMock)
        _ = networkService.fetchData(request: URLRequest(url: URL(string: "https://www.google.it")!)) { result in
            switch result {
            case .failure(let error):
                if let _error = error as? NetworkService.NetworkError {
                    XCTAssertEqual(_error, NetworkService.NetworkError.generic)
                } else {
                    XCTFail()
                }
            case .success(_):
                XCTFail()
            }
        }
    }
    
    func testDataTask200FailureSpecific() {
        let dataTaskMock = DataTaskServiceMock()
        dataTaskMock._dataTask = { request, completion in
            completion(nil,
                       HTTPURLResponse(url: request.url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil),
                       NSError(domain: "", code: 500, userInfo: nil))
            return {}
        }
        
        let networkService = NetworkService(dataTask: dataTaskMock)
        _ = networkService.fetchData(request: URLRequest(url: URL(string: "https://www.google.it")!)) { result in
            switch result {
            case .failure(let error):
                if let _error = error as NSError? {
                    XCTAssertEqual(_error.code, 500)
                } else {
                    XCTFail()
                }
            case .success(_):
                XCTFail()
            }
        }
    }
    
    func testDataTask200Success() {
        let dataTaskMock = DataTaskServiceMock()
        dataTaskMock._dataTask = { request, completion in
            completion(Data(),
                       HTTPURLResponse(url: request.url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil),
                       nil)
            return {}
        }
        
        let networkService = NetworkService(dataTask: dataTaskMock)
        _ = networkService.fetchData(request: URLRequest(url: URL(string: "https://www.google.it")!)) { result in
            switch result {
            case .failure(_):
                XCTFail()
            case .success(_):
                XCTAssertTrue(true)
            }
        }
    }
}
