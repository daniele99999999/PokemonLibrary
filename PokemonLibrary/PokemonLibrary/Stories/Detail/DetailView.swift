//
//  DetailView.swift
//  PokemonLibrary
//
//  Created by Daniele Salvioni on 20/11/21.
//

import Foundation
import UIKit

class DetailView: UIView {

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.contentInset = .init(top: 32, left: 0, bottom: 32, right: 0)
        return view
    }()
    private lazy var contentScrollView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 0
        view.backgroundColor = .clear
        return view
    }()
    private lazy var referenceImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = .black
        return view
    }()
    private lazy var imagesStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 0
        view.backgroundColor = .clear
        return view
    }()
    private lazy var typologyTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = .black
        return view
    }()
    private lazy var typologyValuesLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .darkGray
        return view
    }()
    private lazy var statsTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.numberOfLines = 1
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = .black
        return view
    }()
    private lazy var statsValuesLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .darkGray
        return view
    }()
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .gray)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.backgroundColor = .lightGray.withAlphaComponent(0.25)
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
        
        self.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.contentView.addSubview(self.scrollView)
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        self.scrollView.addSubview(self.contentScrollView)
        NSLayoutConstraint.activate([
            self.contentScrollView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentScrollView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentScrollView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentScrollView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentScrollView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        self.contentScrollView.addSubview(self.contentStackView)
        NSLayoutConstraint.activate([
            self.contentStackView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor, constant: 32),
            self.contentStackView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.contentScrollView.trailingAnchor, constant: -32),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor)
        ])
        
        self.contentStackView.addArrangedSubview(self.referenceImageView)
        NSLayoutConstraint.activate([
            self.referenceImageView.widthAnchor.constraint(equalTo: self.referenceImageView.heightAnchor, multiplier: 1.0)
        ])
        self.contentStackView.addArrangedSubview(self.nameLabel)
        NSLayoutConstraint.activate([
            self.nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        self.contentStackView.addArrangedSubview(self.imagesStackView)
        NSLayoutConstraint.activate([
            self.imagesStackView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.15)
        ])
        self.contentStackView.addArrangedSubview(self.typologyTitleLabel)
        NSLayoutConstraint.activate([
            self.typologyTitleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        self.contentStackView.addArrangedSubview(self.typologyValuesLabel)
        self.contentStackView.addArrangedSubview(self.statsTitleLabel)
        NSLayoutConstraint.activate([
            self.statsTitleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        self.contentStackView.addArrangedSubview(self.statsValuesLabel)
        
        self.addSubview(self.loaderView)
        NSLayoutConstraint.activate([
            self.loaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.loaderView.topAnchor.constraint(equalTo: self.topAnchor),
            self.loaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.loaderView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension DetailView
{
    func startLoader() {
        self.loaderView.startAnimating()
        self.loaderView.isHidden = false
    }
    
    func stopLoader() {
        self.loaderView.stopAnimating()
        self.loaderView.isHidden = true
    }
    
    func addName(name: String) {
        self.nameLabel.text = name
    }
    
    func addReferenceImage(data: Data) {
        self.referenceImageView.image = UIImage(data: data)
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    func addImage(data: Data) {
        let image = UIImage(data: data)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        self.imagesStackView.addArrangedSubview(imageView)
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    func addTypology(title: String) {
        self.typologyTitleLabel.text = title
    }
    
    func addTypologies(values: String) {
        self.typologyValuesLabel.text = values
        self.setNeedsLayout()
    }
    
    func addStats(title: String) {
        self.statsTitleLabel.text = title
    }
    
    func addStats(values: String) {
        self.statsValuesLabel.text = values
        self.setNeedsLayout()
    }
}

