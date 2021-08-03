//
//  DownloadsView.swift
//  task4_draft
//
//  Created by R S on 02.08.2021.
//

import SwiftUI

struct DownloadsView: View {
    let characters: FetchedResults<CharacterItem>
    
    private func getEpisodes(character: FetchedResults<CharacterItem>.Element) -> [Episode] {
        let episodes = try! JSONDecoder().decode([Episode].self, from: character.episodes!)
        return episodes
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(characters) { character in
                    NavigationLink(destination: DownloadDetailView(character: character, episodes: getEpisodes(character: character))) {
                        EmptyView()
                        Text(character.name!)
                    }
                }.onDelete(perform: { indexSet in
                    StorageManager.shared.deleteItems(characters: characters, offsets: indexSet)
                })
            }.navigationTitle("Загруженное")
        }
    }
}

struct DownloadDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    let character: FetchedResults<CharacterItem>.Element
    var episodes: [Episode]

    var body: some View {
        if character.name != nil {
            VStack(alignment: .leading, spacing: 10) {
                        Text(character.name!)
                        Text(character.gender!)
                        Text(character.status!)
                        Text(character.species!)
                Text("Местоположение").font(.title)
                Text(character.location!)
                Text(character.type!)
                Text("Эпизоды").font(.title)
                List{
                    ForEach(episodes, id: \.self) { episode in
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text(episode.episode + "/" + episode.name + "/")
                                Text(episode.air_date)
                            }.lineLimit(3)
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        StorageManager.shared.deleteItemById(id: Int(character.id))
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Удалить")
                    }
                }
            }.navigationTitle(character.name!)
        } else {
            ActivityIndicator()
        }
    }
}


