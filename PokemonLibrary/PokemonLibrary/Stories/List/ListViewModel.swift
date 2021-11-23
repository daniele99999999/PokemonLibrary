//
//  ListViewModel.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation

class ListViewModel {
    let input = Input()
    let output = Output()
    
    private let repository: RepositoryProtocol
    
    private let limit: Int
    private var page: Int
    private var maxPage: Int
    private var fetchNewData: Bool
    
    private var offset: Int {
        self.limit * (self.page - 1)
    }
    private var list: [PokemonList.Item] = []
    
    init(repository: RepositoryProtocol, limit: Int = 20, page: Int = 1) {
        self.repository = repository
        self.limit = limit
        self.page = page
        self.maxPage = page
        self.fetchNewData = true
        
        self.input.ready = self.ready
        self.input.willLoadNextItems = self.willLoadNextItems(index:)
        self.input.selectedItem = self.selectedItem(index:)
    }
}

private extension ListViewModel {
    func ready() {
        self.output.title?("Pokemon List")
        
        self.fetchItems()
    }
    
    func fetchItems() {
        guard self.fetchNewData else { return }
        self.fetchNewData = false
        
        self.output.isLoading?(true)
        self.repository.getList(limit: self.limit, offset: self.offset) { [weak self] result in
            guard let self = self else { return }
            defer { self.output.isLoading?(false) }
            switch result {
            case .success(let pokemonList):
                self.maxPage = Int(ceilf(Float(pokemonList.count)/Float(self.limit)))
                let indexPaths = (self.list.count..<self.list.count + pokemonList.results.count).map {
                    return IndexPath(item: $0, section: 0)
                }
                
                self.list.append(contentsOf: pokemonList.results)
                self.output.updates?(indexPaths)
            case .failure(let error):
                self.output.error?(error.localizedDescription)
            }
        }
    }
    
    func selectedItem(index: Int) {
        let item = self.list[index]
        self.output.pokemonData?((name: item.name, url: item.url))
    }
    
    func willLoadNextItems(index: Int) {
        guard index == (self.list.count - 1) else { return }
        if self.page < self.maxPage {
            self.fetchNewData = true
            self.page += 1
            self.fetchItems()
        }
    }
    
    func cellViewModel(index: Int) -> ListCellViewModel {
        let item = self.list[index]
        return ListCellViewModel(name: item.name, url: item.url, repository: self.repository)
    }
}

extension ListViewModel: ListViewDatasourceProviderProtocol {
    var itemsCount: Int {
        return self.list.count
    }
    
    func itemViewModel(index: Int) -> ListCellViewModel {
        return self.cellViewModel(index: index)
    }
}

extension ListViewModel {
    class Input {
        var ready: VoidClosure?
        var willLoadNextItems: VoidOutputClosure<Int>?
        var selectedItem: VoidOutputClosure<Int>?
    }
    
    class Output {
        var title: VoidOutputClosure<String>?
        var isLoading: VoidOutputClosure<Bool>?
        var error: VoidOutputClosure<String>?
        var updates: VoidOutputClosure<[IndexPath]>?
        var pokemonData: VoidOutputClosure<(name: String, url: URL)>?
    }
}
