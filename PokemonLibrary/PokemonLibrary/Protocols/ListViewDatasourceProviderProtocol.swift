//
//  ListViewDatasourceProviderProtocol.swift
//  PokemonLibrary
//
//  Created by daniele salvioni on 22/11/21.
//

import Foundation

protocol ListViewDatasourceProviderProtocol {
    var itemsCount: Int { get }
    func itemViewModel(index: Int) -> ListCellViewModel
}
