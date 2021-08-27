//
//  LoaderView.swift
//  Rick&MortyApp
//
//  Created by Alexander on 14.07.2021.
//

import UIKit

final class LoaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isShown: Bool = false {
        didSet { spinnerView.isHidden = !isShown }
    }
    
    let stackView = UIStackView()
    
    let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }()
    
    private func configure() {
        backgroundColor = .white
        stackView.addArrangedSubview(spinnerView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinnerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
