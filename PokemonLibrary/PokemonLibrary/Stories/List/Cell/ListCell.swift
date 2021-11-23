//
//  ListCell.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 21/11/21.
//

import Foundation
import UIKit

class ListCell: UITableViewCell
{
    private var viewModel: ListCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: ListCellViewModel) {
        self.viewModel = viewModel
        self.setupBindings()
        self.viewModel?.input.ready?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.viewModel?.input.reset?()
    }
}

private extension ListCell
{
    func setupUI() {
        self.contentView.backgroundColor = .white
        self.imageView?.image = UIImage(named: "Placeholder")
    }
    
    func setupBindings()
    {
        self.viewModel?.output.error = Self.bindOnMain { error in
            print("error: \(error)")
            // TODO gestire l'eventuale feedback di UI
        }
        
        self.viewModel?.output.reset = Self.bindOnMain { [weak self] in
            self?.textLabel?.text = nil
            self?.imageView?.image = UIImage(named: "Placeholder")
            self?.setNeedsLayout()
            self?.setNeedsDisplay()
        }
        
        self.viewModel?.output.image = Self.bindOnMain { [weak self] imageData in
            self?.imageView?.image = UIImage(data: imageData)
            self?.setNeedsLayout()
            self?.setNeedsDisplay()
        }
        
        self.viewModel?.output.name = Self.bindOnMain { [weak self] name in
            self?.textLabel?.text = name
            self?.setNeedsDisplay()
        }
    }
}
