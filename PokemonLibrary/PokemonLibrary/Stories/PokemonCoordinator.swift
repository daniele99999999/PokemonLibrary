//
//  PokemonCoordinator.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation
import UIKit

struct PokemonCoordinator {
    private (set) weak var rootController: UINavigationController?
}

// MARK: Start
extension PokemonCoordinator: CoordinatorProtocol {
    func start() {
        self.flowList(animated: false)
    }
}

// MARK: Create
private extension PokemonCoordinator {
    func createList() -> UIViewController {
        let dataTask = DataTaskService(session: URLSession(configuration: .default))
        let network = NetworkService(dataTask: dataTask)
        let api = ApiService(baseURL: Resources.Api.baseURL, networkService: network)
        let persistence = PersistenceService()
        let repository = RepositoryService(apiService: api, persistenceService: persistence)
        let vm = ListViewModel(repository: repository)
        vm.output.pokemonData = { pokemonData in
            DispatchQueue.main.async { self.flowDetail(animated: true, pokemonData: pokemonData) }
        }
        let vc = ListViewController(viewModel: vm)
        return vc
    }
    
    func createDetail(pokemonData: (name: String, url: URL)) -> UIViewController {
        let dataTask = DataTaskService(session: URLSession(configuration: .default))
        let network = NetworkService(dataTask: dataTask)
        let api = ApiService(baseURL: Resources.Api.baseURL, networkService: network)
        let persistence = PersistenceService()
        let repository = RepositoryService(apiService: api, persistenceService: persistence)
        let vm = DetailViewModel(repository: repository, pokemonData: pokemonData)
        let vc = DetailViewController(viewModel: vm)
        return vc
    }
}

// MARK: Flow
private extension PokemonCoordinator {
    func flowList(animated: Bool = true) {
        let vc = self.createList()
        self.rootController?.pushViewController(vc, animated: animated)
    }
    
    func flowDetail(animated: Bool = true, pokemonData: (name: String, url: URL)) {
        let vc = self.createDetail(pokemonData: pokemonData)
        self.rootController?.pushViewController(vc, animated: animated)
    }
}
