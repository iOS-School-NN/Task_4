//
//  CharacterList.swift
//  task4_draft
//
//  Created by R S on 02.08.2021.
//

import SwiftUI

struct CharacterList: View {
    @EnvironmentObject var viewModel: CharacterViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.state.data) { character in
                    NavigationLink(destination: CharacterDetailView(id: character.id).onAppear {
                        viewModel.fetchCharacter(characterId: character.id)
                        viewModel.fetchCharacterLocation(urlString: character.location.url)
                    }) {
                        EmptyView()
                        CharacterView(character: character).onAppear {
                            if viewModel.state.data.last == character {
                                viewModel.fetchNextPageIfPossible()
                            }
                        }
                    }
                }
            }.navigationTitle("Список персонажей")
            .onAppear(perform: viewModel.fetchNextPageIfPossible)
        }
    }
}

struct CharacterList_Previews: PreviewProvider {
    static var previews: some View {
        CharacterList()
    }
}
