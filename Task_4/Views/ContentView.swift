//
//  ContentView.swift
//  draft
//
//  Created by R S on 01.08.2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CharacterItem.name, ascending: true)],
        animation: .default)
    private var characters: FetchedResults<CharacterItem>
    
    var body: some View {
        TabView {
            CharacterList().tabItem { Image(systemName: "list.bullet").resizable()
                Text("Персонажи")
            }
            DownloadsView(characters: characters).tabItem { Image(systemName: "arrow.down.doc").resizable()
                Text("Загруженное")
            }
            SettingsView().tabItem { Image(systemName: "slider.horizontal.3").resizable()
                Text("Настройки")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


