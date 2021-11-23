//
//  ListViewDatasource.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation
import UIKit

class DataSource: NSObject {
    fileprivate let provider: ListViewDatasourceProviderProtocol
    
    init(provider: ListViewDatasourceProviderProtocol) {
        self.provider = provider
    }
}

extension DataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.provider.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath) as! ListCell
        let cellViewModel = self.provider.itemViewModel(index: indexPath.row)
        cell.set(viewModel: cellViewModel)
        return cell
    }
}

