//
//  EpisodeView.swift
//  task3
//
//  Created by R S on 30.07.2021.
//

import SwiftUI

struct CharacterView: View {
    let character: Character
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: character.image)!, image: { Image(uiImage: $0).resizable() }).frame(width: 50, height: 50).background(Color.gray)
            Text(character.name)
        }
    }
}
