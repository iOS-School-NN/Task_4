//
//  CharacterEpisodesView.swift
//  Rick&MortyApp
//
//  Created by Alexander on 12.07.2021.
//

import UIKit

final class CharacterEpisodesView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(_ episodes: [Episode]) {
        let episodesStr = episodes.map { "\($0.name) / \($0.code) / \($0.date)" }.joined(separator: "\n - ")
        episodesTextView.text = "- " + episodesStr
    }
    
    private let episodesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Episodes:"
        return label
    }()

    private let episodesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    private func configure() {
        addSubview(episodesLabel)
        addSubview(episodesTextView)
        
        NSLayoutConstraint.activate([
            episodesLabel.topAnchor.constraint(equalTo: topAnchor),
            episodesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            episodesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            episodesTextView.topAnchor.constraint(equalTo: episodesLabel.bottomAnchor, constant: 8),
            episodesTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            episodesTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            episodesTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
