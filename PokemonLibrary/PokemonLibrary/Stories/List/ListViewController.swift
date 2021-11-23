//
//  ListViewController.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation
import UIKit

class ListViewController: UIViewController {

    let listView = ListView()
    
    private (set) var viewModel: ListViewModel
    private (set) var dataSource: DataSource

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        self.dataSource = DataSource(provider: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showBackArrowOnly()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.input.ready?()
    }
}

private extension ListViewController {
    
    func setupUI() {
        self.listView.setTableView(delegate: self, dataSource: self.dataSource)
    }
    
    func setupBindings() {
        self.viewModel.output.title = Self.bindOnMain { [weak self] title in
            self?.title = title
        }
        
        self.viewModel.output.isLoading = Self.bindOnMain { [weak self] isLoading in
            if isLoading {
                self?.listView.startLoader()
            } else {
                self?.listView.stopLoader()
            }
        }

        self.viewModel.output.error = Self.bindOnMain { error in
            print("Unhandled error: \(error)")
            // TODO gestire l'eventuale alert a schermo
        }

        self.viewModel.output.updates = Self.bindOnMain { [weak self] indexPaths in
            self?.listView.addItems(indexPaths: indexPaths)
        }
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.input.willLoadNextItems?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.viewModel.input.selectedItem?(indexPath.row)
    }
}

