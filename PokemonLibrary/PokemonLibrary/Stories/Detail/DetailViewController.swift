//
//  DetailViewController.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {

    let detailView = DetailView()
    
    private (set) var viewModel: DetailViewModel

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupBindings()
        
        self.viewModel.input.ready?()
    }
}

private extension DetailViewController {
    func setupUI() {
        
    }
    
    func setupBindings() {
        self.viewModel.output.title = Self.bindOnMain { [weak self] title in
            self?.navigationItem.title = title
        }
        
        self.viewModel.output.isLoading = Self.bindOnMain { [weak self] isLoading in
            if isLoading {
                self?.detailView.startLoader()
            } else {
                self?.detailView.stopLoader()
            }
        }
        
        self.viewModel.output.error = Self.bindOnMain { error in
            print("error: \(error)")
            // TODO gestire l'eventuale alert a schermo
        }
        
        self.viewModel.output.name = Self.bindOnMain { [weak self] name in
            self?.detailView.addName(name: name)
        }
        
        self.viewModel.output.referenceImage = Self.bindOnMain { [weak self] data in
            self?.detailView.addReferenceImage(data: data)
        }
        
        self.viewModel.output.image = Self.bindOnMain { [weak self] item in
            self?.detailView.addImage(data: item.data)
        }

        self.viewModel.output.typologyTitle = Self.bindOnMain { [weak self] title in
            self?.detailView.addTypology(title: title)
        }
        
        self.viewModel.output.typologies = Self.bindOnMain { [weak self] typologies in
            self?.detailView.addTypologies(values: typologies)
        }
        
        self.viewModel.output.statsTitle = Self.bindOnMain { [weak self] title in
            self?.detailView.addStats(title: title)
        }
        
        self.viewModel.output.stats = Self.bindOnMain { [weak self] stats in
            self?.detailView.addStats(values: stats)
        }
    }
}


