//
//  ListCellViewModel.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation

class ListCellViewModel {
    let input = Input()
    let output = Output()
    
    private let repository: RepositoryProtocol
    private let url: URL
    private let name: String
    
    private var cancelImageClosure: VoidClosure?
    
    init(name: String, url: URL, repository: RepositoryProtocol) {
        self.repository = repository
        self.name = name
        self.url = url
        
        self.input.ready = self.ready
        self.input.reset = self.reset
    }
}

private extension ListCellViewModel {
    func ready() {
        self.output.name?(self.name)
        
        self.repository.getDetail(url: self.url) { result in
            switch result {
            case .success(let pokemonDetail):
                self.loadImage(url: pokemonDetail.sprites.iconSprite)
            case .failure(let error):
                self.output.error?(error.localizedDescription)
            }
        }
    }
    
    func loadImage(url: URL) {
        self.cancelImageClosure = self.repository.getImage(url: url) { result in
            switch result {
            case .success(let imageData):
                self.output.image?(imageData)
            case .failure(let error):
                self.output.error?(error.localizedDescription)
            }
        }
    }
    
    func reset() {
        self.cancelDownload()
        self.output.reset?()
    }
    
    func cancelDownload() {
        self.cancelImageClosure?()
    }
}

extension ListCellViewModel {
    class Input {
        var ready: VoidClosure?
        var reset: VoidClosure?
    }
    
    class Output {
        var error: VoidOutputClosure<String>?
        var reset: VoidClosure?
        var image: VoidOutputClosure<Data>?
        var name: VoidOutputClosure<String>?
    }
}

