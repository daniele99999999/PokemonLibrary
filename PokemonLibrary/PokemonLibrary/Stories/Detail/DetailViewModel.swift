//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation

class DetailViewModel {
    let input = Input()
    let output = Output()
    
    private let repository: RepositoryProtocol
    
    private let name: String
    private let url: URL
    
    init(repository: RepositoryProtocol, pokemonData: (name: String, url: URL))
    {
        self.repository = repository
        self.name = pokemonData.name
        self.url = pokemonData.url

        self.input.ready = self.ready
    }
}

private extension DetailViewModel {
    func ready() {
        self.output.title?("Pokemon Detail")
        self.output.typologyTitle?("Typology")
        self.output.statsTitle?("Stats")
        
        self.output.isLoading?(true)
        self.repository.getDetail(url: self.url) { [weak self] result in
            guard let self = self else { return }
            defer { self.output.isLoading?(false) }
            switch result {
            case .success(let pokemonDetail):
                self.output.name?(pokemonDetail.name)
                let stats = pokemonDetail.stats.map{ "\($0.nameStat): \($0.baseStat)" }
                self.output.stats?(stats.joined(separator: "\n"))
                
                let types = pokemonDetail.types.map{$0.nameType}
                self.output.typologies?(types.joined(separator: "\n"))
                
                pokemonDetail.sprites.allSprites.enumerated().forEach { [weak self] index, url in
                    self?.loadImage(url: url, index: index)
                }
            case .failure(let error):
                self.output.error?(error.localizedDescription)
            }
        }
    }
    
    func loadImage(url: URL, index: Int)
    {
        _ = self.repository.getImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageData):
                if index == 0 {
                    self.output.referenceImage?(imageData)
                } else {
                    self.output.image?((index: index, data: imageData))
                }
            case .failure(let error):
                self.output.error?(error.localizedDescription)
            }
        }
    }
}

extension DetailViewModel {
    class Input {
        var ready: VoidClosure?
    }
    
    class Output {
        var title: VoidOutputClosure<String>?
        var isLoading: VoidOutputClosure<Bool>?
        var error: VoidOutputClosure<String>?
        var name: VoidOutputClosure<String>?
        var referenceImage: VoidOutputClosure<Data>?
        var image: VoidOutputClosure<(index: Int, data: Data)>?
        var typologyTitle: VoidOutputClosure<String>?
        var typologies: VoidOutputClosure<String>?
        var statsTitle: VoidOutputClosure<String>?
        var stats: VoidOutputClosure<String>?
    }
}
