//
//  Task_4App.swift
//  Task_4
//
//  Created by R S on 03.08.2021.
//

import SwiftUI

@main
struct Task_4App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(CharacterViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
