//
//  ListView.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation
import UIKit

class ListView: UIView {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.rowHeight = 100
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        return tableView
    }()
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .gray)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.backgroundColor = .clear
        loader.stopAnimating()
        return loader
    }()

    init() {
        super.init(frame: .zero)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = .white
        
        self.addSubview(self.loaderView)
        NSLayoutConstraint.activate([
            self.loaderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.loaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.loaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.loaderView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        self.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension ListView
{
    func setTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        self.tableView.delegate = delegate
        self.tableView.dataSource = dataSource
    }

    func updateView() {
        self.tableView.reloadData()
    }
    
    func addItems(indexPaths: [IndexPath]) {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPaths, with: .fade)
        self.tableView.endUpdates()
    }
    
    func startLoader() {
        self.loaderView.startAnimating()
        self.loaderView.isHidden = false
    }
    
    func stopLoader() {
        self.loaderView.stopAnimating()
        self.loaderView.isHidden = true
    }
}
