//
//  StorageManager.swift
//  task4_draft
//
//  Created by R S on 03.08.2021.
//

import CoreData
import SwiftUI

class StorageManager {
    
    static let shared = StorageManager()
    let viewContext = PersistenceController.shared.container.viewContext
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func saveCharacter(id: Int, viewModel: CharacterViewModel) {
        withAnimation {
            let characterToSave = CharacterItem(context: viewContext)
            let character = viewModel.state.characters[id]!
            characterToSave.id = Int64(id)
            characterToSave.name = character.name
            characterToSave.gender = character.gender
            characterToSave.image = character.image
            characterToSave.status = character.status
            characterToSave.species = character.species
            characterToSave.type = viewModel.state.locationTypes[viewModel.state.characters[id]!.location.name]!.type
            characterToSave.location = character.location.name
            var episodesData = [Episode]()
            for item in character.episode {
                guard let ep = viewModel.state.episodes[item] else { break }
                episodesData.append(ep)}
            let json = try! JSONEncoder().encode(episodesData)
            characterToSave.episodes = json
            saveContext()
        }
    }
    
    func deleteItems(characters: FetchedResults<CharacterItem>,offsets: IndexSet) {
        withAnimation {
            offsets.map { characters[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    func deleteItemById(id: Int) {
        withAnimation {
            let request: NSFetchRequest<CharacterItem> = CharacterItem.fetchRequest()
            do {
                let characters = try viewContext.fetch(request)
                if let character = characters.first(where: { $0.id == id }) {
                    viewContext.delete(character)
                    saveContext()
                }
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    }
    
    func checkCharacterIsExist(id: Int) -> Bool {
        let request: NSFetchRequest<CharacterItem> = CharacterItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let results = try viewContext.fetch(request)
            if results.isEmpty {
                return false
            } else {
                return true
            }
        } catch let error as NSError {
            print(error, error.userInfo)
            return false
        }
    }
}
